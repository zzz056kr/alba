package com.system.alba.repository;

import com.system.alba.model.domain.Schedule;
import com.system.alba.repository.query.ScheduleQueryRepository;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface ScheduleRepository extends JpaRepository<Schedule, Long>, ScheduleQueryRepository {

    Optional<Schedule> findByNoAndShop_No(Long no, Long shopNo);

    @EntityGraph(attributePaths = {"shop", "shopMember", "shopMember.account"})
    Optional<Schedule> findFirstByShopMember_NoAndWorkDateAndStatusOrderByStartTimeAsc(
            Long shopMemberId,
            LocalDate workDate,
            com.system.alba.common.AppType.ScheduleStatus status
    );

    boolean existsByShopMember_NoAndWorkDateAndStatusAndStartTimeLessThanAndEndTimeGreaterThan(
            Long shopMemberId,
            LocalDate workDate,
            com.system.alba.common.AppType.ScheduleStatus status,
            LocalTime endTime,
            LocalTime startTime
    );

    boolean existsByShopMember_NoAndWorkDateAndStatusAndStartTimeLessThanAndEndTimeGreaterThanAndNoNot(
            Long shopMemberId,
            LocalDate workDate,
            com.system.alba.common.AppType.ScheduleStatus status,
            LocalTime endTime,
            LocalTime startTime,
            Long scheduleId
    );

    List<Schedule> findByShop_NoAndRepeatGroupKeyAndStatusOrderByWorkDateAscStartTimeAsc(
            Long shopNo,
            String repeatGroupKey,
            com.system.alba.common.AppType.ScheduleStatus status
    );
}
