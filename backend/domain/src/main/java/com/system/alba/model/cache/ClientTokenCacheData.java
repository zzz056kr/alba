package com.system.alba.model.cache;

import com.system.alba.common.AppType;
import com.system.alba.model.domain.Token;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 토큰 캐시용 데이터
 * - Token 엔티티의 필수 정보만 포함
 * - Serializable for Redis 저장
 */
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ClientTokenCacheData implements Serializable {

    private String accessToken;
    private String refreshToken;
    private List<AppType.AccountRole> roles;
    private LocalDateTime accessExpiresAt;
    private LocalDateTime refreshExpiresAt;
    private Boolean revokedYn;

    // Account 정보
    private Long accountNo;
    private AppType.Status accountStatus;

    // Token 엔티티에서 캐시 데이터 생성
    public static ClientTokenCacheData from(Token token) {
        return ClientTokenCacheData.builder()
                .accessToken(token.getAccessToken())
                .refreshToken(token.getRefreshToken())
                .roles(token.getRoles())
                .accessExpiresAt(token.getAccessExpiresAt())
                .refreshExpiresAt(token.getRefreshExpiresAt())
                .revokedYn(token.getRevokedYn())
                .accountNo(token.getAccount() != null ? token.getAccount().getNo() : null)
                .accountStatus(token.getAccount() != null ? token.getAccount().getStatus() : null)
                .build();
    }

    // 토큰 유효성 확인
    public boolean isValid() {
        return (revokedYn == null || !revokedYn) && !isAccessTokenExpired();
    }

    // Access 토큰 만료 확인
    public boolean isAccessTokenExpired() {
        return LocalDateTime.now().isAfter(accessExpiresAt);
    }

    // 계정 활성 상태 확인
    public boolean isAccountActive() {
        return accountStatus == AppType.Status.ACTIVE;
    }
}