package com.system.alba.model;

import jakarta.persistence.EntityListeners;
import jakarta.persistence.MappedSuperclass;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.DynamicUpdate;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

@Getter
@Setter
@MappedSuperclass
@EntityListeners(AuditingEntityListener.class)
@DynamicUpdate
public abstract class BaseEntity {
    private Long createdNo;

    @CreatedDate
    private LocalDateTime createdAt;

    private Long modifiedNo;

    @LastModifiedDate
    private LocalDateTime modifiedAt;
}