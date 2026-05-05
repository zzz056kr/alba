package com.system.alba.oauth2.config.security;

import com.system.alba.common.AppConstants;
import com.system.alba.common.AppResultCode;
import com.system.alba.common.utils.EnvUtils;
import com.system.alba.config.AppCodeProperties;
import com.system.alba.oauth2.config.OAuthProperties;
import com.system.alba.service.common.ThrowService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.ArrayUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.security.oauth2.client.registration.ClientRegistrationRepository;
import org.springframework.security.oauth2.client.web.DefaultOAuth2AuthorizationRequestResolver;
import org.springframework.security.oauth2.client.web.OAuth2AuthorizationRequestResolver;
import org.springframework.security.oauth2.core.endpoint.OAuth2AuthorizationRequest;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class CustomAuthorizationRequestResolver implements OAuth2AuthorizationRequestResolver {
    private static final String SERVICE = "OAUTH";
    private static final String OAUTH2_LOGIN_PREFIX = "/oauth2/login/";
    private static final String SERVER_EXCEPTION_ATTRIBUTE = "SERVER_EXCEPTION";

    private final OAuthProperties oAuthProperties;
    private final ThrowService throwService;
    private final AppCodeProperties appCodeProperties;
    private final OAuth2AuthorizationRequestResolver defaultAuthorizationRequestResolver;

    public CustomAuthorizationRequestResolver(ClientRegistrationRepository clientRegistrationRepository, OAuthProperties oAuthProperties, ThrowService throwService, AppCodeProperties appCodeProperties) {
        this.defaultAuthorizationRequestResolver = new DefaultOAuth2AuthorizationRequestResolver(clientRegistrationRepository, "/oauth2/login");
        this.oAuthProperties = oAuthProperties;
        this.throwService = throwService;
        this.appCodeProperties = appCodeProperties;
    }

    @Override
    public OAuth2AuthorizationRequest resolve(HttpServletRequest request) {
        long startTime = System.currentTimeMillis();

        // Provider 활성화 여부 확인
        String provider = extractProviderFromUri(request.getRequestURI());
        if (provider != null) {
            validateProviderEnabled(request, provider);
        }

        OAuth2AuthorizationRequest authorizationRequest = this.defaultAuthorizationRequestResolver.resolve(request);
        OAuth2AuthorizationRequest result = customizeAuthorizationRequest(authorizationRequest, request);

        // authorizationRequest가 null이 아닌 경우에만 로그 출력
        if (authorizationRequest != null) {
            long executionTime = System.currentTimeMillis() - startTime;
            String clientIp = EnvUtils.getClientAddress();
            String redirectUrl = request.getParameter(AppConstants.PARAM_REDIRECT_URL);
            log.info("Url: {}, Method: {}, ExecutionTime: {}ms, Ip: {}, Log: [OAuth2 Authorization Request, RedirectUrl: {}]",
                    request.getRequestURI(), request.getMethod(), executionTime, clientIp, redirectUrl);
        }

        return result;
    }

    @Override
    public OAuth2AuthorizationRequest resolve(HttpServletRequest request, String clientRegistrationId) {
        long startTime = System.currentTimeMillis();

        // Provider 활성화 여부 확인
        if (clientRegistrationId != null) {
            validateProviderEnabled(request, clientRegistrationId);
        }

        OAuth2AuthorizationRequest authorizationRequest = this.defaultAuthorizationRequestResolver.resolve(request, clientRegistrationId);
        OAuth2AuthorizationRequest result = customizeAuthorizationRequest(authorizationRequest, request);

        // 로그 출력
        long executionTime = System.currentTimeMillis() - startTime;
        String clientIp = EnvUtils.getClientAddress();
        String redirectUrl = request.getParameter(AppConstants.PARAM_REDIRECT_URL);
        log.info("Url: {}, Method: {}, ExecutionTime: {}ms, Ip: {}, Log: [OAuth2 Authorization Request, ClientId: {}, RedirectUrl: {}]",
                request.getRequestURI(), request.getMethod(), executionTime, clientIp, clientRegistrationId, redirectUrl);

        return result;
    }

    private OAuth2AuthorizationRequest customizeAuthorizationRequest(OAuth2AuthorizationRequest authorizationRequest, HttpServletRequest request) {
        if (authorizationRequest == null) {
            return null;
        }

        String redirectUrl = request.getParameter(AppConstants.PARAM_REDIRECT_URL);
        if (StringUtils.isNotBlank(redirectUrl)) {
            // redirect_url 검증
            if (!isValidRedirectUrl(redirectUrl)) {
                final String CATEGORY = "REDIRECT";
                throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.UNAUTHORIZED, "Unauthorized redirect URL: " + redirectUrl);
            }

            // redirect_url을 state에 포함시켜서 전달
            String originalState = authorizationRequest.getState();
            String newState = originalState + ":" + redirectUrl;

            return OAuth2AuthorizationRequest.from(authorizationRequest)
                    .state(newState)
                    .build();
        }

        return authorizationRequest;
    }

    private boolean isValidRedirectUrl(String redirectUrl) {
        String[] allowedRedirectUrls = oAuthProperties.getAllowedRedirectUrls();

        if (ArrayUtils.isEmpty(allowedRedirectUrls)) {
            return false;
        }

        for (String allowedUrl : allowedRedirectUrls) {
            if (redirectUrl.equals(allowedUrl)) {
                return true;
            }
        }
        return false;
    }

    /**
     * URI에서 provider 이름 추출
     * 예: /oauth2/login/google -> google
     */
    private String extractProviderFromUri(String uri) {
        if (uri != null && uri.startsWith(OAUTH2_LOGIN_PREFIX)) {
            String provider = uri.substring(OAUTH2_LOGIN_PREFIX.length());
            // 추가 경로가 있을 수 있으므로 / 이전까지만 추출
            int slashIndex = provider.indexOf('/');
            if (slashIndex > 0) {
                provider = provider.substring(0, slashIndex);
            }
            return provider;
        }
        return null;
    }

    /**
     * OAuth2 provider 활성화 여부 확인
     * OAUTH2 그룹에서 해당 provider가 활성화되어 있는지 캐시를 통해 확인
     */
    private void validateProviderEnabled(HttpServletRequest request, String provider) {
        final String CATEGORY = "PROVIDER";
        String providerCode = provider.toUpperCase();

        boolean isEnabled = appCodeProperties.getOauth2().isProviderEnabled(providerCode);
        if (!isEnabled) {
            log.warn("OAuth2 provider '{}' is not enabled", providerCode);
            // request attribute에 예외 저장 (CustomAuthenticationEntryPoint에서 사용)
            var exception = throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.FORBIDDEN, "RESULT_OAUTH2_PROVIDER_DISABLED", new Object[] { providerCode });
            request.setAttribute(SERVER_EXCEPTION_ATTRIBUTE, exception);
            throw exception;
        }
    }
}