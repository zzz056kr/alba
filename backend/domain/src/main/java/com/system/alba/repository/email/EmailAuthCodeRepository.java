package com.system.alba.repository.email;

import com.system.alba.common.AppType;
import com.system.alba.model.domain.email.EmailAuthCode;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface EmailAuthCodeRepository extends JpaRepository<EmailAuthCode, Long> {

    Optional<EmailAuthCode> findByEmailAndCodeAndType(String email, String code, AppType.EmailAuthType type);

    Optional<EmailAuthCode> findTopByEmailAndTypeOrderByCreatedAtDesc(String email, AppType.EmailAuthType type);

}
