package com.system.alba.repository.query;

import com.querydsl.jpa.impl.JPAQueryFactory;
import com.system.alba.model.domain.QToken;
import lombok.RequiredArgsConstructor;

import java.time.LocalDateTime;

@RequiredArgsConstructor
public class TokenQueryRepositoryImpl implements TokenQueryRepository {

    private final JPAQueryFactory queryFactory;

    private static final QToken token = QToken.token;

    @Override
    public int deleteExpiredTokens(LocalDateTime now) {
        long deleted = queryFactory
                .delete(token)
                .where(token.revokedYn.isTrue().or(token.refreshExpiresAt.lt(now)))
                .execute();
        return (int) deleted;
    }
}
