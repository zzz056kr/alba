package com.system.alba.repository.query;

import com.system.alba.model.domain.ShopMember;
import com.system.alba.model.dto.ShopMemberDto;
import org.springframework.data.domain.Page;

public interface ShopMemberQueryRepository {

    Page<ShopMember> findMembers(Long shopNo, ShopMemberDto.SearchParams params);
}
