package com.system.alba.service;

import com.system.alba.common.AppResultCode;
import com.system.alba.config.AppProperties;
import com.system.alba.exception.ServerException;
import com.system.alba.service.common.ThrowService;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.apache.commons.lang3.StringUtils;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestClient;
import org.springframework.web.util.UriComponentsBuilder;

import java.math.BigDecimal;
import java.net.URI;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class ShopGeocodingService {
    private static final String SERVICE = "SHOP";
    private static final String CATEGORY = "GEOCODING";

    private final AppProperties appProperties;
    private final ThrowService throwService;
    private final RestClient restClient = RestClient.builder().build();

    public Coordinates resolveCoordinates(String address) throws ServerException {
        String keyword = StringUtils.trimToEmpty(address);
        if (keyword.isEmpty()) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.BAD_REQUEST, "RESULT_SHOP_ADDRESS_REQUIRED");
        }

        AppProperties.KakaoProperties kakao = appProperties.getGeocoding().getKakao();
        if (StringUtils.isBlank(kakao.getRestApiKey())) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.ERROR, "RESULT_SHOP_GEOCODING_NOT_CONFIGURED");
        }

        URI uri = UriComponentsBuilder
                .fromUriString(kakao.getLocalApiUrl())
                .queryParam("query", keyword)
                .encode()
                .build()
                .toUri();

        Map<String, Object> response;
        try {
            response = restClient.get()
                    .uri(uri)
                    .header(HttpHeaders.AUTHORIZATION, "KakaoAK " + kakao.getRestApiKey())
                    .accept(MediaType.APPLICATION_JSON)
                    .retrieve()
                    .body(new ParameterizedTypeReference<>() {
                    });
        } catch (HttpClientErrorException.Forbidden exception) {
            throw throwService.throwErrorByCode(
                    SERVICE,
                    CATEGORY,
                    AppResultCode.BAD_REQUEST,
                    "RESULT_SHOP_GEOCODING_PROVIDER_FORBIDDEN"
            );
        } catch (HttpClientErrorException exception) {
            throw throwService.throwErrorByCode(
                    SERVICE,
                    CATEGORY,
                    AppResultCode.BAD_REQUEST,
                    "RESULT_SHOP_GEOCODING_FAILED"
            );
        } catch (Exception exception) {
            throw throwService.throwErrorByCode(
                    SERVICE,
                    CATEGORY,
                    AppResultCode.ERROR,
                    "RESULT_SHOP_GEOCODING_UNAVAILABLE"
            );
        }

        List<Map<String, Object>> documents = response == null
                ? List.of()
                : (List<Map<String, Object>>) response.getOrDefault("documents", List.of());

        if (documents.isEmpty()) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.BAD_REQUEST, "RESULT_SHOP_GEOCODING_FAILED");
        }

        Map<String, Object> first = documents.getFirst();
        String latitude = String.valueOf(first.getOrDefault("y", ""));
        String longitude = String.valueOf(first.getOrDefault("x", ""));
        if (StringUtils.isBlank(latitude) || StringUtils.isBlank(longitude)) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.BAD_REQUEST, "RESULT_SHOP_GEOCODING_FAILED");
        }

        return new Coordinates(new BigDecimal(latitude), new BigDecimal(longitude));
    }

    @Getter
    @RequiredArgsConstructor
    public static class Coordinates {
        private final BigDecimal latitude;
        private final BigDecimal longitude;
    }
}
