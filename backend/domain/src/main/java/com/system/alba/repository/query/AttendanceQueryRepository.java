package com.system.alba.repository.query;

import com.system.alba.model.domain.Attendance;
import org.springframework.data.domain.Page;

import java.time.LocalDate;

public interface AttendanceQueryRepository {

    Page<Attendance> findAttendances(Long shopNo, LocalDate startDate, LocalDate endDate, Long shopMemberId, int page, int size);
}
