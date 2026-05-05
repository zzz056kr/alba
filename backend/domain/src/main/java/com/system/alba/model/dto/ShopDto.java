package com.system.alba.model.dto;

import com.system.alba.common.AppType;
import com.system.alba.common.GenericMapper;
import com.system.alba.model.domain.Shop;
import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;
import org.mapstruct.ReportingPolicy;
import org.mapstruct.factory.Mappers;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class ShopDto {

    @Getter
    @Setter
    public static class Detail extends Summary {

        @org.mapstruct.Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
        public interface Mapper extends GenericMapper<Detail, Shop> {
            Mapper INSTANCE = Mappers.getMapper(Mapper.class);
        }
    }

    @Getter
    @Setter
    public static class Summary {
        private Long no;
        private String name;
        private String address;
        private String inviteCode;
        private String qrCodeValue;
        private BigDecimal latitude;
        private BigDecimal longitude;
        private AppType.ShopStatus status;
        private LocalDateTime createdAt;

        @org.mapstruct.Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
        public interface Mapper extends GenericMapper<Summary, Shop> {
            Mapper INSTANCE = Mappers.getMapper(Mapper.class);
        }
    }

    @Getter
    @Setter
    public static class Abbr {
        private Long no;
        private String name;
        private AppType.ShopStatus status;

        @org.mapstruct.Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
        public interface Mapper extends GenericMapper<Abbr, Shop> {
            Mapper INSTANCE = Mappers.getMapper(Mapper.class);
        }
    }

    @Getter
    @Setter
    public static class CreateForm {
        @NotBlank
        private String name;

        private String address;

        @NotNull
        @DecimalMin(value = "-90.0")
        @DecimalMax(value = "90.0")
        private BigDecimal latitude;

        @NotNull
        @DecimalMin(value = "-180.0")
        @DecimalMax(value = "180.0")
        private BigDecimal longitude;

        @org.mapstruct.Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
        public interface Mapper extends GenericMapper<Shop, CreateForm> {
            Mapper INSTANCE = Mappers.getMapper(Mapper.class);
        }
    }

    @Getter
    @Setter
    public static class EditForm {
        private String name;
        private String address;

        @DecimalMin(value = "-90.0")
        @DecimalMax(value = "90.0")
        private BigDecimal latitude;

        @DecimalMin(value = "-180.0")
        @DecimalMax(value = "180.0")
        private BigDecimal longitude;

        private AppType.ShopStatus status;

        @org.mapstruct.Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
        public interface Mapper extends GenericMapper<Shop, EditForm> {
            Mapper INSTANCE = Mappers.getMapper(Mapper.class);
        }
    }

    @Getter
    @Setter
    public static class QrReissueResponse {
        private Long no;
        private String qrCodeValue;

        @org.mapstruct.Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
        public interface Mapper extends GenericMapper<QrReissueResponse, Shop> {
            Mapper INSTANCE = Mappers.getMapper(QrReissueResponse.Mapper.class);
        }
    }
}
