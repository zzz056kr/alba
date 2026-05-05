package com.system.alba.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

import java.util.HashSet;
import java.util.Set;

@Data
@Configuration
@ConfigurationProperties(prefix = "app.code")
public class AppCodeProperties {
    private final Auth auth = new Auth();
    private final OAuth2 oauth2 = new OAuth2();

    @Data
    public static class Auth {
        private boolean multiLogin = true;
        private int loginFailLimit = 5;
        private final Regex id = new Regex();
        private final Regex password = new Regex();
        private final Email email = new Email();
    }

    @Data
    public static class Regex {
        private String regex;
        private String message;
    }

    @Data
    public static class Email {
        private boolean verificationRequired = true;
        private int expireMinutes = 5;
        private int resendSeconds = 60;
        private int failResendSeconds = 10;
        private int failLimit = 5;
    }

    @Data
    public static class OAuth2 {
        private Set<String> enabledProviders = new HashSet<>();

        public boolean isProviderEnabled(String provider) {
            if (provider == null) return false;
            return enabledProviders.contains(provider.toUpperCase());
        }
    }
}