package com.system.alba.repository;

import com.system.alba.model.domain.Schedule;
import com.system.alba.repository.query.ScheduleQueryRepository;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.Optional;

@Repository
public interface ScheduleRepository extends JpaRepository<Schedule, Long>, ScheduleQueryRepository {

    Optional<Schedule> findByNoAndShop_No(Long no, Long shopNo);

    @EntityGraph(attributePaths = {"shop", "shopMember", "shopMember.account"})
    Optional<Schedule> findFirstByShopMember_NoAndWorkDateAndStatusOrderByStartTimeAsc(
            Long shopMemberNo,
            LocalDate workDate,
            com.system.alba.common.AppType.ScheduleStatus status
    );
}
