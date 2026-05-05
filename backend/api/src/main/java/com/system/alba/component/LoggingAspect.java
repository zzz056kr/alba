package com.system.alba.component;

import ch.qos.logback.classic.Level;
import com.system.alba.common.AppConstants;
import com.system.alba.common.ProjectConstants;
import com.system.alba.common.LogOptionField;
import com.system.alba.common.Loggable;
import com.system.alba.common.security.SecurityUtils;
import com.system.alba.common.utils.EnvUtils;
import com.system.alba.model.ResponseModel;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.ClassUtils;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.lang.reflect.Field;
import java.lang.reflect.InaccessibleObjectException;
import java.lang.reflect.Modifier;
import java.util.*;

@Slf4j
@Aspect
@Component
@RequiredArgsConstructor
public class LoggingAspect {

    private final ObjectMapper objectMapper;

    private static final Set<Class<?>> ignoreClassTypes = new HashSet<>();
    static {
        ignoreClassTypes.add(MultipartFile.class);
        ignoreClassTypes.add(File.class);
    }

    @Around("@annotation(com.system.alba.common.Loggable)")
    public Object around(ProceedingJoinPoint joinPoint) throws Throwable {
        long startTime = System.currentTimeMillis();
        Object result = null;
        try {
            result = joinPoint.proceed();
            logMethodExecution(joinPoint, result, startTime, null);
        } catch (Throwable throwable) {
            logMethodExecution(joinPoint, null, startTime, throwable);
            throw throwable;
        }
        return result;
    }

    private void logMethodExecution(ProceedingJoinPoint joinPoint, Object result, long startTime, Throwable throwable) {
        try {
            long executionTime = System.currentTimeMillis() - startTime;
            List<String> messages = new ArrayList<>();
            MethodSignature methodSignature = (MethodSignature) joinPoint.getSignature();
            Loggable loggable = methodSignature.getMethod().getAnnotation(Loggable.class);
            int logLevel = loggable.logLevel();

            Set<AppConstants.LOGGABLE_TYPE> types = new HashSet<>(Arrays.asList(loggable.saveTypes()));
            boolean hasRequest = types.contains(AppConstants.LOGGABLE_TYPE.Request);
            boolean hasResponse = types.contains(AppConstants.LOGGABLE_TYPE.Response);

            ServletRequestAttributes requestAttributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            if (requestAttributes == null) {
                log.warn("RequestAttributes is null, skipping logging");
                return;
            }
            HttpServletRequest request = requestAttributes.getRequest();
            String url = request.getRequestURI();
            String httpMethod = request.getMethod();

            // header
            String[] headerNames = loggable.headerNames();
            if (headerNames.length > 0) {
                Map<String, Object> headerMap = new LinkedHashMap<>();
                for (String headerName: headerNames) {
                    String header = request.getHeader(headerName);
                    headerMap.put(headerName, header);
                }
                String message = String.format("Headers: %s", objectMapper.writeValueAsString(headerMap));
                messages.add(message);
            }

            // request
            if (hasRequest) {
                Object[] args = joinPoint.getArgs();
                String[] argNames = methodSignature.getParameterNames();
                Set<String> paramNames = new HashSet<>(Arrays.asList(loggable.paramNames()));
                Map<String, Object> paramMap = new LinkedHashMap<>();
                for (int i = 0; i < argNames.length && !loggable.skipParamYn(); i++) {
                    String name = argNames[i];
                    Object arg = args[i];
                    boolean logParamYn = paramNames.contains(name);
                    boolean emptyParamNames = paramNames.isEmpty();
                    if (!logParamYn && !emptyParamNames) continue;
                    paramMap.put(name, arg);
                }

                Map<String, Object> requestLogMap = new LinkedHashMap<>();
                for (String key: paramMap.keySet()) {
                    Object arg = paramMap.get(key);
                    Map<String, Object> map = getFieldMap(key, arg);
                    if (map != null) {
                        requestLogMap.put(key, map);
                    }
                }
                String message = String.format("Request: %s", objectMapper.writeValueAsString(requestLogMap));
                messages.add(message);
            }

            // response
            if (hasResponse) {
                if (result instanceof ResponseEntity<?> responseEntity) {
                    Object body = responseEntity.getBody();
                    if (body instanceof ResponseModel<?> responseModel) {
                        Object data = responseModel.getData();
                        Map<String, Object> responseMap = getFieldMap("data", data);
                        String message = String.format("Response: %s", objectMapper.writeValueAsString(responseMap));
                        messages.add(message);
                    }
                }
            }

            // user
            String userId = SecurityUtils.getLoginId();

            // ip
            boolean saveIpYn = loggable.saveIpYn();
            if (saveIpYn) {
                String clientIp = EnvUtils.getClientAddress();
                String message = String.format("Ip: %s", clientIp);
                messages.add(message);
            }
            if (throwable != null) {
                log(logLevel, "Url: {}, Method: {}, User: {}, ExecutionTime: {}ms, Error: {}, Log: {}",
                        url, httpMethod, userId, executionTime, throwable.getMessage(), messages);
            } else {
                log(logLevel, "Url: {}, Method: {}, User: {}, ExecutionTime: {}ms, Log: {}",
                        url, httpMethod, userId, executionTime, messages);
            }
        } catch (Exception ex) {
            log.error("LoggingAspect Error: {}", ex.getMessage(), ex);
        }
    }

