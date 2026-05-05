package com.system.alba.repository.query;

import java.time.LocalDateTime;

public interface TokenQueryRepository {

    int deleteExpiredTokens(LocalDateTime now);
}
