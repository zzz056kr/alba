package com.system.alba.oauth2.model.dto.oauth;

import com.system.alba.common.AppType;

import java.util.Map;

public class GoogleUserInfo implements OAuth2UserInfo {

    private final Map<String, Object> attributes;

    public GoogleUserInfo(Map<String, Object> attributes) {
        this.attributes = attributes;
    }

    @Override
    public Map<String, Object> getAttributes() {
        return attributes;
    }

    @Override
    public AppType.AuthProvider getProvider() {
        return AppType.AuthProvider.GOOGLE;
    }

    @Override
    public String getProviderId() {
        return (String) attributes.get("sub");
    }

    @Override
    public String getName() {
        return (String) attributes.get("name");
    }

    @Override
    public String getEmail() {
        return (String) attributes.get("email");
    }
}