package com.system.alba.jpa.converter;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter
public class JsonNodeConverter implements AttributeConverter<JsonNode, String> {
    private final ObjectMapper objectMapper;

    public JsonNodeConverter() {
        ObjectMapper objectMapper = new ObjectMapper();
        this.objectMapper = objectMapper;
    }

    @Override
    public String convertToDatabaseColumn(JsonNode attribute) {
        try {
            return attribute != null ? objectMapper.writeValueAsString(attribute) : null;
        } catch (Exception ex) {
            throw new RuntimeException("JsonNode 변환 실패", ex);
        }
    }

    @Override
    public JsonNode convertToEntityAttribute(String dbData) {
        try {
            return dbData != null ? objectMapper.readTree(dbData) : null;
        } catch (Exception ex) {
            throw new RuntimeException("Json 변환 실패", ex);
        }
    }
}
