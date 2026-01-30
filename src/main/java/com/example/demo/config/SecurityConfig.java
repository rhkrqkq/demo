package com.example.demo.config;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {
    private final JwtProvider jwtProvider;

    @Bean
    public org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer webSecurityCustomizer() {
        return (web) -> web.ignoring()
                .requestMatchers("/css/**", "/js/**", "/images/**", "/favicon.ico")
                .requestMatchers("/WEB-INF/views/**"); // JSP 파일 경로를 보안 필터에서 완전히 제외
    }

    @Bean
    public BCryptPasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable())
                .sessionManagement(session -> session
                        .sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(auth -> auth
                        // [포인트 1] JSP 포워딩을 무조건 허용해야 튕기지 않습니다.
                        .dispatcherTypeMatchers(jakarta.servlet.DispatcherType.FORWARD).permitAll()
                        // [포인트 2] 허용 경로에 /board/list가 정확히 포함되어야 합니다.
                        .requestMatchers("/mypage").authenticated()
                        .requestMatchers("/", "/board/list", "/board/view/**", "/board/login", "/board/signup").permitAll()
                        .requestMatchers("/api/member/**", "/api/board/list").permitAll()
                        .requestMatchers("/css/**", "/js/**", "/images/**", "/WEB-INF/views/**").permitAll()

                        .anyRequest().authenticated()
                )
                .addFilterBefore(new JwtAuthenticationFilter(jwtProvider), UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}
