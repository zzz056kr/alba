package com.system.alba.exception;

import com.system.alba.common.AppResultCode;
import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
public class ServerException extends RuntimeException {

    private final String service;
    private final String category;
    private final HttpStatus httpStatus;
    private final String resultCode;

    public ServerException(String service, String category, HttpStatus httpStatus, String resultCode, String resultMessage, Throwable throwable){
        super(resultMessage, throwable);
        this.service = service;
        this.category = category;
        this.httpStatus = httpStatus;
        this.resultCode = resultCode;
    }

    public ServerException(String service, String category, AppResultCode appResultCode) {
        super(appResultCode.getMessageCode(), null);
        this.service = service;
        this.category = category;
        this.httpStatus = appResultCode.getStatusCode();
        this.resultCode = appResultCode.getResultCode();
    }
}
