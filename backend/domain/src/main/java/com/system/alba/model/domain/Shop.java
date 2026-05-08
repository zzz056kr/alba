package com.system.alba.model.domain;

import com.system.alba.common.AppType;
import com.system.alba.model.BaseEntity;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@Entity
@Table(indexes = {
        @Index(name = "idx_shop_invite_code", columnList = "inviteCode"),
        @Index(name = "idx_shop_qr_code", columnList = "qrCodeValue")
}, uniqueConstraints = {
        @UniqueConstraint(name = "uk_shop_invite_code", columnNames = "inviteCode"),
        @UniqueConstraint(name = "uk_shop_qr_code_value", columnNames = "qrCodeValue")
})
public class Shop extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long no;

    private String name;

    private String zipCode;

    private String baseAddress;

    private String detailAddress;

    private String inviteCode;
    private String qrCodeValue;
    private BigDecimal latitude;
    private BigDecimal longitude;

    @Enumerated(EnumType.STRING)
    private AppType.ShopStatus status;
}
