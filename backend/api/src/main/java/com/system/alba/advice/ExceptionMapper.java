package com.system.alba.advice;

import com.system.alba.advice.handler.*;
import com.system.alba.common.AppResultCode;
import com.system.alba.exception.ServerException;
import com.system.alba.model.ExceptionContext;
import com.system.alba.service.common.MessageService;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.stereotype.Component;
import org.springframework.validation.BindException;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.servlet.NoHandlerFoundException;

import java.security.SignatureException;
import java.util.LinkedHashMap;
import java.util.Map;

@Component
public class ExceptionMapper {
    private final MessageService messageService;
    private final Map<Class<? extends Throwable>, ExceptionHandlerSpec> handlers;

    public ExceptionMapper(MessageService messageService) {
        this.messageService = messageService;

        // LinkedHashMap으로 순서 보장 (구체적인 예외 → 일반적인 예외 순서)
        Map<Class<? extends Throwable>, ExceptionHandlerSpec> handlerMap = new LinkedHashMap<>();
        handlerMap.put(ServerException.class, new ServerExceptionHandler());
        handlerMap.put(BindException.class, new ValidationExceptionHandler(messageService));
        handlerMap.put(HttpMessageNotReadableException.class, new SimpleExceptionHandler(AppResultCode.FORMAT, messageService));
        handlerMap.put(MethodArgumentTypeMismatchException.class, new ThrowableMessageExceptionHandler(AppResultCode.BAD_REQUEST));
        handlerMap.put(IllegalStateException.class, new ThrowableMessageExceptionHandler(AppResultCode.BAD_REQUEST));
        handlerMap.put(SignatureException.class, new SimpleExceptionHandler(AppResultCode.FORBIDDEN, messageService));
        handlerMap.put(AccessDeniedException.class, new SimpleExceptionHandler(AppResultCode.FORBIDDEN, messageService));
        handlerMap.put(AuthenticationException.class, new SimpleExceptionHandler(AppResultCode.UNAUTHORIZED, messageService));
        handlerMap.put(NoHandlerFoundException.class, new SimpleExceptionHandler(AppResultCode.NOT_REQUEST, messageService));
        handlerMap.put(MaxUploadSizeExceededException.class, new SimpleExceptionHandler(AppResultCode.MAX_UPLOAD, messageService));
        this.handlers = handlerMap;
    }

    public ExceptionContext mapException(Throwable throwable) {
        return handlers.entrySet().stream()
            .filter(entry -> entry.getKey().isInstance(throwable))
            .findFirst()
            .map(entry -> entry.getValue().handle(throwable))
            .orElse(new ExceptionContext(AppResultCode.ERROR, messageService.getMessage(AppResultCode.ERROR.getMessageCode())));
    }
}