    private Map<String, Object> getFieldMap(String collectionFiledName, Object arg) throws IllegalAccessException {
        if (arg != null) {
            Map<String, Object> map;
            if (arg instanceof Collection<?>) {
                map = new HashMap<>();
                for (Object obj : (Collection<?>) arg) {
                    boolean isPrimitiveOrWrapper = primitiveOrWrapperYn(obj.getClass());
                    if (isPrimitiveOrWrapper) {
                        map.put(collectionFiledName, obj);
                        break;
                    } else {
                        Map<String, Object> filteredArg = getFieldItemMap(obj);
                        map.putAll(filteredArg);
                    }
                }
            } else {
                map = getFieldItemMap(arg);
            }
            return map;
        }
        return null;
    }

    private Map<String, Object> getFieldItemMap(Object obj) throws IllegalAccessException {
        if (obj == null) {
            return null;
        }

        Map<String, Object> filteredMap = new HashMap<>();
        Class<?> clazz = obj.getClass();

        // 프로젝트 패키지가 아니면 toString()으로 처리
        if (!isProjectPackage(clazz)) {
            return Map.of("value", obj.toString());
        }

        boolean ignoreYn = checkIgnoreType(clazz);
        if (ignoreYn) return filteredMap;

        List<Field> allFields = getAllFields(clazz);

        // include가 명시된 필드가 있는지 확인
        boolean hasIncludeFields = allFields.stream()
                .anyMatch(field -> {
                    LogOptionField logOption = field.getAnnotation(LogOptionField.class);
                    return logOption != null && logOption.include();
                });

        for (Field field : allFields) {
            LogOptionField logOption = field.getAnnotation(LogOptionField.class);
            if (logOption != null) {
                boolean exclude = logOption.exclude();
                boolean include = logOption.include();

                if (exclude) {
                    continue;
                }

                // include가 명시된 필드가 있는 경우, include된 필드만 처리
                if (hasIncludeFields && !include) {
                    continue;
                }
            } else if (hasIncludeFields) {
                // 어노테이션이 없고 include 필드가 있으면 제외
                continue;
            }

            ignoreYn = checkIgnoreType(field.getType());
            if (ignoreYn) continue;

            if (Modifier.isStatic(field.getModifiers()) && Modifier.isFinal(field.getModifiers())) continue;
            boolean isPrimitiveOrWrapper = primitiveOrWrapperYn(field.getType());
            if (isPrimitiveOrWrapper) {
                try {
                    field.setAccessible(true);
                    filteredMap.put(field.getName(), field.get(obj));
                } catch (InaccessibleObjectException e) {
                    // 접근 불가한 필드는 무시
                }
            } else {
                try {
                    field.setAccessible(true);
                    Object fieldValue = field.get(obj);
                    if (fieldValue != null) {
                        if (fieldValue instanceof JsonNode jsonNode) {
                            // JsonNode 처리
                            try {
                                filteredMap.put(field.getName(), objectMapper.readTree(jsonNode.toString()));
                            } catch (Exception e) {
                                filteredMap.put(field.getName(), jsonNode.toString());
                            }
                        } else if (fieldValue.getClass().isEnum()) {
                            // Enum 처리
                            filteredMap.put(field.getName(), fieldValue.toString());
                        } else if (isProjectPackage(fieldValue.getClass())) {
                            // 프로젝트 패키지만 재귀 탐색
                            Object childFilteredMap = getFieldItemMap(fieldValue);
                            filteredMap.put(field.getName(), childFilteredMap);
                        } else {
                            // 프로젝트 패키지가 아니면 toString()
                            filteredMap.put(field.getName(), fieldValue.toString());
                        }
                    }
                } catch (InaccessibleObjectException e) {
                    // 접근 불가한 필드는 무시
                }
            }
        }

        return filteredMap;
    }

    private boolean isProjectPackage(Class<?> clazz) {
        String className = clazz.getName();
        for (String pkg : ProjectConstants.LOGGING_TARGET_PACKAGES) {
            if (className.startsWith(pkg)) {
                return true;
            }
        }
        return false;
    }

    private boolean checkIgnoreType(Class<?> type) {
        return ignoreClassTypes.stream().anyMatch(ignoreClass -> ignoreClass.isAssignableFrom(type));
    }

    private boolean primitiveOrWrapperYn(Class<?> type) {
        return ClassUtils.isPrimitiveOrWrapper(type) || type == String.class;
    }

    private void log(int logLevel, String format, Object... arguments) {
        if (logLevel == Level.ERROR_INT) log.error(format, arguments);
        if (logLevel == Level.WARN_INT) log.warn(format, arguments);
        if (logLevel == Level.INFO_INT) log.info(format, arguments);
        if (logLevel == Level.DEBUG_INT) log.debug(format, arguments);
        if (logLevel == Level.TRACE_INT) log.trace(format, arguments);
    }

    private List<Field> getAllFields(Class<?> clazz) {
        List<Field> allFields = new ArrayList<>();
        Class<?> currentClass = clazz;

        while (currentClass != null && !currentClass.equals(Object.class)) {
            Field[] fields = currentClass.getDeclaredFields();
            allFields.addAll(Arrays.asList(fields));
            currentClass = currentClass.getSuperclass();
        }

        return allFields;
    }

}
