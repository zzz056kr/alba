package com.system.alba.config.security.filter;

import com.system.alba.common.AppConstants;
import com.system.alba.model.cache.ClientTokenCacheData;
import com.system.alba.service.cache.TokenCacheService;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Component
@RequiredArgsConstructor
public class OpaqueTokenAuthenticationFilter extends OncePerRequestFilter {

    private final TokenCacheService tokenCacheService;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        String token = extractTokenFromRequest(request);

        if (StringUtils.hasText(token)) {
            authenticateToken(token);
        }

        filterChain.doFilter(request, response);
    }

    private String extractTokenFromRequest(HttpServletRequest request) {
        String bearerToken = request.getHeader(HttpHeaders.AUTHORIZATION);
        if (StringUtils.hasText(bearerToken) && bearerToken.startsWith(AppConstants.BEARER_PREFIX)) {
            return bearerToken.substring(7);
        }
        return null;
    }

    private void authenticateToken(String tokenValue) {
        try {
            // 캐시에서 토큰 조회 (캐시 미스 시 DB 조회)
            ClientTokenCacheData token = tokenCacheService.getToken(tokenValue);

            if (token == null) {
                log.debug("Token not found");
                return;
            }

            // 토큰 유효성 확인 (토큰 존재, 만료되지 않음, 무효화되지 않음)
            if (token.isValid()) {
                // 계정 상태 확인 (활성 계정만 허용)
                if (token.getAccountNo() != null && token.isAccountActive()) {
                    // 권한 생성 (토큰에서 roles 사용)
                    List<SimpleGrantedAuthority> authorities = token.getRoles().stream()
                        .map(role -> new SimpleGrantedAuthority(AppConstants.ROLE_PREFIX + role))
                        .collect(Collectors.toList());

                    // Authentication 객체 생성
                    UsernamePasswordAuthenticationToken authentication =
                        new UsernamePasswordAuthenticationToken(
                            String.valueOf(token.getAccountNo()),
                            null,
                            authorities
                        );

                    // SecurityContext에 인증 정보 설정
                    SecurityContextHolder.getContext().setAuthentication(authentication);

                    log.debug("Authenticated user: {}", token.getAccountNo());
                } else {
                    log.warn("Account is inactive or null");
                }
            } else {
                log.debug("Token is invalid or expired");
            }
        } catch (Exception e) {
            log.error("Opaque token authentication failed: {}", e.getMessage());
            SecurityContextHolder.clearContext();
        }
    }
}