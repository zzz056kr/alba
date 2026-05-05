package com.system.alba.repository;

import com.system.alba.model.domain.Schedule;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface ScheduleRepository extends JpaRepository<Schedule, Long> {

    @EntityGraph(attributePaths = {"shop", "shopMember", "shopMember.account"})
    List<Schedule> findByShop_NoAndWorkDateBetweenOrderByWorkDateAscStartTimeAscNoAsc(
            Long shopNo,
            LocalDate startDate,
            LocalDate endDate
    );

    Optional<Schedule> findByNoAndShop_No(Long no, Long shopNo);

    @EntityGraph(attributePaths = {"shop", "shopMember", "shopMember.account"})
    Optional<Schedule> findFirstByShopMember_NoAndWorkDateAndStatusOrderByStartTimeAsc(
            Long shopMemberNo,
            LocalDate workDate,
            com.system.alba.common.AppType.ScheduleStatus status
    );
}
