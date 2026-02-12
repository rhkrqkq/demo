package com.example.demo.config;

import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final JwtProvider jwtProvider;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable()) // API 방식이므로 비활성화
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS)) // 세션 미사용

                .authorizeHttpRequests(auth -> auth
                        // 1. JSP 포워딩 및 정적 리소스 허용
                        .dispatcherTypeMatchers(jakarta.servlet.DispatcherType.FORWARD).permitAll()
                        .requestMatchers("/css/**", "/js/**", "/images/**", "/favicon.ico").permitAll()

                        // 2. 로그인, 회원가입, 홈, 게시판 목록은 모두 접근 허용
                        // (HttpMethod.POST를 명시하지 않아도 경로로 통과시키는 것이 더 확실합니다)
                        .requestMatchers("/", "/board/login", "/board/signup", "/board/list").permitAll()
                        .requestMatchers("/api/member/**").permitAll()

                        // 3. 그 외 API 및 마이페이지 등은 인증 필수
                        .anyRequest().authenticated()
                )

                .exceptionHandling(ex -> ex
                        .authenticationEntryPoint((request, response, authException) -> {
                            // [수정] 리다이렉트 대신 401 에러를 명확히 던져서 브라우저가 원인을 알게 합니다.
                            // 로그에 Secured GET / 가 뜨는 주범인 리다이렉트를 방지합니다.
                            response.setContentType("application/json;charset=UTF-8");
                            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                            response.getWriter().write("{\"message\":\"인증이 필요합니다.\"}");
                        })
                )

                // [수정] 필터 순서를 시큐리티의 가장 앞단으로 조정하여 다른 필터의 간섭을 차단합니다.
                .addFilterBefore(new JwtAuthenticationFilter(jwtProvider),
                        org.springframework.security.web.context.SecurityContextHolderFilter.class);

        return http.build();
    }
}