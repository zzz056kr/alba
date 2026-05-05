package com.system.alba.model.dto;

import com.system.alba.common.AppType;
import com.system.alba.common.GenericMapper;
import com.system.alba.model.PageListDto;
import com.system.alba.model.domain.ShopMember;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;
import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;
import org.mapstruct.ReportingPolicy;
import org.mapstruct.factory.Mappers;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public class ShopMemberDto {

    @Getter
    @Setter
    public static class Detail extends Summary {

        @org.mapstruct.Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
        public interface Mapper extends GenericMapper<Detail, ShopMember> {
            Mapper INSTANCE = Mappers.getMapper(Mapper.class);
        }
    }

    @Getter
    @Setter
    public static class Summary {
        private Long no;
        private ShopDto.Abbr shop;
        private AccountDto.Abbr account;
        private String name;
        private AppType.ShopRole shopRole;
        private Integer baseWage;
        private Boolean isAppUser;
        private AppType.EmploymentType employmentType;
        private AppType.ShopMemberStatus status;
        private LocalDate joinedAt;
        private LocalDateTime createdAt;

        @org.mapstruct.Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
        public interface Mapper extends GenericMapper<Summary, ShopMember> {
            Mapper INSTANCE = Mappers.getMapper(Mapper.class);
        }
    }

    @Getter
    @Setter
    public static class Abbr {
        private Long no;
        private String name;
        private AppType.ShopRole shopRole;
        private AppType.ShopMemberStatus status;

        @org.mapstruct.Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
        public interface Mapper extends GenericMapper<Abbr, ShopMember> {
            Mapper INSTANCE = Mappers.getMapper(Mapper.class);
        }
    }

    @Getter
    @Setter
    public static class JoinForm {
        @NotBlank
        private String inviteCode;
    }

    @Getter
    @Setter
    public static class SearchParams extends PageListDto.Request {
        private List<AppType.EmploymentType> employmentTypes;
        private List<AppType.ShopMemberStatus> statuses;
    }

    @Getter
    @Setter
    public static class ApproveForm {
        @NotNull
        @PositiveOrZero
        private Integer baseWage;
    }

    @Getter
    @Setter
    public static class ManualCreateForm {
        @NotBlank
        private String name;

        @NotNull
        @PositiveOrZero
        private Integer baseWage;

        @NotNull
        private AppType.EmploymentType employmentType;
    }
}
