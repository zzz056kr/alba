package com.system.alba.repository;

import com.system.alba.model.domain.Token;
import com.system.alba.repository.query.TokenQueryRepository;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface TokenRepository extends JpaRepository<Token, Long>, TokenQueryRepository {

    /**
     * @EntityGraph: Token 조회 시 account 를 LEFT JOIN FETCH 로 함께 로딩한다.
     *
     * Token.account 는 FetchType.LAZY 로 선언되어 있어,
     * 기본적으로 Token 만 SELECT 되고 account 는 실제 접근 시점에 별도 SELECT 된다.
     *
     * 문제: WebSocket 채널 인터셉터는 JPA 세션이 열려있지 않은 스레드에서 실행된다.
     *      트랜잭션이 닫힌 후 token.getAccount() 를 호출하면 LazyInitializationException 이 발생한다.
     *
     * 해결: @EntityGraph 로 Token 조회 쿼리에 account 를 JOIN FETCH 하면
     *      트랜잭션이 끝난 뒤에도 account 데이터가 이미 메모리에 올라와 있어 안전하게 접근할 수 있다.
     *
     * 참고: HTTP 요청은 open-session-in-view 덕분에 LAZY 로도 문제없지만,
     *      WebSocket 인터셉터는 그 세션 밖이므로 반드시 EAGER 로딩이 필요하다.
     */
    @EntityGraph(attributePaths = {"account"})
    Optional<Token> findByAccessToken(String accessToken);

    Optional<Token> findByRefreshToken(String refreshToken);

    List<Token> findByAccount_Id(String accountId);

    List<Token> findByAccount_No(Long accountNo);
}
