package com.system.alba.advice.handler;

import com.system.alba.common.AppResultCode;
import com.system.alba.exception.ServerException;
import com.system.alba.model.ExceptionContext;

public class ServerExceptionHandler implements ExceptionHandlerSpec {

    @Override
    public ExceptionContext handle(Throwable throwable) {
        if (!(throwable instanceof ServerException serverException)) {
            return new ExceptionContext(AppResultCode.ERROR, throwable.getMessage());
        }

        AppResultCode resultCode = AppResultCode.getByCode(serverException.getResultCode());
        return new ExceptionContext(
            resultCode,
            serverException.getMessage(),
            serverException.getService(),
            serverException.getCategory()
        );
    }
}