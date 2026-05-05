package com.system.alba.repository.query;

import com.system.alba.model.domain.ShopMember;
import com.system.alba.model.dto.ShopMemberDto;

import java.util.List;

public interface ShopMemberQueryRepository {

    List<ShopMember> findMembers(Long shopNo, ShopMemberDto.SearchParams params);
}
