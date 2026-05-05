package com.system.alba.common;

import lombok.Getter;
import org.springframework.http.HttpStatus;

import java.util.Arrays;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

public enum AppResultCode {
    BAD_REQUEST("BAD_REQUEST", HttpStatus.BAD_REQUEST, "RESULT_BAD_REQUEST"),
    ERROR("ERROR", HttpStatus.INTERNAL_SERVER_ERROR, "RESULT_ERROR"),
    FORBIDDEN("FORBIDDEN", HttpStatus.FORBIDDEN, "RESULT_FORBIDDEN"),
    FORMAT("FORMAT", HttpStatus.BAD_REQUEST, "RESULT_FORMAT"),
    INVALID_PARAMETER("INVALID_PARAMETER", HttpStatus.BAD_REQUEST, "RESULT_INVALID_PARAMETER"),
    MAX_UPLOAD("MAX_UPLOAD", HttpStatus.BAD_REQUEST, "RESULT_MAX_UPLOAD"),
    NOT_FOUND("NOT_FOUND", HttpStatus.NOT_FOUND, "RESULT_NOT_FOUND"),
    NOT_REQUEST("NOT_REQUEST", HttpStatus.NOT_FOUND, "RESULT_NOT_REQUEST"),
    UNAUTHORIZED("UNAUTHORIZED", HttpStatus.UNAUTHORIZED, "RESULT_UNAUTHORIZED"),
    ACCOUNT_LOCKED("ACCOUNT_LOCKED", HttpStatus.UNAUTHORIZED, "RESULT_ACCOUNT_LOCKED"),
    CONFLICT("CONFLICT", HttpStatus.CONFLICT, "RESULT_CONFLICT"),
    TOO_MANY_REQUESTS("TOO_MANY_REQUESTS", HttpStatus.TOO_MANY_REQUESTS, "RESULT_TOO_MANY_REQUESTS");

    private static final Map<String, AppResultCode> CODE_MAP =
        Arrays.stream(values()).collect(Collectors.toMap(AppResultCode::getResultCode, Function.identity()));

    @Getter private final String resultCode;
    @Getter private final HttpStatus statusCode;
    @Getter private final String messageCode;

    AppResultCode(String resultCode, HttpStatus statusCode, String messageCode) {
        this.resultCode = resultCode;
        this.statusCode = statusCode;
        this.messageCode = messageCode;
    }

    public static AppResultCode getByCode(String code) {
        AppResultCode result = CODE_MAP.get(code);
        if (result == null) {
            throw new IllegalStateException("Unknown AppResultCode value " + code);
        }
        return result;
    }
}
