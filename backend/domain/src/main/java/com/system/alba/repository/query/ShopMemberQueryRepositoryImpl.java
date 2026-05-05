package com.system.alba.repository.query;

import com.system.alba.model.domain.QShopMember;
import com.system.alba.model.domain.ShopMember;
import com.system.alba.model.dto.ShopMemberDto;
import com.querydsl.core.BooleanBuilder;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.support.PageableExecutionUtils;

import java.util.List;

@RequiredArgsConstructor
public class ShopMemberQueryRepositoryImpl implements ShopMemberQueryRepository {

    private final JPAQueryFactory queryFactory;

    private static final QShopMember shopMember = QShopMember.shopMember;

    @Override
    public Page<ShopMember> findMembers(Long shopNo, ShopMemberDto.SearchParams params) {
        BooleanBuilder where = new BooleanBuilder();
        where.and(shopMember.shop.no.eq(shopNo));

        if (params != null) {
            if (params.getEmploymentTypes() != null && !params.getEmploymentTypes().isEmpty()) {
                where.and(shopMember.employmentType.in(params.getEmploymentTypes()));
            }

            if (params.getStatuses() != null && !params.getStatuses().isEmpty()) {
                where.and(shopMember.status.in(params.getStatuses()));
            }
        }

        int page = params != null ? Math.max(params.getPage() - 1, 0) : 0;
        int size = params != null ? params.getSize() : 20;
        Pageable pageable = PageRequest.of(page, size);

        List<ShopMember> contents = queryFactory
                .selectFrom(shopMember)
                .leftJoin(shopMember.shop).fetchJoin()
                .leftJoin(shopMember.account).fetchJoin()
                .where(where)
                .orderBy(shopMember.status.asc(), shopMember.shopRole.asc(), shopMember.no.desc())
                .offset(pageable.getOffset())
                .limit(pageable.getPageSize())
                .fetch();

        return PageableExecutionUtils.getPage(
                contents,
                pageable,
                () -> queryFactory
                        .select(shopMember.count())
                        .from(shopMember)
                        .where(where)
                        .fetchOne()
        );
    }
}
