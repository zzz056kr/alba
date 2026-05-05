package com.system.alba.config.security;

import org.springframework.security.config.annotation.web.builders.HttpSecurity;

public interface OAuth2SecurityConfigurer {
    void configure(HttpSecurity http) throws Exception;
}