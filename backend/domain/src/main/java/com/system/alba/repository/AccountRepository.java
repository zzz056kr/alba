package com.system.alba.repository;

import com.system.alba.common.AppType;
import com.system.alba.model.domain.Account;
import com.system.alba.repository.query.AccountQueryRepository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface AccountRepository extends JpaRepository<Account, Long>, JpaSpecificationExecutor<Account>, AccountQueryRepository {

    // 메서드명이 findByLoginId 이지만 실제 엔티티 필드명은 'id' 이므로
    // JPA 네이밍 컨벤션으로는 'loginId' 필드를 찾아 오류가 발생한다. @Query 유지.
    @Query("SELECT a FROM Account a WHERE a.id = :id")
    Optional<Account> findByLoginId(@Param("id") String id);

    Optional<Account> findByEmailAndProvider(String email, AppType.AuthProvider provider);

    Optional<Account> findByIdAndProvider(String id, AppType.AuthProvider provider);

    long countByStatus(AppType.Status status);

    List<Account> findTop5ByOrderByCreatedAtDesc();

    // DB 종속 함수 DATE() 를 사용하는 native query 로 QueryDSL 로 대체 불가.
    @Query(value = "SELECT DATE(a.created_at) as signupDate, COUNT(*) as signupCount " +
            "FROM t_account a WHERE a.created_at >= :from " +
            "GROUP BY DATE(a.created_at) ORDER BY DATE(a.created_at) ASC", nativeQuery = true)
    List<Object[]> findDailySignupCountSince(@Param("from") LocalDateTime from);
}
