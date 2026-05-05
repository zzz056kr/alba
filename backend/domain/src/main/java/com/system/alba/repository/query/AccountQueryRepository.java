package com.system.alba.repository.query;

import com.system.alba.model.domain.Account;

import java.util.List;

public interface AccountQueryRepository {

    List<Account> findAllByNoInForUpdate(List<Long> nos);

    List<Object[]> countGroupByStatus();
}