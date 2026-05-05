package com.system.alba.oauth2.config.security.handler;

import com.system.alba.common.AppConstants;
import com.system.alba.common.AppResultCode;
import com.system.alba.oauth2.config.OAuthProperties;
import com.system.alba.service.common.ThrowService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.apache.commons.lang3.ArrayUtils;
import org.springframework.stereotype.Component;

import java.net.URI;

@Component
@RequiredArgsConstructor
public class OAuth2RedirectUrlValidator {
    private static final String SERVICE = "OAUTH";

    private final ThrowService throwService;
    private final OAuthProperties oAuthProperties;

    public String getValidRedirectBaseUrl(HttpServletRequest request) {
        final String CATEGORY = "REDIRECT";

        String[] allowedRedirectUrls = oAuthProperties.getAllowedRedirectUrls();

        if (ArrayUtils.isEmpty(allowedRedirectUrls)) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.INVALID_PARAMETER);
        }

        // OAuth2 state에서 redirect_url 추출 시도
        String requestedRedirectUrl = extractRedirectUrlFromState(request);
        if (requestedRedirectUrl != null && !requestedRedirectUrl.isEmpty()) {
            for (String allowedUrl : allowedRedirectUrls) {
                if (requestedRedirectUrl.startsWith(allowedUrl)) {
                    return extractBaseUrl(requestedRedirectUrl);
                }
            }

            // Oauth 인증 요청시 미리 검증
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.UNAUTHORIZED, "Unauthorized redirect URL: " + requestedRedirectUrl);
        }

        // redirect_url 없으면 첫번째 설정 url로 전달
        return extractBaseUrl(allowedRedirectUrls[0]);
    }

    private String extractRedirectUrlFromState(HttpServletRequest request) {
        String state = request.getParameter(AppConstants.PARAM_STATE);
        if (state != null && state.contains(":")) {
            String[] parts = state.split(":", 2);
            if (parts.length == 2) {
                return parts[1];
            }
        }
        return null;
    }

    private String extractBaseUrl(String fullUrl) {
        try {
            URI uri = URI.create(fullUrl);
            String scheme = uri.getScheme();
            String host = uri.getHost();
            int port = uri.getPort();

            if (scheme == null || scheme.isBlank()) {
                final String CATEGORY = "REDIRECT";
                throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.INVALID_PARAMETER);
            }

            if (host == null || host.isBlank()) {
                return scheme + "://";
            }

            return scheme + "://" + host + (port != -1 ? ":" + port : "");
        } catch (Exception e) {
            final String CATEGORY = "REDIRECT";
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.INVALID_PARAMETER);
        }
    }
}
