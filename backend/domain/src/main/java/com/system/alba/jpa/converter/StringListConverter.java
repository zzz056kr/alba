package com.system.alba.jpa.converter;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;
import org.springframework.util.StringUtils;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Converter
public class StringListConverter implements AttributeConverter<List<String>, String> {

    private static final String DELIMITER = ",";

    @Override
    public String convertToDatabaseColumn(List<String> attribute) {
        if (attribute == null || attribute.isEmpty()) {
            return null;
        }
        return attribute.stream()
            .filter(StringUtils::hasText)
            .collect(Collectors.joining(DELIMITER));
    }

    @Override
    public List<String> convertToEntityAttribute(String dbData) {
        if (!StringUtils.hasText(dbData)) {
            return Collections.emptyList();
        }
        return Arrays.stream(dbData.split(DELIMITER))
            .map(String::trim)
            .filter(StringUtils::hasText)
            .collect(Collectors.toList());
    }
}