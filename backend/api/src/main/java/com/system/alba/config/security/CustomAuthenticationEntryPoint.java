package com.system.alba.config.security;

import com.system.alba.common.AppResultCode;
import com.system.alba.exception.ServerException;
import com.system.alba.model.ResponseModel;
import com.system.alba.service.common.MessageService;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Slf4j
@Component
@RequiredArgsConstructor
public class CustomAuthenticationEntryPoint implements AuthenticationEntryPoint {

    public static final String SERVER_EXCEPTION_ATTRIBUTE = "SERVER_EXCEPTION";

    private final ObjectMapper objectMapper;
    private final MessageService messageService;

    @Override
    public void commence(HttpServletRequest request, HttpServletResponse response, AuthenticationException authException) throws IOException {
        log.warn("Authentication failed for {}: {}", request.getRequestURI(), authException.getMessage());

        // request attribute에서 ServerException 확인 (CustomAuthorizationRequestResolver에서 저장)
        ServerException serverException = (ServerException) request.getAttribute(SERVER_EXCEPTION_ATTRIBUTE);

        // request attribute에 없으면 cause chain에서 찾기
        if (serverException == null) {
            serverException = findServerException(authException);
        }

        response.setContentType(MediaType.APPLICATION_JSON_VALUE);

        String code;
        String message;
        HttpStatus status;

        if (serverException != null) {
            // ServerException의 정보 사용
            status = serverException.getHttpStatus();
            code = serverException.getResultCode();
            message = serverException.getMessage();
        } else {
            // 기본 UNAUTHORIZED 응답
            AppResultCode errorCode = AppResultCode.UNAUTHORIZED;
            status = errorCode.getStatusCode();
            code = errorCode.getResultCode();
            message = messageService.getMessage(errorCode.getMessageCode());
        }

        response.setStatus(status.value());
        ResponseModel<?> responseModel = ResponseModel.error(code, message);
        objectMapper.writeValue(response.getOutputStream(), responseModel);
    }

    /**
     * 예외 cause 체인에서 ServerException 찾기
     */
    private ServerException findServerException(Throwable throwable) {
        Throwable current = throwable;
        while (current != null) {
            if (current instanceof ServerException) {
                return (ServerException) current;
            }
            current = current.getCause();
        }
        return null;
    }
}