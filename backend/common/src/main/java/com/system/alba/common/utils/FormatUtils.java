package com.system.alba.common.utils;

import org.apache.commons.lang3.exception.ExceptionUtils;

public class FormatUtils {

    public static String logString(String service, String category, String message, Throwable ex) {
        String stackTrace = ExceptionUtils.getStackTrace(ex);
        String log = String.format("[%s][%s] %s - %s", service, category, message, stackTrace);
        return log;
    }

    public static String logString(String service, String category, String message) {
        String log = String.format("[%s][%s] %s", service, category, message);
        return log;
    }

}
