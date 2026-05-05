package com.system.alba.controller;

import com.system.alba.common.AppConstants;
import com.system.alba.common.Loggable;
import com.system.alba.config.AppProperties;
import com.system.alba.exception.ServerException;
import com.system.alba.config.security.AuthHeaderHandler;
import com.system.alba.model.ResponseModel;
import com.system.alba.model.dto.AccountDto;
import com.system.alba.model.dto.TokenDto;
import com.system.alba.service.AuthService;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseCookie;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {

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

    @PostMapping("/login")
    @Loggable(saveTypes = {AppConstants.LOGGABLE_TYPE.Request})
    public ResponseEntity<ResponseModel<TokenDto.TokenResponse>> login(@Valid @RequestBody AccountDto.LoginForm form) throws ServerException {
        TokenDto.Detail token = authService.login(form);
        HttpHeaders headers = authHeaderHandler.getTokenHeaders(token);

        TokenDto.TokenResponse data = TokenDto.TokenResponse.Mapper.INSTANCE.sourceToDestination(token);
        data.setAccessTokenExpiresIn(appProperties.getAuth().getAccessExpiresSeconds());

        return ResponseEntity.ok()
                .headers(headers)
                .body(new ResponseModel<>(data));
    }

    @PostMapping("/refresh")
    @Loggable(saveTypes = {AppConstants.LOGGABLE_TYPE.Request})
    public ResponseEntity<ResponseModel<TokenDto.TokenResponse>> refreshToken(HttpServletRequest request) throws ServerException {
        Cookie cookie = authHeaderHandler.getRefreshCookie(request);
        String refreshToken = cookie.getValue();
        TokenDto.Detail token = authService.refreshToken(refreshToken);
        HttpHeaders headers = authHeaderHandler.getTokenHeaders(token);

        TokenDto.TokenResponse data = TokenDto.TokenResponse.Mapper.INSTANCE.sourceToDestination(token);
        data.setAccessTokenExpiresIn(appProperties.getAuth().getAccessExpiresSeconds());

        return ResponseEntity.ok()
                .headers(headers)
                .body(new ResponseModel<>(data));
    }

    @PostMapping("/logout")
    @Loggable(saveTypes = {AppConstants.LOGGABLE_TYPE.Request})
    public ResponseEntity<ResponseModel<Void>> logout(HttpServletRequest request) {
        Cookie cookie = authHeaderHandler.getRefreshCookie(request);
        String refreshToken = cookie.getValue();

        authService.logout(refreshToken);

        ResponseCookie refreshCookie = authHeaderHandler.createRefreshCookie("", 0);
        return ResponseEntity.ok()
                .header(HttpHeaders.SET_COOKIE, refreshCookie.toString())
                .body(new ResponseModel<>());
    }

}
