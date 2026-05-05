package com.system.alba.config.security;

import com.system.alba.common.AppType;
import com.system.alba.repository.ShopMemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

@Component("shopAuth")
@RequiredArgsConstructor
public class ShopAuth {

    private final ShopMemberRepository shopMemberRepository;

    public boolean isMember(Long shopId) {
        if (shopId == null) {
            return false;
        }

        Long accountNo = getAuthenticatedAccountNo();
        if (accountNo == null) {
            return false;
        }

        return shopMemberRepository.existsByShop_NoAndAccount_NoAndStatus(
                shopId,
                accountNo,
                AppType.ShopMemberStatus.ACTIVE
        );
    }

    public boolean isOwner(Long shopId) {
        if (shopId == null) {
            return false;
        }

        Long accountNo = getAuthenticatedAccountNo();
        if (accountNo == null) {
            return false;
        }

        return shopMemberRepository.existsByShop_NoAndAccount_NoAndShopRoleAndStatus(
                shopId,
                accountNo,
                AppType.ShopRole.OWNER,
                AppType.ShopMemberStatus.ACTIVE
        );
    }

    public boolean isStaff(Long shopId) {
        if (shopId == null) {
            return false;
        }

        Long accountNo = getAuthenticatedAccountNo();
        if (accountNo == null) {
            return false;
        }

        return shopMemberRepository.existsByShop_NoAndAccount_NoAndShopRoleAndStatus(
                shopId,
                accountNo,
                AppType.ShopRole.STAFF,
                AppType.ShopMemberStatus.ACTIVE
        );
    }

    private Long getAuthenticatedAccountNo() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || authentication.getName() == null) {
            return null;
        }

        try {
            return Long.parseLong(authentication.getName());
        } catch (NumberFormatException exception) {
            return null;
        }
    }
}
