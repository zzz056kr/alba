package com.system.alba.service.scheduler;

import com.system.alba.config.AppProperties;
import com.system.alba.repository.TokenRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Slf4j
@Service
@RequiredArgsConstructor
public class TokenCleanupScheduler {

    private final TokenRepository tokenRepository;
    private final AppProperties appProperties;

    @EventListener(ApplicationReadyEvent.class)
    @Transactional
    public void onApplicationReady() {
        int deletedCount = tokenRepository.deleteExpiredTokens(LocalDateTime.now());
        log.info("Expired tokens cleanup on startup completed. Deleted: {} tokens", deletedCount);
    }

    @Scheduled(cron = "#{@appProperties.scheduler.tokenCleanupCron}")
    @Transactional
    public void cleanupExpiredTokens() {
        int deletedCount = tokenRepository.deleteExpiredTokens(LocalDateTime.now());
        log.info("Expired tokens cleanup completed. Deleted: {} tokens", deletedCount);
    }
}
