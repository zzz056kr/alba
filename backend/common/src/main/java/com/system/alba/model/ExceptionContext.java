package com.system.alba.model;

import com.system.alba.common.AppResultCode;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class ExceptionContext {
    private final AppResultCode resultCode;
    private final String message;
    private final String service;
    private final String category;
    private final Object[] messageArgs;

    public ExceptionContext(AppResultCode resultCode, String message) {
        this(resultCode, message, "UNKNOWN", "UNKNOWN", null);
    }

    public ExceptionContext(AppResultCode resultCode, String message, String service, String category) {
        this(resultCode, message, service, category, null);
    }
}