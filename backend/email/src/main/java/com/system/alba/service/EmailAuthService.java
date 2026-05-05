package com.system.alba.service;

import com.system.alba.common.AppResultCode;
import com.system.alba.common.AppType;
import com.system.alba.config.AppCodeProperties;
import com.system.alba.exception.ServerException;
import com.system.alba.model.domain.Account;
import com.system.alba.model.domain.email.EmailAuthCode;
import com.system.alba.model.domain.Token;
import com.system.alba.repository.AccountRepository;
import com.system.alba.repository.email.EmailAuthCodeRepository;
import com.system.alba.repository.TokenRepository;
import com.system.alba.service.auth.AuthVerificationService;
import com.system.alba.service.cache.TokenCacheService;
import com.system.alba.service.common.ThrowService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.List;

@Slf4j
@Primary
@Service
@RequiredArgsConstructor
@Transactional(rollbackFor = Exception.class, propagation = Propagation.REQUIRED)
public class EmailAuthService implements AuthVerificationService {
    private static final String SERVICE = "EMAIL_AUTH";

    private final ThrowService throwService;
    private final EmailService emailService;
    private final EmailAuthCodeRepository emailAuthCodeRepository;
    private final AccountRepository accountRepository;
    private final TokenRepository tokenRepository;
    private final AppCodeProperties appCodeProperties;
    private final TokenCacheService tokenCacheService;

    /**
     * 인증 코드 발송
     */
    public void sendAuthCode(String email, AppType.EmailAuthType type) {
        sendAuthCode(null, email, type);
    }

    /**
     * 인증 코드 발송 (계정 연결)
     */
    public void sendAuthCode(Account account, String email, AppType.EmailAuthType type) {
        sendAuthCode(account, email, type, true);
    }

    /**
     * 인증 코드 발송 (계정 연결, 재발송 제한 옵션)
     */
    public void sendAuthCode(Account account, String email, AppType.EmailAuthType type, boolean checkResendLimit) {
        final String CATEGORY = "SEND";

        // 재발송 제한 확인
        if (checkResendLimit) {
            AppCodeProperties.Email emailProps = appCodeProperties.getAuth().getEmail();
            int resendSeconds = emailProps.getResendSeconds();
            int failResendSeconds = emailProps.getFailResendSeconds();

            emailAuthCodeRepository.findTopByEmailAndTypeOrderByCreatedAtDesc(email, type)
                    .ifPresent(lastCode -> {
                        // 이전 발송 실패 시 최소 시간 적용, 성공 시 기본 시간 적용
                        int waitSeconds = Boolean.FALSE.equals(lastCode.getSendSuccessYn()) ? failResendSeconds : resendSeconds;
                        if (waitSeconds > 0) {
                            LocalDateTime canResendAt = lastCode.getCreatedAt().plusSeconds(waitSeconds);
                            if (LocalDateTime.now().isBefore(canResendAt)) {
                                throw throwService.throwErrorByCode(
                                        SERVICE, CATEGORY, AppResultCode.TOO_MANY_REQUESTS, "RESULT_EMAIL_AUTH_RESEND_LIMIT");
                            }
                        }
                    });
        }

        String code = generateCode();
        int expireMinutes = appCodeProperties.getAuth().getEmail().getExpireMinutes();

        EmailAuthCode authCode = new EmailAuthCode();
        authCode.setAccount(account);
        authCode.setEmail(email);
        authCode.setCode(code);
        authCode.setType(type);
        authCode.setExpiredAt(LocalDateTime.now().plusMinutes(expireMinutes));
        authCode.setVerifiedYn(false);

        emailAuthCodeRepository.save(authCode);
        emailService.sendAuthCode(account, email, code, authCode.getNo());

        log.info("Auth code sent to: {}, type: {}", email, type);
    }

    @Override
    public boolean isVerificationSupported() {
        return true;
    }

    @Override
    public void sendJoinVerification(Account account, String email) throws ServerException {
        sendAuthCode(account, email, AppType.EmailAuthType.JOIN, false);
    }

    @Override
    public void sendPasswordResetVerification(Account account, String email) throws ServerException {
        sendAuthCode(account, email, AppType.EmailAuthType.PASSWORD_RESET, true);
    }

