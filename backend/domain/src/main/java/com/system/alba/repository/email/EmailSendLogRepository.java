package com.system.alba.repository.email;

import com.system.alba.model.domain.email.EmailSendLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface EmailSendLogRepository extends JpaRepository<EmailSendLog, Long> {

    List<EmailSendLog> findByEmailOrderBySentAtDesc(String email);

    List<EmailSendLog> findByAccount_NoOrderBySentAtDesc(Long accountNo);

}
