package com.system.alba.common;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
public @interface LogOptionField {
    // exclude = true인 경우 해당 필드는 로그에 포함되지 않음
    boolean exclude() default false;

    // 클래스에 include = true인 필드가 하나라도 있으면, include된 필드들만 로그에 포함됨
    boolean include() default false;
}

