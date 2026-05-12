package com.system.alba.model.dto;

import com.system.alba.common.AppType;
import com.system.alba.common.GenericMapper;
import com.system.alba.model.domain.Schedule;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;
import org.mapstruct.ReportingPolicy;
import org.mapstruct.factory.Mappers;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

public class ScheduleDto {

    public enum ViewType {
        WEEK,
        MONTH
    }

    public enum EditScope {
        THIS_ONLY,
        FOLLOWING,
        ALL
    }

    @Getter
    @Setter
    public static class Detail extends Summary {

        @org.mapstruct.Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
        public interface Mapper extends GenericMapper<Detail, Schedule> {
            Mapper INSTANCE = Mappers.getMapper(Mapper.class);
        }
    }

    @Getter
    @Setter
    public static class Summary {
        private Long no;
        private ShopDto.Abbr shop;
        private ShopMemberDto.Abbr shopMember;
        private LocalDate workDate;
        private LocalTime startTime;
        private LocalTime endTime;
        private String repeatGroupKey;
        private AppType.ScheduleStatus status;
        private LocalDateTime createdAt;

        @org.mapstruct.Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
        public interface Mapper extends GenericMapper<Summary, Schedule> {
            Mapper INSTANCE = Mappers.getMapper(Mapper.class);
        }
    }

    @Getter
    @Setter
    public static class Abbr {
        private Long no;
        private LocalDate workDate;
        private LocalTime startTime;
        private LocalTime endTime;
        private AppType.ScheduleStatus status;

        @org.mapstruct.Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
        public interface Mapper extends GenericMapper<Abbr, Schedule> {
            Mapper INSTANCE = Mappers.getMapper(Mapper.class);
        }
    }

    @Getter
    @Setter
    public static class CreateForm {
        @NotNull
        private Long shopMemberId;

        @NotNull
        private LocalDate workDate;

        @NotNull
        private LocalTime startTime;

        @NotNull
        private LocalTime endTime;

        private LocalDate repeatUntil;
        private List<DayOfWeek> repeatDaysOfWeek;
    }

    @Getter
    @Setter
    public static class CreateResponse {
        @NotEmpty
        private List<Detail> schedules;
    }

    @Getter
    @Setter
    public static class EditForm {
        @NotNull
        private LocalDate workDate;

        @NotNull
        private LocalTime startTime;

        @NotNull
        private LocalTime endTime;

        @NotNull
        private EditScope scope;
    }

    @Getter
    @Setter
    public static class SearchParams {
        @NotNull
        private ViewType viewType;

        @NotNull
        private LocalDate baseDate;

        private Long shopMemberId;
    }

    @Getter
    @Setter
    public static class SearchResponse {
        private ViewType viewType;
        private LocalDate baseDate;
        private LocalDate startDate;
        private LocalDate endDate;
        private List<Summary> schedules;
    }
}
