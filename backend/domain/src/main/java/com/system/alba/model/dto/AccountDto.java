package com.system.alba.model.dto;

import com.system.alba.common.AppType;
import com.system.alba.common.GenericMapper;
import com.system.alba.common.LogOptionField;
import com.system.alba.model.PageListDto;
import com.system.alba.model.domain.Account;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;
import org.mapstruct.ReportingPolicy;
import org.mapstruct.factory.Mappers;

import java.util.List;

public class AccountDto {
    @Getter
    @Setter
    public static class Detail extends Summary {

        @org.mapstruct.Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
        public interface Mapper extends GenericMapper<Detail, Account> {
            Mapper INSTANCE = Mappers.getMapper(Mapper.class);
        }
    }

    @Getter
    @Setter
    public static class Summary {
        private Long no;
        private String id;
        private String name;
        private String email;
        private List<AppType.AccountRole> roles;
        private AppType.Status status;
        private java.time.LocalDateTime lastLoginAt;
        private java.time.LocalDateTime createdAt;

        @org.mapstruct.Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
        public interface Mapper extends GenericMapper<Summary, Account> {
            Mapper INSTANCE = Mappers.getMapper(Mapper.class);
        }
    }

    @Getter
    @Setter
    public static class SearchParams extends PageListDto.Request {
        private String keyword;
        private List<AppType.AccountRole> roles;
        private List<AppType.Status> statuses;
    }

    @Getter
    @Setter
    public static class Abbr {
        private String id;
        private String email;
        private AppType.AuthProvider provider;
    }

    @Getter
    @Setter
    public static class CreateForm {
        @NotBlank
        private String id;

        @NotBlank
        private String name;

        @NotBlank
        @LogOptionField(exclude = true)
        private String password;

        @NotBlank(message = "RESULT_ACCOUNT_EMAIL_EMPTY")
        @Email(message = "RESULT_ACCOUNT_INVALID_EMAIL")
        private String email;

        @org.mapstruct.Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
        public interface Mapper extends GenericMapper<Account, CreateForm> {
            Mapper INSTANCE = Mappers.getMapper(Mapper.class);
        }
    }

    @Getter
    @Setter
    public static class JoinForm {
        @NotBlank
        private String id;

        @NotBlank
        private String name;

        @NotBlank
        @LogOptionField(exclude = true)
        private String password;

        @NotBlank(message = "RESULT_ACCOUNT_EMAIL_EMPTY")
        @Email(message = "RESULT_ACCOUNT_INVALID_EMAIL")
        private String email;

        @org.mapstruct.Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
        public interface Mapper extends GenericMapper<Account, JoinForm> {
            Mapper INSTANCE = Mappers.getMapper(Mapper.class);
        }
    }

    @Getter
    @Setter
    public static class LoginForm {
        @NotBlank
        private String id;

        @NotBlank
        @LogOptionField(exclude = true)
        private String password;
    }

    @Getter
    @Setter
    public static class UpdateForm {
        @Email(message = "RESULT_ACCOUNT_INVALID_EMAIL")
        private String email;

        @org.mapstruct.Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
        public interface Mapper extends GenericMapper<Account, UpdateForm> {
            Mapper INSTANCE = Mappers.getMapper(Mapper.class);
        }
    }

    @Getter
    @Setter
    public static class EditForm {
        private String name;
        @Email(message = "RESULT_ACCOUNT_INVALID_EMAIL")
        private String email;
        private AppType.Status status;
        private List<AppType.AccountRole> roles;

        @org.mapstruct.Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
        public interface Mapper extends GenericMapper<Account, EditForm> {
            Mapper INSTANCE = Mappers.getMapper(Mapper.class);
        }
    }

    @Getter
    @Setter
    public static class ChangePasswordForm {
        @NotBlank(message = "RESULT_INVALID_PASSWORD")
        @LogOptionField(exclude = true)
        private String currentPassword;

        @NotBlank
        @LogOptionField(exclude = true)
        private String newPassword;
    }

    @Getter
    @Setter
    public static class AdminChangePasswordForm {
        @NotBlank
        @LogOptionField(exclude = true)
        private String newPassword;
    }

    @Getter
    @Setter
    public static class ChangePasswordByCodeForm {
        @NotBlank(message = "RESULT_EMAIL_AUTH_CODE_EMPTY")
        private String code;

        @NotBlank
        @LogOptionField(exclude = true)
        private String newPassword;
    }
}
