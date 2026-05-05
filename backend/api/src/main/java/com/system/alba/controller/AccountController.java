package com.system.alba.controller;

import com.system.alba.common.AppConstants;
import com.system.alba.common.Loggable;
import com.system.alba.config.AppProperties;
import com.system.alba.config.security.AuthHeaderHandler;
import com.system.alba.exception.ServerException;
import com.system.alba.model.PageListDto;
import com.system.alba.model.ResponseModel;
import com.system.alba.model.dto.AccountDto;
import com.system.alba.model.dto.TokenDto;
import com.system.alba.service.AccountService;
import com.system.alba.service.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/account")
@RequiredArgsConstructor
public class AccountController {

    private final AccountService accountService;
    private final AuthService authService;
    private final AuthHeaderHandler authHeaderHandler;
    private final AppProperties appProperties;

    @PostMapping("/join")
    @Loggable(saveTypes = {AppConstants.LOGGABLE_TYPE.Request})
    public ResponseEntity<ResponseModel<TokenDto.TokenResponse>> join(@Valid @RequestBody AccountDto.JoinForm form) throws ServerException {
        TokenDto.Detail token = authService.join(form);
        HttpHeaders headers = authHeaderHandler.getTokenHeaders(token);

        TokenDto.TokenResponse data = TokenDto.TokenResponse.Mapper.INSTANCE.sourceToDestination(token);
        data.setAccessTokenExpiresIn(appProperties.getAuth().getAccessExpiresSeconds());

        return ResponseEntity.ok()
                .headers(headers)
                .body(new ResponseModel<>(data));
    }

    @PostMapping
    @PreAuthorize("hasRole('SUPER_ADMIN')")
    @Loggable(saveTypes = {AppConstants.LOGGABLE_TYPE.Request})
    public ResponseEntity<ResponseModel<AccountDto.Detail>> createAccount(@Valid @RequestBody AccountDto.CreateForm form) throws ServerException {
        AccountDto.Detail data = accountService.createAccount(form);
        return ResponseModel.ok(data);
    }

    @GetMapping("/list")
    @PreAuthorize("hasRole('SUPER_ADMIN')")
    public ResponseEntity<ResponseModel<PageListDto.Response<AccountDto.Summary>>> list(AccountDto.SearchParams params) {
        PageListDto.Response<AccountDto.Summary> data = accountService.list(params);
        return ResponseModel.ok(data);
    }

    @GetMapping("/{accountId}")
    @PreAuthorize("hasRole('SUPER_ADMIN')")
    public ResponseEntity<ResponseModel<AccountDto.Detail>> getAccount(@PathVariable String accountId) throws ServerException {
        AccountDto.Detail data = accountService.getAccount(accountId);
        return ResponseModel.ok(data);
    }

    @GetMapping("/me")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<ResponseModel<AccountDto.Detail>> me(Authentication authentication) throws ServerException {
        AccountDto.Detail data = accountService.me(authentication);
        return ResponseModel.ok(data);
    }

    @PutMapping("/me")
    @PreAuthorize("isAuthenticated()")
    @Loggable(saveTypes = {AppConstants.LOGGABLE_TYPE.Request})
    public ResponseEntity<ResponseModel<AccountDto.Detail>> updateMe(@Valid @RequestBody AccountDto.UpdateForm form, Authentication authentication) throws ServerException {
        AccountDto.Detail data = accountService.updateMe(form, authentication);
        return ResponseModel.ok(data);
    }

    @PutMapping("/me/password")
    @PreAuthorize("isAuthenticated()")
    @Loggable(saveTypes = {AppConstants.LOGGABLE_TYPE.Request})
    public ResponseEntity<ResponseModel<Void>> changeMyPassword(@Valid @RequestBody AccountDto.ChangePasswordForm form, Authentication authentication) throws ServerException {
        accountService.changeMyPassword(form, authentication);
        return ResponseModel.ok(null);
    }

    @PostMapping("/me/password/code")
    @PreAuthorize("isAuthenticated()")
    @Loggable(saveTypes = {AppConstants.LOGGABLE_TYPE.Request})
    public ResponseEntity<ResponseModel<Void>> sendMyPasswordChangeCode(Authentication authentication) throws ServerException {
        accountService.sendMyPasswordChangeCode(authentication);
        return ResponseModel.ok(null);
    }

    @PutMapping("/me/password/code")
    @PreAuthorize("isAuthenticated()")
    @Loggable(saveTypes = {AppConstants.LOGGABLE_TYPE.Request})
    public ResponseEntity<ResponseModel<Void>> changeMyPasswordByCode(@Valid @RequestBody AccountDto.ChangePasswordByCodeForm form, Authentication authentication) throws ServerException {
        accountService.changeMyPasswordByCode(form, authentication);
        return ResponseModel.ok(null);
    }

    @PutMapping("/{accountId}")
    @PreAuthorize("hasRole('SUPER_ADMIN')")
    @Loggable(saveTypes = {AppConstants.LOGGABLE_TYPE.Request})
    public ResponseEntity<ResponseModel<AccountDto.Detail>> editAccount(@PathVariable String accountId, @Valid @RequestBody AccountDto.EditForm form) throws ServerException {
        AccountDto.Detail data = accountService.editAccount(accountId, form);
        return ResponseModel.ok(data);
    }

    @PutMapping("/{accountId}/password")
    @PreAuthorize("hasRole('SUPER_ADMIN')")
    @Loggable(saveTypes = {AppConstants.LOGGABLE_TYPE.Request})
    public ResponseEntity<ResponseModel<Void>> changePasswordByAdmin(@PathVariable String accountId, @Valid @RequestBody AccountDto.AdminChangePasswordForm form) throws ServerException {
        accountService.changePasswordByAdmin(accountId, form);
        return ResponseModel.ok(null);
    }

}
