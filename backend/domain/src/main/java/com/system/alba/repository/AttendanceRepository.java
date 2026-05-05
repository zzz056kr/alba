package com.system.alba.repository;

import com.system.alba.model.domain.Attendance;
import com.system.alba.repository.query.AttendanceQueryRepository;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.Optional;

@Repository
public interface AttendanceRepository extends JpaRepository<Attendance, Long>, AttendanceQueryRepository {

    @EntityGraph(attributePaths = {"shop", "shopMember", "shopMember.account", "schedule"})
    Optional<Attendance> findFirstByShopMember_NoAndWorkDateAndClockOutAtIsNullOrderByClockInAtDesc(
            Long shopMemberNo,
            LocalDate workDate
    );

    @EntityGraph(attributePaths = {"shop", "shopMember", "shopMember.account", "schedule"})
    Optional<Attendance> findFirstByShopMember_NoAndClockOutAtIsNullOrderByClockInAtDesc(Long shopMemberNo);

    @EntityGraph(attributePaths = {"shop", "shopMember", "shopMember.account", "schedule"})
    Optional<Attendance> findByNoAndShop_No(Long no, Long shopNo);
}
