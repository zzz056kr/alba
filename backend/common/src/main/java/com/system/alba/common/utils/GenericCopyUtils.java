package com.system.alba.common.utils;

import org.springframework.beans.BeanUtils;

import java.lang.reflect.Field;

public class GenericCopyUtils {

    // 객체 복사 (특정 필드 제외 가능)
    public static <T> T copy(T entity, String... ignoreFields) {
        try {
            @SuppressWarnings("unchecked")
            T copy = (T) entity.getClass().getDeclaredConstructor().newInstance();
            BeanUtils.copyProperties(entity, copy, ignoreFields);
            return copy;
        } catch (Exception e) {
            throw new RuntimeException("객체 복사 실패", e);
        }
    }

    // 특정 필드 값 변경 후 복사
    public static <T> T copyWithFieldChange(T entity, String fieldName, Object fieldValue, String... ignoreFields) {
        T copy = copy(entity, ignoreFields);
        try {
            Field field = getField(entity.getClass(), fieldName);
            field.setAccessible(true);
            field.set(copy, fieldValue);
        } catch (Exception e) {
            throw new RuntimeException("필드 변경 실패", e);
        }
        return copy;
    }

    private static Field getField(Class<?> clazz, String fieldName) throws NoSuchFieldException {
        Class<?> currentClass = clazz;
        while (currentClass != null) {
            try {
                return currentClass.getDeclaredField(fieldName);
            } catch (NoSuchFieldException e) {
                currentClass = currentClass.getSuperclass();
            }
        }
        throw new NoSuchFieldException(fieldName);
    }

}
