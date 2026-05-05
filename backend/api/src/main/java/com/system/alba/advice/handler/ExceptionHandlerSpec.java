package com.system.alba.advice.handler;

import com.system.alba.model.ExceptionContext;

public interface ExceptionHandlerSpec {
    ExceptionContext handle(Throwable throwable);
}