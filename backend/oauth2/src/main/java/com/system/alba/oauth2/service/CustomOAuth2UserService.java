package com.system.alba.oauth2.service;

import com.system.alba.common.AppType;
import com.system.alba.config.security.CustomUserDetails;
import com.system.alba.model.domain.Account;
import com.system.alba.oauth2.model.dto.oauth.OAuth2UserInfo;
import com.system.alba.oauth2.model.dto.oauth.OAuth2UserInfoFactory;
import com.system.alba.repository.AccountRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class CustomOAuth2UserService extends DefaultOAuth2UserService {
    private final AccountRepository accountRepository;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        OAuth2User oAuth2User = super.loadUser(userRequest);

        String registrationId = userRequest.getClientRegistration().getRegistrationId();
        AppType.AuthProvider authProvider = AppType.AuthProvider.fromRegistrationId(registrationId);

        OAuth2UserInfo userInfo = OAuth2UserInfoFactory.getOAuth2UserInfo(authProvider, oAuth2User.getAttributes());

        // providerId가 아닌 id와 provider로 사용자를 조회합니다.
        Optional<Account> accountOptional = accountRepository.findByIdAndProvider(userInfo.getProviderId(), authProvider);

        // 새로운 SSO 사용자를 등록합니다.
        Account account = accountOptional.orElseGet(() -> registerNewUser(userInfo, authProvider));

        return new CustomUserDetails(account, oAuth2User.getAttributes());
    }

    private Account registerNewUser(OAuth2UserInfo userInfo, AppType.AuthProvider authProvider) {
        Account newAccount = new Account();
        newAccount.setId(userInfo.getProviderId());
        newAccount.setName(userInfo.getName());
        newAccount.setEmail(userInfo.getEmail());
        newAccount.setRoles(List.of(AppType.AccountRole.USER));
        newAccount.setProvider(authProvider);
        newAccount.setStatus(AppType.Status.ACTIVE);
        return accountRepository.save(newAccount);
    }
}