package com.system.alba.repository.query;

import com.system.alba.model.domain.Attendance;

import java.time.LocalDate;
import java.util.List;

public interface AttendanceQueryRepository {

    List<Attendance> findAttendances(Long shopNo, LocalDate startDate, LocalDate endDate, Long shopMemberNo);
}
