package com.system.alba.model.domain;

import com.system.alba.common.AppType;
import com.system.alba.model.BaseEntity;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.type.YesNoConverter;

import java.time.LocalDate;

@Getter
@Setter
@Entity
@Table
public class ShopMember extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long no;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "shopNo")
    private Shop shop;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "accountNo")
    private Account account;

    private String name;

    @Enumerated(EnumType.STRING)
    private AppType.ShopRole shopRole;

    private Integer baseWage;

    @Convert(converter = YesNoConverter.class)
    private Boolean isAppUser = true;

    @Enumerated(EnumType.STRING)
    private AppType.EmploymentType employmentType;

    @Enumerated(EnumType.STRING)
    private AppType.ShopMemberStatus status;

    private LocalDate joinedAt;
}
