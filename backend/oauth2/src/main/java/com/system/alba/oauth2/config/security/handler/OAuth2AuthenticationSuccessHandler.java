package com.system.alba.oauth2.config.security.handler;

import com.system.alba.common.AppConstants;
import com.system.alba.common.utils.EnvUtils;
import com.system.alba.config.security.AuthHeaderHandler;
import com.system.alba.config.security.CustomUserDetails;
import com.system.alba.model.domain.Account;
import com.system.alba.model.dto.TokenDto;
import com.system.alba.service.TokenService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseCookie;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;
import org.springframework.web.util.UriComponentsBuilder;

import java.io.IOException;
import java.net.URI;
import java.time.Duration;
import java.time.LocalDateTime;

@Slf4j
@Component
@RequiredArgsConstructor
public class OAuth2AuthenticationSuccessHandler implements AuthenticationSuccessHandler {
    private final TokenService tokenService;
    private final AuthHeaderHandler authHeaderHandler;
    private final OAuth2RedirectUrlValidator redirectUrlValidator;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException {
        long startTime = System.currentTimeMillis();

        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Account account = userDetails.getAccount();

        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        response.setCharacterEncoding(AppConstants.ENCODING);

        TokenDto.Detail token = tokenService.createTokenWithMultiLoginCheck(account);
        String refreshToken = token.getRefreshToken();
        long remainingSeconds = authHeaderHandler.getRefreshTokenRemainingSeconds(token);
        ResponseCookie cookie = authHeaderHandler.createRefreshCookie(refreshToken, remainingSeconds);
        response.addHeader(HttpHeaders.SET_COOKIE, cookie.toString());

        String redirectUrl = redirectUrlValidator.getValidRedirectBaseUrl(request);
        String location = buildLocation(redirectUrl, token, account);
        response.sendRedirect(location);

        // 성공 로그
        long executionTime = System.currentTimeMillis() - startTime;
        String clientIp = EnvUtils.getClientAddress();
        log.info("Url: {}, Method: {}, User: {}, ExecutionTime: {}ms, Ip: {}, Log: [OAuth2 Login Success, RedirectUrl: {}]",
                request.getRequestURI(), request.getMethod(), account.getId(), executionTime, clientIp, location);
    }

    private String buildLocation(String redirectUrl, TokenDto.Detail token, Account account) {
        String callbackUrl = String.format("%s/login/callback", redirectUrl);
        URI redirectUri = URI.create(redirectUrl);
        String scheme = redirectUri.getScheme();
        boolean isAppScheme = scheme != null && !scheme.equalsIgnoreCase("http") && !scheme.equalsIgnoreCase("https");

        if (!isAppScheme) {
            return callbackUrl;
        }

        return UriComponentsBuilder
                .fromUriString(callbackUrl)
                .queryParam("provider", account.getProvider().name().toLowerCase())
                .queryParam("accessToken", token.getAccessToken())
                .queryParam("accessTokenExpiresIn", toRemainingSeconds(token.getAccessExpiresAt()))
                .queryParam("refreshToken", token.getRefreshToken())
                .queryParam("refreshTokenExpiresIn", toRemainingSeconds(token.getRefreshExpiresAt()))
                .queryParam("userId", account.getId())
                .build(true)
                .toUriString();
    }

    private long toRemainingSeconds(LocalDateTime expiresAt) {
        if (expiresAt == null) {
            return 0;
        }

        return Math.max(0, Duration.between(LocalDateTime.now(), expiresAt).getSeconds());
    }

}
