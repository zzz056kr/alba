package com.system.alba.oauth2.model.dto.oauth;

import com.system.alba.common.AppType;

import java.util.Map;

public class KakaoUserInfo implements OAuth2UserInfo {

    private final Map<String, Object> attributes;
    private final Map<String, Object> kakaoAccount;
    private final Map<String, Object> profile;

    @SuppressWarnings("unchecked")
    public KakaoUserInfo(Map<String, Object> attributes) {
        this.attributes = attributes;
        this.kakaoAccount = (Map<String, Object>) attributes.get("kakao_account");
        // kakao_account가 없는 경우 NPE 방지
        this.profile = kakaoAccount != null ? (Map<String, Object>) kakaoAccount.get("profile") : null;
    }

    @Override
    public Map<String, Object> getAttributes() {
        return attributes;
    }

    @Override
    public AppType.AuthProvider getProvider() {
        return AppType.AuthProvider.KAKAO;
    }

    @Override
    public String getProviderId() {
        return String.valueOf(attributes.get("id"));
    }

    @Override
    public String getName() {
        return profile == null ? null : (String) profile.get("nickname");
    }

    @Override
    public String getEmail() {
        return kakaoAccount == null ? null : (String) kakaoAccount.get("email");
    }
}