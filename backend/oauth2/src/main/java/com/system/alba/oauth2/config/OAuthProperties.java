package com.system.alba.oauth2.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Data
@Configuration
@ConfigurationProperties(prefix = "app.oauth")
public class OAuthProperties {
    private String[] allowedRedirectUrls;
}
