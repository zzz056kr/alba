package com.system.alba.advice.handler;

import com.system.alba.common.AppResultCode;
import com.system.alba.model.ExceptionContext;
import com.system.alba.service.common.MessageService;
import lombok.RequiredArgsConstructor;
import org.springframework.util.StringUtils;
import org.springframework.validation.BindException;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.validation.ObjectError;

import java.util.ArrayList;
import java.util.List;

@RequiredArgsConstructor
public class ValidationExceptionHandler implements ExceptionHandlerSpec {
    private final MessageService messageService;

    @Override
    public ExceptionContext handle(Throwable throwable) {
        if (!(throwable instanceof BindException bindException)) {
            return new ExceptionContext(AppResultCode.BAD_REQUEST, throwable.getMessage());
        }

        BindingResult bindResult = bindException.getBindingResult();
        String message = processValidationError(bindResult);
        return new ExceptionContext(AppResultCode.BAD_REQUEST, message);
    }

    private String processValidationError(BindingResult result) {
        List<ObjectError> allErrors = result.getAllErrors();
        List<String> messages = new ArrayList<>();

        for (ObjectError objectError : allErrors) {
            if (objectError instanceof FieldError fieldError) {
                String message = resolveLocalizedErrorField(fieldError);
                messages.add(message);
            } else {
                String message = resolveLocalizedErrorObject(objectError);
                messages.add(message);
            }
        }
        return String.join("\n", messages);
    }

    private String resolveLocalizedErrorField(FieldError fieldError) {
        String defaultMessage = fieldError.getDefaultMessage();
        String field = fieldError.getField();
        Object[] args = new Object[] { fieldError.getRejectedValue() };
        String message = String.format("[%s] %s", field, messageService.getMessage(defaultMessage, args));

        if (!StringUtils.hasText(message)) {
            args = new Object[] { fieldError.getField(), fieldError.getRejectedValue() };
            message = messageService.getMessage("RESULT_INVALID_FIELD", args);
        }

        return message;
    }

    private String resolveLocalizedErrorObject(ObjectError objectError) {
        String defaultMessage = objectError.getDefaultMessage();
        Object[] args = objectError.getArguments();
        String message = messageService.getMessage(defaultMessage, args);

        if (!StringUtils.hasText(message)) {
            args = new Object[] { objectError.getObjectName() };
            message = messageService.getMessage("RESULT_INVALID_FIELD", args);
        }
        return message;
    }
}