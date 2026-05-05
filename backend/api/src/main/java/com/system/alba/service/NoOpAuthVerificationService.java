package com.system.alba.service;

import com.system.alba.common.AppResultCode;
import com.system.alba.exception.ServerException;
import com.system.alba.model.domain.Account;
import com.system.alba.service.auth.AuthVerificationService;
import com.system.alba.service.common.ThrowService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class NoOpAuthVerificationService implements AuthVerificationService {
    private static final String SERVICE = "AUTH_VERIFICATION";
    private static final String CATEGORY = "UNSUPPORTED";
    private static final String MESSAGE = "Email verification feature is disabled.";

    private final ThrowService throwService;

    @Override
    public boolean isVerificationSupported() {
        return false;
    }

    @Override
    public void sendJoinVerification(Account account, String email) throws ServerException {
        throw unsupported();
    }

    @Override
    public void sendPasswordResetVerification(Account account, String email) throws ServerException {
        throw unsupported();
    }

    @Override
    public void verifyPasswordReset(String email, String code) throws ServerException {
        throw unsupported();
    }

    private ServerException unsupported() {
        return throwService.throwErrorByMessage(SERVICE, CATEGORY, AppResultCode.ERROR, MESSAGE);
    }
}
