package com.system.alba.common.security;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Optional;

public class SecurityUtils {

    /**
     * 현재 로그인한 사용자의 ID를 반환합니다.
     *
     * @return 로그인한 사용자 ID, 인증되지 않은 경우 "system"
     */
    public static String getLoginId() {
        return getCurrentUser()
            .map(user -> {
                if (user instanceof UserDetails) {
                    return ((UserDetails) user).getUsername();
                }
                return user.toString();
            })
            .orElse("system");
    }

    /**
     * 현재 로그인한 사용자의 Authentication 객체를 반환합니다.
     *
     * @return Optional<Authentication>
     */
    public static Optional<Authentication> getCurrentAuthentication() {
        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            if (authentication != null && authentication.isAuthenticated() &&
                !isAnonymousUser(authentication)) {
                return Optional.of(authentication);
            }
        } catch (Exception e) {
            // Security context에서 정보를 가져올 수 없는 경우
        }
        return Optional.empty();
    }

    /**
     * 현재 로그인한 사용자 정보를 반환합니다.
     *
     * @return Optional<Object> 사용자 정보
     */
    public static Optional<Object> getCurrentUser() {
        return getCurrentAuthentication()
            .map(Authentication::getPrincipal);
    }

    /**
     * 현재 사용자가 인증되었는지 확인합니다.
     *
     * @return 인증 여부
     */
    public static boolean isAuthenticated() {
        return getCurrentAuthentication().isPresent();
    }

    /**
     * 현재 사용자가 특정 권한을 가지고 있는지 확인합니다.
     *
     * @param authority 확인할 권한
     * @return 권한 보유 여부
     */
    public static boolean hasAuthority(String authority) {
        return getCurrentAuthentication()
            .map(auth -> auth.getAuthorities().stream()
                .anyMatch(grantedAuthority -> grantedAuthority.getAuthority().equals(authority)))
            .orElse(false);
    }

    /**
     * 익명 사용자인지 확인합니다.
     *
     * @param authentication Authentication 객체
     * @return 익명 사용자 여부
     */
    private static boolean isAnonymousUser(Authentication authentication) {
        return "anonymousUser".equals(authentication.getPrincipal());
    }
}