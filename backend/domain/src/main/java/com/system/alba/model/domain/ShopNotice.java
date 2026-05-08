package com.system.alba.model.domain;

import com.system.alba.common.AppType;
import com.system.alba.model.BaseEntity;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "*t_shop_notice", indexes = {
        @Index(name = "idx_shop_notice_list", columnList = "shop_no, pinned_yn, created_at")
})
public class ShopNotice extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long no;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "*shop_no")
    private Shop shop;

    @Column(name = "*title", nullable = false, length = 200)
    private String title;

    @Lob
    @Column(name = "*content", nullable = false)
    private String content;

    @Column(name = "*pinned_yn", nullable = false, length = 1)
    private String pinnedYn;

    @Enumerated(EnumType.STRING)
    @Column(name = "*status", nullable = false, length = 20)
    private AppType.ShopNoticeStatus status;
}
