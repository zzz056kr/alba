package com.system.alba.oauth2.config.security;

import com.system.alba.config.security.OAuth2SecurityConfigurer;
import com.system.alba.oauth2.config.security.handler.OAuth2AuthenticationFailureHandler;
import com.system.alba.oauth2.config.security.handler.OAuth2AuthenticationSuccessHandler;
import com.system.alba.oauth2.service.CustomOAuth2UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class DefaultOAuth2SecurityConfigurer implements OAuth2SecurityConfigurer {

    private final CustomAuthorizationRequestResolver customAuthorizationRequestResolver;
    private final CustomOAuth2UserService customOAuth2UserService;
    private final OAuth2AuthenticationSuccessHandler oAuth2AuthenticationSuccessHandler;
    private final OAuth2AuthenticationFailureHandler oAuth2AuthenticationFailureHandler;

    @Override
    public void configure(HttpSecurity http) throws Exception {
        http.oauth2Login(oauth2 -> oauth2
                .loginPage("/login")
                .authorizationEndpoint(authorization -> authorization
                        .baseUri("/oauth2/login")
                        .authorizationRequestResolver(customAuthorizationRequestResolver))
                .redirectionEndpoint(redirection -> redirection
                        .baseUri("/oauth2/callback/{registrationId}"))
                .userInfoEndpoint(userInfo -> userInfo.userService(customOAuth2UserService))
                .successHandler(oAuth2AuthenticationSuccessHandler)
                .failureHandler(oAuth2AuthenticationFailureHandler));
    }
}