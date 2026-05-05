package com.system.alba.repository.query;

import com.system.alba.model.domain.Schedule;

import java.time.LocalDate;
import java.util.List;

public interface ScheduleQueryRepository {

    List<Schedule> findSchedules(Long shopNo, Long shopMemberNo, LocalDate startDate, LocalDate endDate, long limit);
}
