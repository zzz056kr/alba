package com.system.alba.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Data
@Configuration
@ConfigurationProperties(prefix = "app")
public class AppProperties {
    private final AuthProperties auth = new AuthProperties();
    private final CacheProperties cache = new CacheProperties();
    private final AsyncProperties async = new AsyncProperties();
    private final SchedulerProperties scheduler = new SchedulerProperties();

    @Data
    public static class AuthProperties {
        private int accessExpiresSeconds;
        private int refreshExpiresSeconds;
        private String refreshTokenCookieName;
    }

    @Data
    public static class CacheProperties {
        private String type = "memory"; // memory 또는 redis
    }

    @Data
    public static class AsyncProperties {
        private int corePoolSize = 2;
        private int maxPoolSize = 10;
        private int queueCapacity = 100;
    }

    @Data
    public static class SchedulerProperties {
        private String tokenCleanupCron = "0 0 3 * * *";
    }
}