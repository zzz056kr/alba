package com.system.alba.model.domain;

import com.system.alba.common.AppType;
import com.system.alba.jpa.converter.AccountRoleListConverter;
import com.system.alba.model.BaseEntity;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.type.YesNoConverter;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@Entity
@Table
public class Token extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long no;

    private String accessToken;
    private String refreshToken;

    @Convert(converter = AccountRoleListConverter.class)
    private List<AppType.AccountRole> roles;

    private LocalDateTime accessExpiresAt;
    private LocalDateTime refreshExpiresAt;

    private String clientIp;
    private String userAgent;

    @Convert(converter = YesNoConverter.class)
    private Boolean revokedYn;

    private LocalDateTime revokedAt;
    private String revokedReason;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "accountNo")
    private Account account;

    // 토큰 무효화 메서드
    public void revoke(AppType.TokenRevokeReason reason) {
        this.revokedYn = true;
        this.revokedAt = LocalDateTime.now();
        this.revokedReason = reason.getCode();
    }

    // 토큰 만료 확인 메서드 (null이면 만료로 간주)
    public boolean isAccessTokenExpired() {
        return accessExpiresAt == null || LocalDateTime.now().isAfter(accessExpiresAt);
    }

    public boolean isRefreshTokenExpired() {
        return refreshExpiresAt == null || LocalDateTime.now().isAfter(refreshExpiresAt);
    }

    // 토큰 유효성 확인 메서드
    public boolean isValid() {
        return (revokedYn == null || !revokedYn) && !isAccessTokenExpired();
    }

    public boolean isRefreshValid() {
        return (revokedYn == null || !revokedYn) && !isRefreshTokenExpired();
    }
}