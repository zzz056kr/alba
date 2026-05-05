package com.system.alba.oauth2.config.security.handler;

import com.system.alba.common.AppConstants;
import com.system.alba.common.utils.EnvUtils;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Slf4j
@Component
@RequiredArgsConstructor
public class OAuth2AuthenticationFailureHandler implements AuthenticationFailureHandler {
    private final OAuth2RedirectUrlValidator redirectUrlValidator;

    @Override
    public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response, AuthenticationException exception) throws IOException {
        long startTime = System.currentTimeMillis();

        String redirectUrl = redirectUrlValidator.getValidRedirectBaseUrl(request);
        String location = redirectUrl + "/login?error=oauth_failed";
        response.sendRedirect(location);

        // 실패 로그
        long executionTime = System.currentTimeMillis() - startTime;
        String clientIp = EnvUtils.getClientAddress();
        log.warn("Url: {}, Method: {}, ExecutionTime: {}ms, Ip: {}, Error: {}, Log: [OAuth2 Login Failed, RedirectUrl: {}]",
                request.getRequestURI(), request.getMethod(), executionTime, clientIp, exception.getMessage(), location);
    }

}