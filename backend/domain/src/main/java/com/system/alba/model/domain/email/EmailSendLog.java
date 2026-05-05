package com.system.alba.model.domain.email;

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
        @Index(name = "idx_email_log_user", columnList = "email"),
        @Index(name = "idx_email_log_date", columnList = "sentAt")
})
@EntityListeners(AuditingEntityListener.class)
public class EmailSendLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long no;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "accountNo")
    private Account account;

    private String email;

    private String title;

    @Column(columnDefinition = "TEXT")
    private String content;

    @Convert(converter = YesNoConverter.class)
    private Boolean successYn;

    private String failReason;

    @CreatedDate
    private LocalDateTime sentAt;
}
