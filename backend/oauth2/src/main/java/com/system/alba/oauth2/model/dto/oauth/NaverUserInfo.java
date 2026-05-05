package com.system.alba.oauth2.model.dto.oauth;

import com.system.alba.common.AppType;

import java.util.Map;

public class NaverUserInfo implements OAuth2UserInfo {

    private final Map<String, Object> attributes;

    @SuppressWarnings("unchecked")
    public NaverUserInfo(Map<String, Object> attributes) {
        this.attributes = (Map<String, Object>) attributes.get("response");
    }

    @Override
    public Map<String, Object> getAttributes() {
        return attributes;
    }

    @Override
    public AppType.AuthProvider getProvider() {
        return AppType.AuthProvider.NAVER;
    }

    @Override
    public String getProviderId() {
        return (String) attributes.get("id");
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