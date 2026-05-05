package com.system.alba.config;

import com.system.alba.config.security.CustomAccessDeniedHandler;
import com.system.alba.config.security.CustomAuthenticationEntryPoint;
import com.system.alba.config.security.OAuth2SecurityConfigurer;
import com.system.alba.config.security.filter.OpaqueTokenAuthenticationFilter;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.http.HttpMethod;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.Arrays;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final OpaqueTokenAuthenticationFilter opaqueTokenAuthenticationFilter;
    private final CustomAuthenticationEntryPoint customAuthenticationEntryPoint;
    private final CustomAccessDeniedHandler customAccessDeniedHandler;

    // oauth2 모듈 포함 시 자동 주입, 미포함 시 null
    @Autowired(required = false)
    private OAuth2SecurityConfigurer oauth2SecurityConfigurer;

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .cors(Customizer.withDefaults())
                .csrf(AbstractHttpConfigurer::disable)
                .formLogin(AbstractHttpConfigurer::disable)
                .httpBasic(AbstractHttpConfigurer::disable)
                // Stateless (세션 사용 X)
                .sessionManagement(configurer -> configurer.sessionCreationPolicy(SessionCreationPolicy.STATELESS))

                .authorizeHttpRequests(auth -> auth
                        // Swagger
                        .requestMatchers("/swagger-ui/**", "/v3/api-docs/**").permitAll()
                        // 인증 관련 API
                        .requestMatchers("/auth/**").permitAll()
                        // 앱 인증 관련 API
                        .requestMatchers("/app/auth/**").permitAll()
                        // 이메일 인증 API
                        .requestMatchers("/email/**").permitAll()
                        // OAuth2 소셜 로그인
                        .requestMatchers("/oauth2/**").permitAll()
                        // 회원가입
                        .requestMatchers(HttpMethod.POST, "/account/join").permitAll()
                        // 공개 조회 API
                        .requestMatchers(HttpMethod.GET, "/test-data/search").permitAll()
                        // 나머지는 인증 필요 (세부 권한은 @PreAuthorize로 처리)
                        .anyRequest().authenticated())

                // 인증/인가 실패 시 JSON 응답
                .exceptionHandling(exception -> exception
                        .authenticationEntryPoint(customAuthenticationEntryPoint)
                        .accessDeniedHandler(customAccessDeniedHandler))

                // Opaque Token 필터 추가
                .addFilterBefore(opaqueTokenAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        // OAuth2 로그인 (oauth2 모듈 포함 시에만 활성화)
        if (oauth2SecurityConfigurer != null) {
            oauth2SecurityConfigurer.configure(http);
        }

        return http.build();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();

        // 허용할 Origin 설정
        configuration.setAllowedOriginPatterns(Arrays.asList("*"));

        // 허용할 HTTP Method 설정
        configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"));

        // 허용할 Header 설정
        configuration.setAllowedHeaders(Arrays.asList("*"));

        // 인증정보 허용
        configuration.setAllowCredentials(true);

        // Pre-flight 요청 캐시 시간
        configuration.setMaxAge(3600L);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);

        return source;
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}