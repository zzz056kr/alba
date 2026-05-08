package com.system.alba.controller;

import com.system.alba.common.AppConstants;
import com.system.alba.common.Loggable;
import com.system.alba.config.AppProperties;
import com.system.alba.exception.ServerException;
import com.system.alba.model.ResponseModel;
import com.system.alba.model.dto.AccountDto;
import com.system.alba.model.dto.TokenDto;
import com.system.alba.service.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/app/auth")
@RequiredArgsConstructor
public class AppAuthController {

    private final AuthService authService;
    private final AppProperties appProperties;

    @PostMapping("/login")
    @Loggable(saveTypes = {AppConstants.LOGGABLE_TYPE.Request})
    public ResponseEntity<ResponseModel<TokenDto.AppTokenResponse>> login(
            @Valid @RequestBody AccountDto.LoginForm form
    ) throws ServerException {
        TokenDto.Detail token = authService.login(form);

        TokenDto.AppTokenResponse data = TokenDto.AppTokenResponse.Mapper.INSTANCE.sourceToDestination(token);
        data.setAccessTokenExpiresIn(appProperties.getAuth().getAccessExpiresSeconds());
        data.setRefreshTokenExpiresIn(appProperties.getAuth().getRefreshExpiresSeconds());

        return ResponseEntity.ok(new ResponseModel<>(data));
    }

    @PostMapping("/refresh")
    @Loggable(saveTypes = {AppConstants.LOGGABLE_TYPE.Request})
    public ResponseEntity<ResponseModel<TokenDto.AppTokenResponse>> refresh(
            @Valid @RequestBody TokenDto.RefreshRequest form
    ) throws ServerException {
        TokenDto.Detail token = authService.refreshToken(form.getRefreshToken());

        TokenDto.AppTokenResponse data = TokenDto.AppTokenResponse.Mapper.INSTANCE.sourceToDestination(token);
        data.setAccessTokenExpiresIn(appProperties.getAuth().getAccessExpiresSeconds());
        data.setRefreshTokenExpiresIn(appProperties.getAuth().getRefreshExpiresSeconds());

        return ResponseEntity.ok(new ResponseModel<>(data));
    }

    @PostMapping("/logout")
    @Loggable(saveTypes = {AppConstants.LOGGABLE_TYPE.Request})
    public ResponseEntity<ResponseModel<Void>> logout(
            @Valid @RequestBody TokenDto.LogoutRequest form
    ) {
        authService.logout(form.getRefreshToken());
        return ResponseEntity.ok(new ResponseModel<>());
    }
}
