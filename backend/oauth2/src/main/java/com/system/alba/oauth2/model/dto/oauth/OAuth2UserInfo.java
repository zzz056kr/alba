package com.system.alba.oauth2.model.dto.oauth;

import com.system.alba.common.AppType;

import java.util.Map;

public interface OAuth2UserInfo {
    Map<String, Object> getAttributes();
    AppType.AuthProvider getProvider();
    String getProviderId();
    String getName();
    String getEmail();
}