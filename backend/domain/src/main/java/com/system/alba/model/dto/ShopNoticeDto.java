package com.system.alba.model.dto;

import com.system.alba.common.AppType;
import com.system.alba.common.GenericMapper;
import com.system.alba.model.domain.ShopNotice;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Getter;
import lombok.Setter;
import org.mapstruct.ReportingPolicy;
import org.mapstruct.factory.Mappers;

import java.time.LocalDateTime;

public class ShopNoticeDto {

    @Getter
    @Setter
    public static class Detail extends Summary {

        @org.mapstruct.Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
        public interface Mapper extends GenericMapper<Detail, ShopNotice> {
            Mapper INSTANCE = Mappers.getMapper(Mapper.class);
        }
    }

    @Getter
    @Setter
    public static class Summary {
        private Long no;
        private Long shopNo;
        private String title;
        private String content;
        private String pinnedYn;
        private AppType.ShopNoticeStatus status;
        private LocalDateTime createdAt;

        @org.mapstruct.Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
        public interface Mapper extends GenericMapper<Summary, ShopNotice> {
            @Override
            @org.mapstruct.Mapping(target = "shopNo", source = "shop.no")
            Summary sourceToDestination(ShopNotice entity);

            Mapper INSTANCE = Mappers.getMapper(Mapper.class);
        }
    }

    @Getter
    @Setter
    public static class Abbr {
        private Long no;
        private Long shopNo;
        private String title;
        private String pinnedYn;
        private AppType.ShopNoticeStatus status;

        @org.mapstruct.Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
        public interface Mapper extends GenericMapper<Abbr, ShopNotice> {
            @Override
            @org.mapstruct.Mapping(target = "shopNo", source = "shop.no")
            Abbr sourceToDestination(ShopNotice entity);

            Mapper INSTANCE = Mappers.getMapper(Mapper.class);
        }
    }

    @Getter
    @Setter
    public static class CreateForm {
        @NotBlank
        private String title;

        @NotBlank
        private String content;

        @Pattern(regexp = "Y|N")
        private String pinnedYn;

        @org.mapstruct.Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
        public interface Mapper extends GenericMapper<ShopNotice, CreateForm> {
            Mapper INSTANCE = Mappers.getMapper(Mapper.class);
        }
    }

    @Getter
    @Setter
    public static class EditForm {
        private String title;
        private String content;

        @Pattern(regexp = "Y|N")
        private String pinnedYn;

        private AppType.ShopNoticeStatus status;

        @org.mapstruct.Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
        public interface Mapper extends GenericMapper<ShopNotice, EditForm> {
            Mapper INSTANCE = Mappers.getMapper(Mapper.class);
        }
    }
}
