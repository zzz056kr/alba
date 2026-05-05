package com.system.alba.repository;

import com.system.alba.common.AppType;
import com.system.alba.model.domain.ShopMember;
import com.system.alba.repository.query.ShopMemberQueryRepository;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ShopMemberRepository extends JpaRepository<ShopMember, Long>, ShopMemberQueryRepository {

    @EntityGraph(attributePaths = {"shop", "account"})
    List<ShopMember> findByAccount_NoAndStatusAndShop_StatusOrderByNoDesc(
            Long accountNo,
            AppType.ShopMemberStatus status,
            AppType.ShopStatus shopStatus
    );

    boolean existsByShop_NoAndAccount_NoAndStatus(Long shopNo, Long accountNo, AppType.ShopMemberStatus status);

    boolean existsByShop_NoAndAccount_No(Long shopNo, Long accountNo);

    boolean existsByShop_NoAndAccount_NoAndShopRoleAndStatus(
            Long shopNo,
            Long accountNo,
            AppType.ShopRole shopRole,
            AppType.ShopMemberStatus status
    );

    @EntityGraph(attributePaths = {"shop", "account"})
    Optional<ShopMember> findByNoAndShop_No(Long no, Long shopNo);

    @EntityGraph(attributePaths = {"shop", "account"})
    Optional<ShopMember> findByShop_NoAndAccount_NoAndStatus(Long shopNo, Long accountNo, AppType.ShopMemberStatus status);
}
