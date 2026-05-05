package com.system.alba.common;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;

@Component
public class ApplicationContextHolder implements ApplicationContextAware {

    private static ApplicationContext context;

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        context = applicationContext;
    }

    public static <T> T getBean(Class<T> clazz) {
        return context != null ? context.getBean(clazz) : null;
    }

    public static <T> T getBean(String name, Class<T> clazz) {
        return context != null ? context.getBean(name, clazz) : null;
    }

    public static ApplicationContext getContext() {
        return context;
    }
}