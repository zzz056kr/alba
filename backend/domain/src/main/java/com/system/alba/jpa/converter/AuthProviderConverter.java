package com.system.alba.jpa.converter;

import com.system.alba.common.AppType;
import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

import java.util.stream.Stream;

@Converter(autoApply = true)
public class AuthProviderConverter implements AttributeConverter<AppType.AuthProvider, String> {

    @Override
    public String convertToDatabaseColumn(AppType.AuthProvider authProvider) {
        if (authProvider == null) {
            return null;
        }
        return authProvider.getCode();
    }

    @Override
    public AppType.AuthProvider convertToEntityAttribute(String code) {
        if (code == null) {
            return null;
        }

        // code(LOCAL, GOOGLE, NAVER, KAKAO) 또는 registrationId(local, google, naver, kakao)로 매칭
        return Stream.of(AppType.AuthProvider.values())
                .filter(c -> c.getCode().equalsIgnoreCase(code) || c.getRegistrationId().equalsIgnoreCase(code))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("Unknown AuthProvider code: " + code));
    }
}