    /**
     * 인증 코드 검증
     */
    public void verify(String email, String code, AppType.EmailAuthType type) throws ServerException {
        final String CATEGORY = "VERIFY";

        // 가장 최근 인증 코드 조회
        EmailAuthCode authCode = emailAuthCodeRepository
                .findTopByEmailAndTypeOrderByCreatedAtDesc(email, type)
                .orElseThrow(() -> throwService.throwErrorByCode(
                        SERVICE, CATEGORY, AppResultCode.NOT_FOUND, "RESULT_EMAIL_AUTH_CODE_NOT_FOUND"));

        if (authCode.isExpired()) {
            throw throwService.throwErrorByCode(
                    SERVICE, CATEGORY, AppResultCode.BAD_REQUEST, "RESULT_EMAIL_AUTH_CODE_EXPIRED");
        }

        if (Boolean.TRUE.equals(authCode.getVerifiedYn())) {
            throw throwService.throwErrorByCode(
                    SERVICE, CATEGORY, AppResultCode.BAD_REQUEST, "RESULT_EMAIL_AUTH_CODE_ALREADY_VERIFIED");
        }

        // 실패 횟수 제한 확인
        int failLimit = appCodeProperties.getAuth().getEmail().getFailLimit();
        int currentFailCount = authCode.getFailCount() != null ? authCode.getFailCount() : 0;

        if (failLimit > 0 && currentFailCount >= failLimit) {
            throw throwService.throwErrorByCode(
                    SERVICE, CATEGORY, AppResultCode.TOO_MANY_REQUESTS, "RESULT_EMAIL_AUTH_FAIL_LIMIT");
        }

        // 코드 일치 확인
        if (!code.equals(authCode.getCode())) {
            authCode.setFailCount(currentFailCount + 1);
            emailAuthCodeRepository.save(authCode);
            throw throwService.throwErrorByCode(
                    SERVICE, CATEGORY, AppResultCode.BAD_REQUEST, "RESULT_EMAIL_AUTH_CODE_INVALID");
        }

        authCode.setVerifiedYn(true);
        emailAuthCodeRepository.save(authCode);

        // JOIN 타입인 경우 GUEST → USER 역할 업그레이드
        if (AppType.EmailAuthType.JOIN == type) {
            upgradeRoleIfGuest(email);
        }

        log.info("Auth code verified for: {}, type: {}", email, type);
    }

    @Override
    public void verifyPasswordReset(String email, String code) throws ServerException {
        verify(email, code, AppType.EmailAuthType.PASSWORD_RESET);
    }

    /**
     * GUEST 역할인 경우 USER로 업그레이드
     */
    private void upgradeRoleIfGuest(String email) {
        Account account = accountRepository.findByEmailAndProvider(email, AppType.AuthProvider.LOCAL).orElse(null);
        if (account != null && account.getRoles() != null
                && account.getRoles().contains(AppType.AccountRole.GUEST)) {
            List<AppType.AccountRole> upgradedRoles = List.of(AppType.AccountRole.USER);
            account.setRoles(upgradedRoles);
            accountRepository.save(account);
            syncActiveTokenRoles(account.getId(), upgradedRoles);
            log.info("Role upgraded from GUEST to USER for: {}", email);
        }
    }

    private void syncActiveTokenRoles(String accountId, List<AppType.AccountRole> roles) {
        List<Token> tokens = tokenRepository.findByAccount_Id(accountId);
        for (Token token : tokens) {
            if (!token.isValid()) {
                continue;
            }
            token.setRoles(roles);
        }

        tokenRepository.saveAll(tokens);

        for (Token token : tokens) {
            if (!token.isValid()) {
                continue;
            }
            tokenCacheService.put(token);
        }
    }

    /**
     * 이메일 인증 여부 확인
     */
    @Transactional(readOnly = true)
    public boolean isVerified(String email, AppType.EmailAuthType type) {
        return emailAuthCodeRepository
                .findTopByEmailAndTypeOrderByCreatedAtDesc(email, type)
                .map(authCode -> Boolean.TRUE.equals(authCode.getVerifiedYn()) && !authCode.isExpired())
                .orElse(false);
    }

    /**
     * 인증 코드 생성 (6자리 숫자)
     */
    private String generateCode() {
        SecureRandom random = new SecureRandom();
        int code = random.nextInt(900000) + 100000;
        return String.valueOf(code);
    }
}
