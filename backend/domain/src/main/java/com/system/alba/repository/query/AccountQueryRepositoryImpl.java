package com.system.alba.repository.query;

import com.system.alba.model.domain.Account;
import com.system.alba.model.domain.QAccount;
import com.querydsl.core.types.dsl.DateExpression;
import com.querydsl.core.types.dsl.Expressions;
import com.querydsl.jpa.impl.JPAQueryFactory;
import jakarta.persistence.LockModeType;
import lombok.RequiredArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@RequiredArgsConstructor
public class AccountQueryRepositoryImpl implements AccountQueryRepository {

    private final JPAQueryFactory queryFactory;

    private static final QAccount account = QAccount.account;

    @Override
    public Optional<Account> findByLoginId(String loginId) {
        return Optional.ofNullable(
                queryFactory
                        .selectFrom(account)
                        .where(account.id.eq(loginId))
                        .fetchOne()
        );
    }

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

    @Override
    public List<Object[]> findDailySignupCountSince(LocalDateTime from) {
        DateExpression<LocalDate> createdDate = Expressions.dateTemplate(LocalDate.class, "DATE({0})", account.createdAt);

        return queryFactory
                .select(createdDate, account.count())
                .from(account)
                .where(account.createdAt.goe(from))
                .groupBy(createdDate)
                .orderBy(createdDate.asc())
                .fetch()
                .stream()
                .map(t -> new Object[]{t.get(createdDate), t.get(account.count())})
                .collect(Collectors.toList());
    }
}
