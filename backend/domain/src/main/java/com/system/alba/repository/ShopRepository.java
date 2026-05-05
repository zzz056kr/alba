package com.system.alba.repository;

import com.system.alba.common.AppType;
import com.system.alba.model.domain.Shop;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ShopRepository extends JpaRepository<Shop, Long> {

    boolean existsByInviteCode(String inviteCode);

    boolean existsByQrCodeValue(String qrCodeValue);

    Optional<Shop> findByInviteCodeAndStatus(String inviteCode, AppType.ShopStatus status);
}
