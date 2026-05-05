package com.system.alba.config.security;

import com.system.alba.common.AppConstants;
import com.system.alba.model.domain.Account;
import lombok.Getter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.oauth2.core.user.OAuth2User;

import java.util.Collection;
import java.util.Collections;
import java.util.Map;
import java.util.stream.Collectors;

@Getter
public class CustomUserDetails implements UserDetails, OAuth2User {

    private final Account account;
    private Map<String, Object> attributes;

    public CustomUserDetails(Account account) {
        this.account = account;
    }

    public CustomUserDetails(Account account, Map<String, Object> attributes) {
        this.account = account;
        this.attributes = attributes;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        if (account.getRoles() == null || account.getRoles().isEmpty()) {
            return Collections.emptyList();
        }

        return account.getRoles().stream()
                .map(role -> new SimpleGrantedAuthority(AppConstants.ROLE_PREFIX + role.getKey()))
                .collect(Collectors.toList());
    }

    @Override
    public String getPassword() {
        return account.getPassword();
    }

    @Override
    public String getUsername() {
        return String.valueOf(account.getNo()); // PK를 username으로 사용
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() { return true; }

    @Override
    public boolean isCredentialsNonExpired() { return true; }

    @Override
    public boolean isEnabled() { return true; }

    // OAuth2User 인터페이스 구현
    @Override
    public Map<String, Object> getAttributes() {
        return attributes;
    }

    @Override
    public String getName() {
        // UserDetails의 getUsername()과 동일한 값을 반환하여 일관성 유지
        return String.valueOf(account.getNo());
    }
}