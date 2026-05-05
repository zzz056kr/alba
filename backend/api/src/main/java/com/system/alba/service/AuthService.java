package com.system.alba.service;

import com.system.alba.common.AppResultCode;
import com.system.alba.common.AppType;
import com.system.alba.config.AppCodeProperties;
import com.system.alba.config.security.TokenProvider;
import com.system.alba.exception.ServerException;
import com.system.alba.model.domain.Account;
import com.system.alba.model.domain.Token;
import com.system.alba.model.dto.AccountDto;
import com.system.alba.model.dto.TokenDto;
import com.system.alba.repository.AccountRepository;
import com.system.alba.repository.TokenRepository;
import com.system.alba.service.auth.AuthVerificationService;
import com.system.alba.service.cache.TokenCacheService;
import com.system.alba.service.common.ThrowService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionTemplate;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(rollbackFor = Exception.class, propagation = Propagation.REQUIRED)
public class AuthService {
    private static final String SERVICE = "AUTH";

    private final ThrowService throwService;
    private final AccountRepository accountRepository;
    private final TokenRepository tokenRepository;
    private final TokenProvider tokenProvider;
    private final AppCodeProperties appCodeProperties;
    private final TokenCacheService tokenCacheService;
    private final TokenService tokenService;
    private final AccountService accountService;
    private final AuthVerificationService authVerificationService;
    private final PasswordEncoder passwordEncoder;
    private final PlatformTransactionManager transactionManager;

    public TokenDto.Detail login(AccountDto.LoginForm form) throws ServerException {
        final String CATEGORY = "LOGIN";

        String id = form.getId();
        Account account = accountService.activeUserCheck(SERVICE, CATEGORY, id);

        // 로그인 실패 제한 확인 (0이면 무제한)
        int loginFailLimit = appCodeProperties.getAuth().getLoginFailLimit();
        if (loginFailLimit > 0) {
            int failCount = account.getLoginFailCount() != null ? account.getLoginFailCount() : 0;
            if (failCount >= loginFailLimit) {
                throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.FORBIDDEN, "RESULT_ACCOUNT_LOCKED");
            }
        }

        String password = account.getPassword();
        String formPassword = form.getPassword();
        boolean samePassword = passwordEncoder.matches(formPassword, password);
        if (!samePassword) {
            // 로그인 실패 횟수 증가 (별도 트랜잭션으로 처리)
            if (loginFailLimit > 0) {
                incrementLoginFailCount(account.getNo());
            }
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.UNAUTHORIZED, "RESULT_INVALID_PASSWORD");
        }

        // 로그인 성공 시 실패 횟수 초기화
        if (account.getLoginFailCount() != null && account.getLoginFailCount() > 0) {
            account.setLoginFailCount(0);
            accountRepository.save(account);
        }

        return tokenService.createTokenWithMultiLoginCheck(account);
    }

    public TokenDto.Detail join(AccountDto.JoinForm form) throws ServerException {
        final String CATEGORY = "JOIN";

        String id = form.getId();
        String password = form.getPassword();
        String email = form.getEmail();

        AppCodeProperties.Regex idRegex = appCodeProperties.getAuth().getId();
        if (!id.matches(idRegex.getRegex())) {
            String message = idRegex.getMessage() != null ? idRegex.getMessage() : "RESULT_INVALID_ID_FORMAT";
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.BAD_REQUEST, message);
        }

        Account account = accountRepository.findByLoginId(id).orElse(null);
        // ID 중복 확인
        if (account != null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.CONFLICT, "RESULT_DUPLICATED_ID");
        }

        account = accountRepository.findByEmailAndProvider(email, AppType.AuthProvider.LOCAL).orElse(null);
        // EMAIL 중복 확인
        if (account != null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.CONFLICT, "RESULT_DUPLICATED_EMAIL");
        }

        // 이메일 인증 필수 여부 확인 (email 모듈 비활성화 시 항상 false)
        boolean emailVerificationRequired = authVerificationService.isVerificationSupported()
                && appCodeProperties.getAuth().getEmail().isVerificationRequired();

        AppCodeProperties.Regex passwordRegex = appCodeProperties.getAuth().getPassword();
        if (!password.matches(passwordRegex.getRegex())) {
            String message = passwordRegex.getMessage() != null ? passwordRegex.getMessage() : "RESULT_INVALID_PASSWORD_FORMAT";
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.BAD_REQUEST, message);
        }

        account = new Account();
        AccountDto.JoinForm.Mapper.INSTANCE.updateSourceToDestination(form, account);
        account.setPassword(passwordEncoder.encode(password));
        account.setStatus(AppType.Status.ACTIVE);
        account.setProvider(AppType.AuthProvider.LOCAL);

        // 이메일 인증 필수인 경우 GUEST, 아닌 경우 USER
        if (emailVerificationRequired) {
            account.setRoles(List.of(AppType.AccountRole.GUEST));
        } else {
            account.setRoles(List.of(AppType.AccountRole.USER));
        }

        account = accountRepository.save(account);

        // GUEST인 경우 인증 이메일 발송 (회원가입 시에는 재발송 제한 체크 안함)
        if (emailVerificationRequired) {
            authVerificationService.sendJoinVerification(account, email);
        }
        return tokenService.createTokenWithMultiLoginCheck(account);
    }

    public TokenDto.Detail refreshToken(String refreshToken) throws ServerException {
        final String CATEGORY = "REFRESH";

        // 기존 토큰 조회
        Token existingToken = tokenRepository.findByRefreshToken(refreshToken).orElse(null);
        if (existingToken == null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.UNAUTHORIZED, "RESULT_TOKEN_REFRESH_INVALID");
        }

        // 토큰 유효성 검증
        if (!existingToken.isRefreshValid()) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.UNAUTHORIZED, "RESULT_TOKEN_REFRESH_EXPIRED");
        }

        // 계정 활성 상태 확인
        Account account = existingToken.getAccount();
        if (!account.isActive()) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.FORBIDDEN, "RESULT_ACCOUNT_INACTIVE");
        }

        // 기존 토큰 캐시 삭제
        tokenCacheService.evict(existingToken.getAccessToken());

        // 기존 토큰 무효화
        existingToken.revoke(AppType.TokenRevokeReason.REFRESH_TOKEN_USED);
        tokenRepository.save(existingToken);

        // 새로운 토큰 생성
        return tokenService.createToken(account);
    }

    public void logout(String refreshToken) {
        Token token = tokenRepository.findByRefreshToken(refreshToken).orElse(null);
        if (token != null) {
            // 토큰 캐시 삭제
            tokenCacheService.evict(token.getAccessToken());

            token.revoke(AppType.TokenRevokeReason.LOGOUT);
            tokenRepository.save(token);
        }
    }

    /**
     * 로그인 실패 횟수 증가 (별도 트랜잭션)
     * 메인 트랜잭션이 롤백되어도 실패 횟수는 유지됨
     */
    private void incrementLoginFailCount(Long accountNo) {
        TransactionTemplate template = new TransactionTemplate(transactionManager);
        template.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
        template.executeWithoutResult(status -> {
            accountRepository.findById(accountNo).ifPresent(account -> {
                int failCount = account.getLoginFailCount() != null ? account.getLoginFailCount() : 0;
                account.setLoginFailCount(failCount + 1);
                accountRepository.save(account);
            });
        });
    }
}
