package com.system.alba.service.common;

import com.system.alba.common.AppResultCode;
import com.system.alba.exception.ServerException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.exception.ExceptionUtils;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class ThrowService {
    private final Environment environment;
    private final MessageSourceAccessor messageSourceAccessor;

    public void printStackTrace(Throwable throwable) {
        final String[] profiles = environment.getActiveProfiles();
        final String profileName = (profiles.length > 0) ? profiles[0] : null;
        if ("local".equals(profileName)) {
            log.error("stackTrace:{}", ExceptionUtils.getStackTrace(throwable));
        }
    }

    public ServerException throwErrorByCode(String service, String category, AppResultCode result) throws ServerException {
        return throwServerException(service, category, result, null, null);
    }

    public ServerException throwErrorByCode(String service, String category, AppResultCode result, Throwable ex) throws ServerException {
        return throwServerException(service, category, result, ex, null);
    }

    public ServerException throwErrorByCode(String service, String category, AppResultCode result, Throwable ex, String messageCode) throws ServerException {
        String code = StringUtils.isBlank(messageCode) ? result.getMessageCode() : messageCode;
        String resultMessage = messageSourceAccessor.getMessage(code, code);
        return throwServerException(service, category, result, ex, resultMessage);
    }

    public ServerException throwErrorByCode(String service, String category, AppResultCode result, String messageCode) {
        String code = StringUtils.isBlank(messageCode) ? result.getMessageCode() : messageCode;
        String resultMessage = messageSourceAccessor.getMessage(code, code);
        return throwServerException(service, category, result, resultMessage);
    }

    public ServerException throwErrorByCode(String service, String category, AppResultCode result, Throwable ex, String message, Object[] args) throws ServerException {
        String resultMessage = messageSourceAccessor.getMessage(message, args);
        throw throwServerException(service, category, result, ex, resultMessage);
    }

    public ServerException throwErrorByCode(String service, String category, AppResultCode result, String message, Object[] args) throws ServerException {
        String resultMessage = messageSourceAccessor.getMessage(message, args, message);
        return throwServerException(service, category, result, resultMessage);
    }

    public ServerException throwErrorByMessage(String service, String category, AppResultCode result, Throwable ex, String resultMessage) throws ServerException {
        return throwServerException(service, category, result, ex, resultMessage);
    }

    public ServerException throwErrorByMessage(String service, String category, AppResultCode result) throws ServerException {
        String messageCode = result.getMessageCode();
        String resultMessage = messageSourceAccessor.getMessage(messageCode, messageCode);
        return throwServerException(service, category, result, resultMessage);
    }

    public ServerException throwErrorByMessage(String service, String category, AppResultCode result, Object[] args) throws ServerException {
        String messageCode = result.getMessageCode();
        String resultMessage = messageSourceAccessor.getMessage(messageCode, args, messageCode);
        return throwServerException(service, category, result, resultMessage);
    }

    public ServerException throwErrorByMessage(String service, String category, AppResultCode result, String resultMessage) throws ServerException {
        return throwServerException(service, category, result, resultMessage);
    }

    private ServerException throwServerException(String service, String category, AppResultCode result, Throwable ex, String resultMessage) {
        throw new ServerException(service, category, result.getStatusCode(), result.getResultCode(), resultMessage, ex);
    }

    private ServerException throwServerException(String service, String category, AppResultCode result, String resultMessage) {
        return new ServerException(service, category, result.getStatusCode(), result.getResultCode(), resultMessage, null);
    }

}