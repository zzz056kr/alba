package com.system.alba.model.domain.email;

import com.system.alba.common.AppType;
import com.system.alba.model.domain.Account;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.type.YesNoConverter;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@DynamicUpdate
@Table(indexes = {
        @Index(name = "idx_email_auth_search", columnList = "email, code, type")
})
@EntityListeners(AuditingEntityListener.class)
public class EmailAuthCode {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long no;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "accountNo")
    private Account account;

    private String email;

    private String code;

    @Enumerated(EnumType.STRING)
    private AppType.EmailAuthType type;

    private LocalDateTime expiredAt;

    @Convert(converter = YesNoConverter.class)
    private Boolean verifiedYn = false;

    private Integer failCount = 0;

    @Convert(converter = YesNoConverter.class)
    private Boolean sendSuccessYn;

    private String sendFailReason;

    @CreatedDate
    private LocalDateTime createdAt;

    public boolean isExpired() {
        return LocalDateTime.now().isAfter(expiredAt);
    }

    public boolean isValid() {
        return !isExpired() && !Boolean.TRUE.equals(verifiedYn);
    }
}
