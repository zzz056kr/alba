package com.system.alba.repository.query;

import com.system.alba.model.domain.Account;
import com.system.alba.model.domain.QAccount;
import com.querydsl.jpa.impl.JPAQueryFactory;
import jakarta.persistence.LockModeType;
import lombok.RequiredArgsConstructor;

import java.util.List;
import java.util.stream.Collectors;

@RequiredArgsConstructor
public class AccountQueryRepositoryImpl implements AccountQueryRepository {

    private final JPAQueryFactory queryFactory;

    private static final QAccount account = QAccount.account;

    @Override
    public List<Account> findAllByNoInForUpdate(List<Long> nos) {
        return queryFactory
                .selectFrom(account)
                .where(account.no.in(nos))
                .orderBy(account.no.asc())
                .setLockMode(LockModeType.PESSIMISTIC_WRITE)
                .fetch();
    }

    @Override
    public List<Object[]> countGroupByStatus() {
        return queryFactory
                .select(account.status, account.count())
                .from(account)
                .groupBy(account.status)
                .fetch()
                .stream()
                .map(t -> new Object[]{t.get(account.status), t.get(account.count())})
                .collect(Collectors.toList());
    }
}