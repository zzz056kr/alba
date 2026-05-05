package com.system.alba.model.domain;

import com.system.alba.common.AppType;
import com.system.alba.model.BaseEntity;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@Table(indexes = {
        @Index(name = "idx_attendance_date", columnList = "shopNo, workDate")
})
public class Attendance extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long no;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "shopNo")
    private Shop shop;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "shopMemberNo")
    private ShopMember shopMember;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "scheduleNo")
    private Schedule schedule;

    private LocalDate workDate;
    private LocalDateTime clockInAt;
    private BigDecimal clockInLat;
    private BigDecimal clockInLng;
    private LocalDateTime clockOutAt;
    private BigDecimal clockOutLat;
    private BigDecimal clockOutLng;

    @Enumerated(EnumType.STRING)
    private AppType.AttendanceAuthType authType;

    @Enumerated(EnumType.STRING)
    private AppType.ClockInStatus clockInStatus;

    @Enumerated(EnumType.STRING)
    private AppType.ClockOutStatus clockOutStatus;
}
