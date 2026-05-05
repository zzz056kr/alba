package com.system.alba.model.dto;

import com.system.alba.common.AppType;
import com.system.alba.common.GenericMapper;
import com.system.alba.model.domain.Token;
import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;
import org.mapstruct.ReportingPolicy;
import org.mapstruct.factory.Mappers;

import java.time.LocalDateTime;
import java.util.List;

public class TokenDto {

    @Getter
    @Setter
    public static class Detail extends Summary {
        private AccountDto.Abbr account;

        @org.mapstruct.Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
        public interface Mapper extends GenericMapper<Detail, Token> {
            Mapper INSTANCE = Mappers.getMapper(Mapper.class);
        }
    }

    @Getter
    @Setter
    public static class Summary {
        private String accessToken;
        private String refreshToken;
        private List<AppType.AccountRole> roles;
        private LocalDateTime accessExpiresAt;
        private LocalDateTime refreshExpiresAt;
    }

    @Getter
    @Setter
    public static class TokenResponse {
        private String accessToken;
        private int accessTokenExpiresIn;
        private List<AppType.AccountRole> roles;
        private AccountDto.Abbr account;

        @org.mapstruct.Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
        public interface Mapper extends GenericMapper<TokenResponse, Detail> {
            Mapper INSTANCE = Mappers.getMapper(Mapper.class);
        }
    }

    @Getter
    @Setter
    public static class AppTokenResponse {
        private String accessToken;
        private int accessTokenExpiresIn;
        private String refreshToken;
        private int refreshTokenExpiresIn;
        private List<AppType.AccountRole> roles;
        private AccountDto.Abbr account;

        @org.mapstruct.Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
        public interface Mapper extends GenericMapper<AppTokenResponse, Detail> {
            Mapper INSTANCE = Mappers.getMapper(Mapper.class);
        }
    }

    @Getter
    @Setter
    public static class RefreshRequest {
        @NotBlank
        private String refreshToken;
    }

    @Getter
    @Setter
    public static class LogoutRequest {
        @NotBlank
        private String refreshToken;
    }

}
