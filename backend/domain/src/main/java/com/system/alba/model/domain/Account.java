package com.system.alba.model.domain;

import com.system.alba.common.AppType;
import com.system.alba.jpa.converter.AccountRoleListConverter;
import com.system.alba.jpa.converter.AuthProviderConverter;
import com.system.alba.model.BaseEntity;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@Entity
@Table(uniqueConstraints = @UniqueConstraint(name = "t_account_unique_email_provider", columnNames = {"email", "provider"}))
public class Account extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long no;
    private String id;
    private String password;
    private String name;
    private String email;

    @Convert(converter = AccountRoleListConverter.class)
    private List<AppType.AccountRole> roles;

    @Convert(converter = AuthProviderConverter.class)
    @Column(nullable = false, length = 20)
    private AppType.AuthProvider provider;

    @Enumerated(EnumType.STRING)
    private AppType.Status status;

    private LocalDateTime lastLoginAt;
    private LocalDateTime passwordModifiedAt;
    private LocalDateTime withdrawAt;
    private Integer loginFailCount;

    public boolean isActive() {
        boolean activeYn = status == AppType.Status.ACTIVE;
        return activeYn;
    }
}