package com.system.alba.advice;

import com.system.alba.common.utils.FormatUtils;
import com.system.alba.model.ExceptionContext;
import com.system.alba.model.ResponseModel;
import com.system.alba.service.common.ThrowService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.env.Environment;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@Slf4j
@RestControllerAdvice
@RequiredArgsConstructor
public class ErrorControllerAdvice {
    private final Environment environment;
    private final ExceptionMapper exceptionMapper;
    private final ThrowService throwService;

    @ExceptionHandler(Throwable.class)
    public ResponseEntity<?> exceptionHandler(Throwable throwable, HttpServletRequest request) {
        ExceptionContext context = exceptionMapper.mapException(throwable);

        logError(context, throwable);

        ResponseModel<?> errorResponse = ResponseModel.error(
            context.getResultCode().getResultCode(),
            context.getMessage()
        );

        return new ResponseEntity<>(errorResponse, context.getResultCode().getStatusCode());
    }

    private void logError(ExceptionContext context, Throwable throwable) {
        String msg = FormatUtils.logString(
            context.getService(),
            context.getCategory(),
            context.getMessage(),
            throwable
        );
        log.error("message:{}, code:{}", msg, context.getResultCode().getResultCode());
        throwService.printStackTrace(throwable);
    }
}