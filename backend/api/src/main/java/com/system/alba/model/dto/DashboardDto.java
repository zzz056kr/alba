package com.system.alba.model.dto;

import com.system.alba.common.AppType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.List;

public class DashboardDto {

    @Getter
    @Setter
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Stats {
        private long totalAccounts;
        private long activeAccounts;
        private List<DailySignup> weeklyTrend;
        private List<StatusCount> statusCounts;
        private List<RecentAccount> recentAccounts;
    }

    @Getter
    @Setter
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class DailySignup {
        private String date;   // "2026-03-24"
        private long count;
    }

    @Getter
    @Setter
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class StatusCount {
        private String status;
        private long count;
    }

    @Getter
    @Setter
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class RecentAccount {
        private Long no;
        private String id;
        private String name;
        private String email;
        private List<AppType.AccountRole> roles;
        private AppType.Status status;
        private LocalDateTime createdAt;
    }
}
