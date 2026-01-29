package com.example.demo.api;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(IllegalArgumentException.class)
    // 데이터 조회 실패, 틀린 인자 전달 시 발생
    public ResponseEntity<ErrorResponse> handleIllegalArgumentException(IllegalArgumentException e) {
        return createErrorResponse(HttpStatus.BAD_REQUEST, "INVALID_INPUT", e.getMessage());
    }

    @ExceptionHandler(RuntimeException.class)
    // 권한 없음 로직 중 발생
    public ResponseEntity<ErrorResponse> handleRuntimeException(RuntimeException e) {
        return createErrorResponse(HttpStatus.INTERNAL_SERVER_ERROR, "SERVER_ERROR", e.getMessage());
    }

    @ExceptionHandler(Exception.class)
    // 그 외의 정의되지 않은 모든 예외
    public ResponseEntity<ErrorResponse> handleAllException(Exception e) {
        return createErrorResponse(HttpStatus.INTERNAL_SERVER_ERROR, "DEBUG_ERROR", e.getMessage());
    }

    private ResponseEntity<ErrorResponse> createErrorResponse(HttpStatus status, String code, String message) {
        ErrorResponse response = ErrorResponse.builder()
                .status(status.value())
                .code(code)
                .message(message)
                .build();
        return new ResponseEntity<>(response, status);
    }
}
