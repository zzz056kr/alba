package com.system.alba.common;

import java.nio.charset.StandardCharsets;

public class AppConstants {

    public static final String ENCODING = StandardCharsets.UTF_8.name();

    public static final String ROLE_PREFIX = "ROLE_";
    public static final String BEARER_PREFIX = "Bearer ";

    // OAuth2 파라미터
    public static final String PARAM_REDIRECT_URL = "redirect_url";
    public static final String PARAM_STATE = "state";

    public enum LOGGABLE_TYPE {
        Request,
        Response
    }

}
