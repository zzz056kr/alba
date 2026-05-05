package com.system.alba.repository.query;

import com.querydsl.core.BooleanBuilder;
import com.querydsl.jpa.impl.JPAQueryFactory;
import com.system.alba.model.domain.Attendance;
import com.system.alba.model.domain.QAttendance;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.support.PageableExecutionUtils;

import java.time.LocalDate;
import java.util.List;

@RequiredArgsConstructor
public class AttendanceQueryRepositoryImpl implements AttendanceQueryRepository {

    private final JPAQueryFactory queryFactory;

    private static final QAttendance attendance = QAttendance.attendance;

    @Override
    public Page<Attendance> findAttendances(Long shopNo, LocalDate startDate, LocalDate endDate, Long shopMemberNo, int page, int size) {
        BooleanBuilder where = new BooleanBuilder();
        where.and(attendance.shop.no.eq(shopNo));

        if (startDate != null) {
            where.and(attendance.workDate.goe(startDate));
        }

        if (endDate != null) {
            where.and(attendance.workDate.loe(endDate));
        }

        if (shopMemberNo != null) {
            where.and(attendance.shopMember.no.eq(shopMemberNo));
        }

        Pageable pageable = PageRequest.of(page, size);

        List<Attendance> contents = queryFactory
                .selectFrom(attendance)
                .leftJoin(attendance.shop).fetchJoin()
                .leftJoin(attendance.shopMember).fetchJoin()
                .leftJoin(attendance.shopMember.account).fetchJoin()
                .leftJoin(attendance.schedule).fetchJoin()
                .where(where)
                .orderBy(attendance.workDate.desc(), attendance.clockInAt.desc(), attendance.no.desc())
                .offset(pageable.getOffset())
                .limit(pageable.getPageSize())
                .fetch();

        return PageableExecutionUtils.getPage(
                contents,
                pageable,
                () -> queryFactory
                        .select(attendance.count())
                        .from(attendance)
                        .where(where)
                        .fetchOne()
        );
    }
}
