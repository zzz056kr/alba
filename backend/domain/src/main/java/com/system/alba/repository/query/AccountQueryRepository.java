package com.system.alba.repository.query;

import com.system.alba.model.domain.Account;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface AccountQueryRepository {

    Optional<Account> findByLoginId(String loginId);

    List<Account> findAllByNoInForUpdate(List<Long> nos);

    List<Object[]> countGroupByStatus();

    List<Object[]> findDailySignupCountSince(LocalDateTime from);
}
