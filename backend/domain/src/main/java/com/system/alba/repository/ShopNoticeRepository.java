package com.system.alba.repository;

import com.system.alba.common.AppType;
import com.system.alba.model.domain.ShopNotice;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ShopNoticeRepository extends JpaRepository<ShopNotice, Long> {

    List<ShopNotice> findAllByShop_NoAndStatusOrderByPinnedYnDescCreatedAtDesc(
            Long shopNo,
            AppType.ShopNoticeStatus status
    );
}
