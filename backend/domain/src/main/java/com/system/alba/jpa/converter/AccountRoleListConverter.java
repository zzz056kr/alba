package com.system.alba.jpa.converter;

import com.system.alba.common.AppType;
import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;
import org.springframework.util.StringUtils;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Converter
public class AccountRoleListConverter implements AttributeConverter<List<AppType.AccountRole>, String> {

    private static final String DELIMITER = ",";

    @Override
    public String convertToDatabaseColumn(List<AppType.AccountRole> attribute) {
        if (attribute == null || attribute.isEmpty()) {
            return null;
        }

        return attribute.stream()
                .map(Enum::name)
                .collect(Collectors.joining(DELIMITER));
    }

    @Override
    public List<AppType.AccountRole> convertToEntityAttribute(String dbData) {
        if (!StringUtils.hasText(dbData)) {
            return Collections.emptyList();
        }

        return Arrays.stream(dbData.split(DELIMITER))
                .map(String::trim)
                .filter(StringUtils::hasText)
                .map(AppType.AccountRole::valueOf)
                .collect(Collectors.toList());
    }
}