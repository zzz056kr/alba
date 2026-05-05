package com.system.alba.config;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

import java.util.concurrent.Executor;

@EnableAsync
@Configuration
@RequiredArgsConstructor
public class AsyncConfig {

    private final AppProperties appProperties;

    @Bean(name = "asyncExecutor")
    public Executor asyncExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(appProperties.getAsync().getCorePoolSize());
        executor.setMaxPoolSize(appProperties.getAsync().getMaxPoolSize());
        executor.setQueueCapacity(appProperties.getAsync().getQueueCapacity());
        executor.setThreadNamePrefix("Async-");
        executor.initialize();
        return executor;
    }
}