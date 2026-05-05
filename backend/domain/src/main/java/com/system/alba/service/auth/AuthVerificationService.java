package com.system.alba.service.auth;

import com.system.alba.exception.ServerException;
import com.system.alba.model.domain.Account;

public interface AuthVerificationService {
    boolean isVerificationSupported();

    void sendJoinVerification(Account account, String email) throws ServerException;

    void sendPasswordResetVerification(Account account, String email) throws ServerException;

    void verifyPasswordReset(String email, String code) throws ServerException;
}
