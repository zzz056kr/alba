package com.system.alba.config.security;

import com.system.alba.common.AppResultCode;
import com.system.alba.common.AppType;
import com.system.alba.common.utils.EnvUtils;
import com.system.alba.config.AppProperties;
import com.system.alba.model.dto.TokenDto;
import com.system.alba.service.common.ThrowService;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.core.env.Environment;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseCookie;
import org.springframework.stereotype.Component;

import java.time.ZoneId;
import java.util.Arrays;

@Component
@RequiredArgsConstructor
public class AuthHeaderHandler {

    private final Environment environment;
    private final AppProperties appProperties;
    private final ThrowService throwService;

    public HttpHeaders getTokenHeaders(TokenDto.Detail token) {
        // 남은시간 (초)
        long refreshExpiresTime = token.getRefreshExpiresAt()
                .atZone(ZoneId.systemDefault())
                .toInstant()
                .toEpochMilli();
        long currentTime = System.currentTimeMillis();
        long remainingSeconds = (refreshExpiresTime - currentTime) / 1000;

        String refreshToken = token.getRefreshToken();
        ResponseCookie refreshCookie = createRefreshCookie(refreshToken, remainingSeconds);

        HttpHeaders headers = new HttpHeaders();
        headers.add(HttpHeaders.SET_COOKIE, refreshCookie.toString());
        return headers;
    }

    public long getRefreshTokenRemainingSeconds(TokenDto.Detail token) {
        // 남은시간 (초)
        long refreshExpiresTime = token.getRefreshExpiresAt()
                .atZone(ZoneId.systemDefault())
                .toInstant()
                .toEpochMilli();
        long currentTime = System.currentTimeMillis();
        long remainingSeconds = (refreshExpiresTime - currentTime) / 1000;
        return remainingSeconds;
    }

    public ResponseCookie createRefreshCookie(String refreshToken, long maxAge) {
        AppProperties.AuthProperties authProperties = appProperties.getAuth();
        String refreshTokenCookieName = authProperties.getRefreshTokenCookieName();

        boolean isLocal = EnvUtils.containsProfile(environment, AppType.Profile.local);
        ResponseCookie refreshCookie = ResponseCookie.from(refreshTokenCookieName, refreshToken)
                .maxAge(maxAge)         // 쿠키 유효 기간 설정
                .path("/")              // 쿠키가 적용될 경로
                .secure(!isLocal)       // HTTPS 환경에서만 쿠키 전송
                .sameSite("LAX")        // CSRF 공격 방지
                .httpOnly(true)         // JavaScript에서 쿠키 접근 불가
                .build();

        return refreshCookie;
    }

    public Cookie getRefreshCookie(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies == null) {
            throw throwService.throwErrorByMessage("AUTH", "REFRESH", AppResultCode.UNAUTHORIZED);
        }

        Cookie cookie = Arrays.stream(cookies)
                .filter(item -> item.getName().equals(appProperties.getAuth().getRefreshTokenCookieName()))
                .findFirst()
                .orElse(null);

        if (cookie == null) {
            throw throwService.throwErrorByMessage("AUTH", "REFRESH", AppResultCode.UNAUTHORIZED);
        }
        return cookie;
    }

}