package com.system.alba.service.common;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.NoSuchMessageException;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
@Service
@RequiredArgsConstructor
public class MessageService {

    private final MessageSourceAccessor messageSourceAccessor;
    private final Map<String, String> messageCache = new ConcurrentHashMap<>();

    public String getMessage(String messageCode, Object[] args) {
        if (args == null || args.length == 0) {
            return messageCache.computeIfAbsent(messageCode, this::getMessageFromSource);
        }
        return getMessageFromSource(messageCode, args);
    }

    public String getMessage(String messageCode) {
        return getMessage(messageCode, null);
    }

    private String getMessageFromSource(String messageCode) {
        return getMessageFromSource(messageCode, null);
    }

    private String getMessageFromSource(String messageCode, Object[] args) {
        try {
            return messageSourceAccessor.getMessage(messageCode, args);
        } catch (NoSuchMessageException ex) {
            log.warn("Message not found for code: {}", messageCode);
            return messageCode;
        }
    }
}