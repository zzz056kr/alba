package com.system.alba.service;

import com.system.alba.common.AppConstants;
import com.system.alba.model.domain.Account;
import com.system.alba.model.domain.email.EmailSendLog;
import com.system.alba.repository.email.EmailAuthCodeRepository;
import com.system.alba.repository.email.EmailSendLogRepository;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@RequiredArgsConstructor
public class EmailService {

    private final JavaMailSender mailSender;
    private final EmailSendLogRepository emailSendLogRepository;
    private final EmailAuthCodeRepository emailAuthCodeRepository;

    // @Async/@Transactional은 Spring 프록시를 통해서만 동작함.
    // 내부에서 this.send()를 호출하면 프록시를 우회하므로 self-injection으로 해결.
    @Lazy
    @Autowired
    private EmailService self;

    public void send(String to, String title, String content) {
        self.send(null, to, title, content, null);
    }

    public void send(Account account, String to, String title, String content) {
        self.send(account, to, title, content, null);
    }

    // @Async: 별도 스레드에서 실행 (호출자 트랜잭션과 무관)
    // @Transactional: 비동기 스레드 자체에서 새 트랜잭션 시작 → emailSendLog/emailAuthCode DB 저장 보장
    @Async
    @Transactional
    public void send(Account account, String to, String title, String content, Long emailAuthCodeNo) {
        EmailSendLog emailLog = new EmailSendLog();
        emailLog.setAccount(account);
        emailLog.setEmail(to);
        emailLog.setTitle(title);
        emailLog.setContent(content);

        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, AppConstants.ENCODING);

            helper.setTo(to);
            helper.setSubject(title);
            helper.setText(content, true);

            mailSender.send(message);

            emailLog.setSuccessYn(true);
            log.info("Email sent successfully to: {}", to);
        } catch (MessagingException e) {
            emailLog.setSuccessYn(false);
            emailLog.setFailReason(e.getMessage());
            log.error("Failed to send email to: {}, error: {}", to, e.getMessage());
        }

        emailSendLogRepository.save(emailLog);

        // EmailAuthCode 발송 결과 업데이트
        if (emailAuthCodeNo != null) {
            emailAuthCodeRepository.findById(emailAuthCodeNo).ifPresent(authCode -> {
                authCode.setSendSuccessYn(emailLog.getSuccessYn());
                authCode.setSendFailReason(emailLog.getFailReason());
                emailAuthCodeRepository.save(authCode);
            });
        }
    }

    public void sendAuthCode(Account account, String to, String code, Long emailAuthCodeNo) {
        String title = "인증 코드 안내";
        String content = buildAuthCodeTemplate(code);
        self.send(account, to, title, content, emailAuthCodeNo);
    }

    private String buildAuthCodeTemplate(String code) {
        return """
            <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                <h2>인증 코드</h2>
                <p>아래 인증 코드를 입력해 주세요.</p>
                <div style="background-color: #f4f4f4; padding: 20px; text-align: center; font-size: 32px; font-weight: bold; letter-spacing: 5px;">
                    %s
                </div>
                <p style="color: #666; margin-top: 20px;">이 코드는 일정 시간 후 만료됩니다.</p>
            </div>
            """.formatted(code);
    }
}