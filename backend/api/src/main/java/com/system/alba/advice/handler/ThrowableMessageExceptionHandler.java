package com.system.alba.advice.handler;

import com.system.alba.common.AppResultCode;
import com.system.alba.model.ExceptionContext;

public class ThrowableMessageExceptionHandler implements ExceptionHandlerSpec {
    private final AppResultCode resultCode;

    public ThrowableMessageExceptionHandler(AppResultCode resultCode) {
        this.resultCode = resultCode;
    }

    @Override
    public ExceptionContext handle(Throwable throwable) {
        return new ExceptionContext(resultCode, throwable.getMessage());
    }
}