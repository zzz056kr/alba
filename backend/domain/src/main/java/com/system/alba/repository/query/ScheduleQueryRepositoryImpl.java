package com.system.alba.repository.query;

import com.querydsl.core.BooleanBuilder;
import com.querydsl.jpa.impl.JPAQueryFactory;
import com.system.alba.model.domain.QSchedule;
import com.system.alba.model.domain.Schedule;
import lombok.RequiredArgsConstructor;

import java.time.LocalDate;
import java.util.List;

@RequiredArgsConstructor
public class ScheduleQueryRepositoryImpl implements ScheduleQueryRepository {

    private final JPAQueryFactory queryFactory;

    private static final QSchedule schedule = QSchedule.schedule;

    @Override
    public List<Schedule> findSchedules(Long shopNo, Long shopMemberId, LocalDate startDate, LocalDate endDate, long limit) {
        BooleanBuilder where = new BooleanBuilder();
        where.and(schedule.shop.no.eq(shopNo));
        where.and(schedule.workDate.goe(startDate));
        where.and(schedule.workDate.loe(endDate));

        if (shopMemberId != null) {
            where.and(schedule.shopMember.no.eq(shopMemberId));
        }

        return queryFactory
                .selectFrom(schedule)
                .leftJoin(schedule.shop).fetchJoin()
                .leftJoin(schedule.shopMember).fetchJoin()
                .leftJoin(schedule.shopMember.account).fetchJoin()
                .where(where)
                .orderBy(schedule.workDate.asc(), schedule.startTime.asc(), schedule.no.asc())
                .limit(limit)
                .fetch();
    }
}
