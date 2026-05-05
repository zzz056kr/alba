package com.system.alba.service;

import com.system.alba.model.domain.Account;
import com.system.alba.model.dto.DashboardDto;
import com.system.alba.repository.AccountRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class DashboardService {

    private final AccountRepository accountRepository;

    public DashboardDto.Stats getStats() {
        long totalAccounts = accountRepository.count();
        long activeAccounts = accountRepository.countByStatus(com.system.alba.common.AppType.Status.ACTIVE);

        LocalDateTime sevenDaysAgo = LocalDateTime.now().minusDays(7);
        List<Object[]> rawTrend = accountRepository.findDailySignupCountSince(sevenDaysAgo);
        List<DashboardDto.DailySignup> weeklyTrend = rawTrend.stream()
                .map(row -> DashboardDto.DailySignup.builder()
                        .date(row[0].toString())
                        .count(((Number) row[1]).longValue())
                        .build())
                .collect(Collectors.toList());

        List<Object[]> rawStatus = accountRepository.countGroupByStatus();
        List<DashboardDto.StatusCount> statusCounts = rawStatus.stream()
                .map(row -> DashboardDto.StatusCount.builder()
                        .status(row[0].toString())
                        .count(((Number) row[1]).longValue())
                        .build())
                .collect(Collectors.toList());

        List<Account> top5 = accountRepository.findTop5ByOrderByCreatedAtDesc();
        List<DashboardDto.RecentAccount> recentAccounts = top5.stream()
                .map(a -> DashboardDto.RecentAccount.builder()
                        .no(a.getNo())
                        .id(a.getId())
                        .name(a.getName())
                        .email(a.getEmail())
                        .roles(a.getRoles())
                        .status(a.getStatus())
                        .createdAt(a.getCreatedAt())
                        .build())
                .collect(Collectors.toList());

        return DashboardDto.Stats.builder()
                .totalAccounts(totalAccounts)
                .activeAccounts(activeAccounts)
                .weeklyTrend(weeklyTrend)
                .statusCounts(statusCounts)
                .recentAccounts(recentAccounts)
                .build();
    }
}
