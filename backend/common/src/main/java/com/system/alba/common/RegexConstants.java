package com.system.alba.common;

public final class RegexConstants {
    public static final String CODE = "^[0-9a-zA-Z_-]{2,100}$";
    public static final String ACCOUNT_ID = "^[0-9a-zA-Z_-]{4,20}$";
    public static final String ACCOUNT_PASSWORD = "^[0-9a-zA-Z_\\-@#$%^&+=!*]{8,20}$";
}
