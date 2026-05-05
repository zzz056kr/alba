package com.system.alba.model.dto;

import com.system.alba.common.AppType;
import com.system.alba.common.GenericMapper;
import com.system.alba.model.domain.Attendance;
import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;
import lombok.Getter;
import lombok.Setter;
import org.mapstruct.ReportingPolicy;
import org.mapstruct.factory.Mappers;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

public class AttendanceDto {

    @Getter
    @Setter
    public static class Detail extends Summary {

        @org.mapstruct.Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
        public interface Mapper extends GenericMapper<Detail, Attendance> {
            Mapper INSTANCE = Mappers.getMapper(Mapper.class);
        }
    }

    @Getter
    @Setter
    public static class Summary {
        private Long no;
        private ShopDto.Abbr shop;
        private ShopMemberDto.Abbr shopMember;
        private ScheduleDto.Abbr schedule;
        private LocalDate workDate;
        private LocalDateTime clockInAt;
        private BigDecimal clockInLat;
        private BigDecimal clockInLng;
        private LocalDateTime clockOutAt;
        private BigDecimal clockOutLat;
        private BigDecimal clockOutLng;
        private AppType.AttendanceAuthType authType;
        private AppType.ClockInStatus clockInStatus;
        private AppType.ClockOutStatus clockOutStatus;
        private Integer baseWage;
        private Long workedMinutes;
        private Long estimatedPay;
        private LocalDateTime createdAt;

        @org.mapstruct.Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
        public interface Mapper extends GenericMapper<Summary, Attendance> {
            Mapper INSTANCE = Mappers.getMapper(Mapper.class);
        }
    }

    @Getter
    @Setter
    public static class Abbr {
        private Long no;
        private LocalDate workDate;
        private LocalDateTime clockInAt;
        private LocalDateTime clockOutAt;

        @org.mapstruct.Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
        public interface Mapper extends GenericMapper<Abbr, Attendance> {
            Mapper INSTANCE = Mappers.getMapper(Mapper.class);
        }
    }

    @Getter
    @Setter
    public static class ClockInQrForm {
        @NotBlank
        private String qrCodeValue;

        @NotNull
        @DecimalMin(value = "-90.0")
        @DecimalMax(value = "90.0")
        private BigDecimal latitude;

        @NotNull
        @DecimalMin(value = "-180.0")
        @DecimalMax(value = "180.0")
        private BigDecimal longitude;
    }

    @Getter
    @Setter
    public static class ClockOutQrForm {
        @NotBlank
        private String qrCodeValue;

        @NotNull
        @DecimalMin(value = "-90.0")
        @DecimalMax(value = "90.0")
        private BigDecimal latitude;

        @NotNull
        @DecimalMin(value = "-180.0")
        @DecimalMax(value = "180.0")
        private BigDecimal longitude;
    }

    @Getter
    @Setter
    public static class QuickDailyCreateForm {
        @NotBlank
        private String name;

        @NotNull
        @PositiveOrZero
        private Integer baseWage;

        @NotNull
        private LocalDate workDate;

        @NotNull
        private LocalTime startTime;

        @NotNull
        private LocalTime endTime;
    }

    @Getter
    @Setter
    public static class QuickDailyCreateResponse {
        private ShopMemberDto.Detail shopMember;
        private ScheduleDto.Detail schedule;
        private Detail attendance;
    }

    @Getter
    @Setter
    public static class SearchParams {
        private LocalDate startDate;
        private LocalDate endDate;
    }

    @Getter
    @Setter
    public static class SearchResponse {
        private List<Summary> attendances;
    }

    @Getter
    @Setter
    public static class EditForm {
        private LocalDate workDate;
        private LocalDateTime clockInAt;

        @DecimalMin(value = "-90.0")
        @DecimalMax(value = "90.0")
        private BigDecimal clockInLat;

        @DecimalMin(value = "-180.0")
        @DecimalMax(value = "180.0")
        private BigDecimal clockInLng;

        private LocalDateTime clockOutAt;

        @DecimalMin(value = "-90.0")
        @DecimalMax(value = "90.0")
        private BigDecimal clockOutLat;

        @DecimalMin(value = "-180.0")
        @DecimalMax(value = "180.0")
        private BigDecimal clockOutLng;

        private AppType.AttendanceAuthType authType;
        private AppType.ClockInStatus clockInStatus;
        private AppType.ClockOutStatus clockOutStatus;

        @org.mapstruct.Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
        public interface Mapper extends GenericMapper<Attendance, EditForm> {
            Mapper INSTANCE = Mappers.getMapper(Mapper.class);
        }
    }
}
