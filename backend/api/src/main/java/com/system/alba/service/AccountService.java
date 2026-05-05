package com.system.alba.service;

import com.system.alba.common.AppResultCode;
import com.system.alba.common.AppType;
import com.system.alba.config.AppCodeProperties;
import com.system.alba.exception.ServerException;
import com.system.alba.model.PageListDto;
import com.system.alba.model.domain.Account;
import com.system.alba.model.dto.AccountDto;
import com.system.alba.repository.AccountRepository;
import com.system.alba.service.auth.AuthVerificationService;
import com.system.alba.service.cache.TokenCacheService;
import com.system.alba.service.common.ThrowService;
import jakarta.persistence.criteria.Predicate;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(rollbackFor = Exception.class, propagation = Propagation.REQUIRED)
public class AccountService {
    private static final String SERVICE = "ACCOUNT";

    private final ThrowService throwService;
    private final AccountRepository accountRepository;
    private final TokenCacheService tokenCacheService;
    private final AppCodeProperties appCodeProperties;
    private final TokenService tokenService;
    private final AuthVerificationService authVerificationService;
    private final PasswordEncoder passwordEncoder;

    @Transactional(readOnly = true)
    public PageListDto.Response<AccountDto.Summary> list(AccountDto.SearchParams params) {
        Sort sort = Sort.by(Sort.Direction.DESC, "no");
        PageRequest pageable = PageRequest.of(Math.max(params.getPage() - 1, 0), params.getSize(), sort);

        Specification<Account> spec = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();

            if (params.getKeyword() != null && !params.getKeyword().isBlank()) {
                String like = "%" + params.getKeyword().toLowerCase() + "%";
                predicates.add(cb.or(
                        cb.like(cb.lower(root.get("id")), like),
                        cb.like(cb.lower(root.get("name")), like),
                        cb.like(cb.lower(root.get("email")), like)
                ));
            }

            if (params.getStatuses() != null && !params.getStatuses().isEmpty()) {
                predicates.add(root.get("status").in(params.getStatuses()));
            }

            if (params.getRoles() != null && !params.getRoles().isEmpty()) {
                List<Predicate> rolePredicates = new ArrayList<>();
                for (AppType.AccountRole role : params.getRoles()) {
                    String roleName = role.name();
                    jakarta.persistence.criteria.Expression<String> rolesAsString = root.get("roles").as(String.class);
                    rolePredicates.add(cb.or(
                            cb.equal(rolesAsString, roleName),
                            cb.like(rolesAsString, roleName + ",%"),
                            cb.like(rolesAsString, "%," + roleName + ",%"),
                            cb.like(rolesAsString, "%," + roleName)
                    ));
                }
                predicates.add(cb.or(rolePredicates.toArray(new Predicate[0])));
            }

            return cb.and(predicates.toArray(new Predicate[0]));
        };

