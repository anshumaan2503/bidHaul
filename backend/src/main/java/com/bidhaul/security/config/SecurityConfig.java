package com.bidhaul.security.config;

import com.bidhaul.security.jwt.JwtAuthenticationEntryPoint;
import com.bidhaul.security.jwt.JwtAuthenticationFilter;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final JwtAuthenticationEntryPoint unauthorizedHandler;

    private final JwtAuthenticationFilter jwtAuthenticationFilter;

    @Bean
    public PasswordEncoder passwordEncoder() {

        return new BCryptPasswordEncoder();
    }

    @Bean
    public AuthenticationManager authenticationManager(
            AuthenticationConfiguration authConfig
    ) throws Exception {

        return authConfig.getAuthenticationManager();
    }

    @Bean
    public SecurityFilterChain filterChain(
            HttpSecurity http
    ) throws Exception {

        http
                .csrf(
                        AbstractHttpConfigurer::disable
                )

                .exceptionHandling(
                        exception ->
                                exception.authenticationEntryPoint(
                                        unauthorizedHandler
                                )
                )

                .sessionManagement(
                        session ->
                                session.sessionCreationPolicy(
                                        SessionCreationPolicy.STATELESS
                                )
                )

                .authorizeHttpRequests(
                        auth -> auth

                                .requestMatchers(
                                        "/api/v1/auth/signup",
                                        "/api/v1/auth/login",
                                        "/api/v1/auth/admin-login",
                                        "/api/v1/auth/refresh"
                                )
                                .permitAll()

                                .requestMatchers(
                                        "/api/v1/payments/webhook"
                                )
                                .permitAll()

                                .requestMatchers(
                                        "/health",
                                        "/api/v1/health",
                                        "/actuator/**"
                                )
                                .permitAll()

                                .anyRequest()
                                .authenticated()
                );

        http.addFilterBefore(
                jwtAuthenticationFilter,
                UsernamePasswordAuthenticationFilter.class
        );

        return http.build();
    }
}