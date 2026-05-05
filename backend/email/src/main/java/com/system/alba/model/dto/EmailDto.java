package com.system.alba.model.dto;

import com.system.alba.common.AppType;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class EmailDto {

    @Getter
    @Setter
    public static class SendAuthCodeForm {
        @NotBlank(message = "RESULT_ACCOUNT_EMAIL_EMPTY")
        @Email(message = "RESULT_ACCOUNT_INVALID_EMAIL")
        private String email;

        @NotNull
        private AppType.EmailAuthType type;
    }

    @Getter
    @Setter
    public static class VerifyForm {
        @NotBlank(message = "RESULT_ACCOUNT_EMAIL_EMPTY")
        @Email(message = "RESULT_ACCOUNT_INVALID_EMAIL")
        private String email;

        @NotBlank(message = "RESULT_EMAIL_AUTH_CODE_EMPTY")
        private String code;

        @NotNull
        private AppType.EmailAuthType type;
    }

}