        Page<Account> page = accountRepository.findAll(spec, pageable);
        PageListDto.Response<AccountDto.Summary> response = new PageListDto.Response<>();
        response.pageToResponse(page, AccountDto.Summary.Mapper.INSTANCE);
        return response;
    }

    @Transactional(readOnly = true)
    public AccountDto.Detail getAccount(String accountId) throws ServerException {
        Account account = accountRepository.findByLoginId(accountId).orElse(null);
        if (account == null) {
            throw throwService.throwErrorByCode(SERVICE, "GET_ACCOUNT", AppResultCode.NOT_FOUND, "RESULT_ACCOUNT_NOT_FOUND");
        }
        return AccountDto.Detail.Mapper.INSTANCE.sourceToDestination(account);
    }

    @Transactional(readOnly = true)
    public AccountDto.Detail me(Authentication authentication) throws ServerException {
        final String CATEGORY = "CURRENT_USER";

        String principalName = authentication.getName();
        if (principalName == null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.UNAUTHORIZED, "RESULT_UNAUTHORIZED");
        }

        Account account = activeUserCheckByPrincipalName(SERVICE, CATEGORY, principalName);

        AccountDto.Detail data = AccountDto.Detail.Mapper.INSTANCE.sourceToDestination(account);
        return data;
    }

    public AccountDto.Detail updateMe(AccountDto.UpdateForm form, Authentication authentication) throws ServerException {
        final String CATEGORY = "UPDATE_ME";

        String principalName = authentication.getName();
        if (principalName == null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.UNAUTHORIZED, "RESULT_UNAUTHORIZED");
        }

        Account account = activeUserCheckByPrincipalName(SERVICE, CATEGORY, principalName);

        if (form.getEmail() != null && !form.getEmail().equals(account.getEmail())) {
            Account existingAccount = accountRepository.findByEmailAndProvider(form.getEmail(), AppType.AuthProvider.LOCAL).orElse(null);
            if (existingAccount != null && !existingAccount.getNo().equals(account.getNo())) {
                throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.CONFLICT, "RESULT_DUPLICATED_EMAIL");
            }
        }

        AccountDto.UpdateForm.Mapper.INSTANCE.updateSourceToDestination(form, account);
        account = accountRepository.save(account);

        tokenCacheService.evictByAccountNo(account.getNo());

        AccountDto.Detail data = AccountDto.Detail.Mapper.INSTANCE.sourceToDestination(account);
        return data;
    }

    public AccountDto.Detail createAccount(AccountDto.CreateForm form) throws ServerException {
        final String CATEGORY = "CREATE_ACCOUNT";

        Account existing = accountRepository.findByLoginId(form.getId()).orElse(null);
        if (existing != null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.CONFLICT, "RESULT_DUPLICATED_ID");
        }

        Account existingEmail = accountRepository.findByEmailAndProvider(form.getEmail(), AppType.AuthProvider.LOCAL).orElse(null);
        if (existingEmail != null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.CONFLICT, "RESULT_DUPLICATED_EMAIL");
        }

        Account account = new Account();
        AccountDto.CreateForm.Mapper.INSTANCE.updateSourceToDestination(form, account);
        account.setPassword(passwordEncoder.encode(form.getPassword()));
        account.setStatus(AppType.Status.ACTIVE);
        account.setProvider(AppType.AuthProvider.LOCAL);
        account.setRoles(List.of(AppType.AccountRole.GUEST));

        account = accountRepository.save(account);
        return AccountDto.Detail.Mapper.INSTANCE.sourceToDestination(account);
    }

    // AuthService도 공유 사용 — service명을 파라미터로 받아 에러 컨텍스트 유지
    public Account activeUserCheck(String service, String category, String id) {
        Account account = accountRepository.findByLoginId(id).orElse(null);
        if (account == null) {
            throw throwService.throwErrorByCode(service, category, AppResultCode.NOT_FOUND, "RESULT_ACCOUNT_NOT_FOUND");
        }

        boolean activeYn = account.isActive();
        if (!activeYn) {
            throw throwService.throwErrorByCode(service, category, AppResultCode.FORBIDDEN, "RESULT_ACCOUNT_INACTIVE");
        }

        return account;
    }

    public Account activeUserCheckByPrincipalName(String service, String category, String principalName) {
        Account account = accountRepository.findById(Long.parseLong(principalName)).orElse(null);
        if (account == null) {
            throw throwService.throwErrorByCode(service, category, AppResultCode.NOT_FOUND, "RESULT_ACCOUNT_NOT_FOUND");
        }

        if (!account.isActive()) {
            throw throwService.throwErrorByCode(service, category, AppResultCode.FORBIDDEN, "RESULT_ACCOUNT_INACTIVE");
        }

        return account;
    }

    public AccountDto.Detail editAccount(String accountId, AccountDto.EditForm form) throws ServerException {
        final String CATEGORY = "EDIT_ACCOUNT";

        Account account = accountRepository.findByLoginId(accountId).orElse(null);
        if (account == null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.NOT_FOUND, "RESULT_ACCOUNT_NOT_FOUND");
        }

        if (form.getEmail() != null && !form.getEmail().equals(account.getEmail())) {
            Account existingAccount = accountRepository.findByEmailAndProvider(form.getEmail(), AppType.AuthProvider.LOCAL).orElse(null);
            if (existingAccount != null && !existingAccount.getId().equals(accountId)) {
                throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.CONFLICT, "RESULT_DUPLICATED_EMAIL");
            }
        }

        AccountDto.EditForm.Mapper.INSTANCE.updateSourceToDestination(form, account);
        account = accountRepository.save(account);

        tokenCacheService.evictByAccountNo(account.getNo());

        return AccountDto.Detail.Mapper.INSTANCE.sourceToDestination(account);
    }

    public void changeMyPassword(AccountDto.ChangePasswordForm form, Authentication authentication) throws ServerException {
        final String CATEGORY = "CHANGE_MY_PASSWORD";

        String principalName = authentication.getName();
        if (principalName == null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.UNAUTHORIZED, "RESULT_UNAUTHORIZED");
        }

        Account account = activeUserCheckByPrincipalName(SERVICE, CATEGORY, principalName);
        if (!passwordEncoder.matches(form.getCurrentPassword(), account.getPassword())) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.UNAUTHORIZED, "RESULT_INVALID_PASSWORD");
        }

        updatePassword(account, form.getNewPassword(), CATEGORY);
    }

    public void changePasswordByAdmin(String accountId, AccountDto.AdminChangePasswordForm form) throws ServerException {
        final String CATEGORY = "ADMIN_CHANGE_PASSWORD";

        Account account = accountRepository.findByLoginId(accountId).orElse(null);
        if (account == null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.NOT_FOUND, "RESULT_ACCOUNT_NOT_FOUND");
        }

        updatePassword(account, form.getNewPassword(), CATEGORY);
    }

    public void sendMyPasswordChangeCode(Authentication authentication) throws ServerException {
        final String CATEGORY = "SEND_MY_PASSWORD_CHANGE_CODE";

        Account account = getAuthenticatedAccount(CATEGORY, authentication);
        if (account.getEmail() == null || account.getEmail().isBlank()) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.BAD_REQUEST, "RESULT_ACCOUNT_EMAIL_EMPTY");
        }

        authVerificationService.sendPasswordResetVerification(account, account.getEmail());
    }

    public void changeMyPasswordByCode(AccountDto.ChangePasswordByCodeForm form, Authentication authentication) throws ServerException {
        final String CATEGORY = "CHANGE_MY_PASSWORD_BY_CODE";

        Account account = getAuthenticatedAccount(CATEGORY, authentication);
        if (account.getEmail() == null || account.getEmail().isBlank()) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.BAD_REQUEST, "RESULT_ACCOUNT_EMAIL_EMPTY");
        }

        authVerificationService.verifyPasswordReset(account.getEmail(), form.getCode());
        updatePassword(account, form.getNewPassword(), CATEGORY);
    }

    private Account getAuthenticatedAccount(String category, Authentication authentication) throws ServerException {
        String principalName = authentication.getName();
        if (principalName == null) {
            throw throwService.throwErrorByCode(SERVICE, category, AppResultCode.UNAUTHORIZED, "RESULT_UNAUTHORIZED");
        }

        return activeUserCheckByPrincipalName(SERVICE, category, principalName);
    }

    private void updatePassword(Account account, String rawPassword, String category) throws ServerException {
        validatePasswordFormat(rawPassword, category);

        account.setPassword(passwordEncoder.encode(rawPassword));
        account.setPasswordModifiedAt(LocalDateTime.now());
        accountRepository.save(account);

        tokenService.revokeExistingTokens(account.getId());
        tokenCacheService.evictByAccountNo(account.getNo());
    }

    private void validatePasswordFormat(String password, String category) throws ServerException {
        AppCodeProperties.Regex passwordRegex = appCodeProperties.getAuth().getPassword();
        if (!password.matches(passwordRegex.getRegex())) {
            String message = passwordRegex.getMessage() != null ? passwordRegex.getMessage() : "RESULT_INVALID_PASSWORD_FORMAT";
            throw throwService.throwErrorByCode(SERVICE, category, AppResultCode.BAD_REQUEST, message);
        }
    }

}
