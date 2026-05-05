package com.system.alba.config.security;

import com.system.alba.common.AppResultCode;
import com.system.alba.model.ResponseModel;
import com.system.alba.service.common.MessageService;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Slf4j
@Component
@RequiredArgsConstructor
public class CustomAccessDeniedHandler implements AccessDeniedHandler {

    private final ObjectMapper objectMapper;
    private final MessageService messageService;

    @Override
    public void handle(HttpServletRequest request, HttpServletResponse response, AccessDeniedException accessDeniedException) throws IOException {
        log.warn("Access Denied for {}: {}", request.getRequestURI(), accessDeniedException.getMessage());
        AppResultCode errorCode = AppResultCode.FORBIDDEN;

        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        response.setStatus(errorCode.getStatusCode().value());

        String code = errorCode.getResultCode();
        String message = messageService.getMessage(errorCode.getMessageCode());
        ResponseModel<?> responseModel = ResponseModel.error(code, message);

        objectMapper.writeValue(response.getOutputStream(), responseModel);
    }
}