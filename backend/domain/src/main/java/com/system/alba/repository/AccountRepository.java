package com.system.alba.repository;

import com.system.alba.common.AppType;
import com.system.alba.model.domain.Account;
import com.system.alba.repository.query.AccountQueryRepository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface AccountRepository extends JpaRepository<Account, Long>, JpaSpecificationExecutor<Account>, AccountQueryRepository {

    Optional<Account> findByEmailAndProvider(String email, AppType.AuthProvider provider);

    Optional<Account> findByIdAndProvider(String id, AppType.AuthProvider provider);

    long countByStatus(AppType.Status status);

    List<Account> findTop5ByOrderByCreatedAtDesc();
}
