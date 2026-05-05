package com.system.alba.common;

import ch.qos.logback.classic.Level;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;


@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface Loggable {
    AppConstants.LOGGABLE_TYPE[] saveTypes() default {AppConstants.LOGGABLE_TYPE.Request, AppConstants.LOGGABLE_TYPE.Response};
    int logLevel() default Level.INFO_INT;
    boolean skipParamYn() default false;
    String[] paramNames() default {};
    String[] headerNames() default {};
    boolean saveIpYn() default true;
}
