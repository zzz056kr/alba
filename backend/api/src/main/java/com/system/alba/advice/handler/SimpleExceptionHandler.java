package com.system.alba.advice.handler;

import com.system.alba.common.AppResultCode;
import com.system.alba.model.ExceptionContext;
import com.system.alba.service.common.MessageService;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
public class SimpleExceptionHandler implements ExceptionHandlerSpec {
    private final AppResultCode resultCode;
    private final MessageService messageService;

    @Override
    public ExceptionContext handle(Throwable throwable) {
        String message = messageService.getMessage(resultCode.getMessageCode());
        return new ExceptionContext(resultCode, message);
    }
}