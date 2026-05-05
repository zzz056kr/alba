package com.system.alba.oauth2.model.dto.oauth;

import com.system.alba.common.AppType;

import java.util.Map;

public class OAuth2UserInfoFactory {
    public static OAuth2UserInfo getOAuth2UserInfo(AppType.AuthProvider authProvider, Map<String, Object> attributes) {
        switch (authProvider) {
            case GOOGLE:
                return new GoogleUserInfo(attributes);
            case NAVER:
                return new NaverUserInfo(attributes);
            case KAKAO:
                return new KakaoUserInfo(attributes);
            default:
                throw new IllegalArgumentException("Invalid Provider Type.");
        }
    }
}