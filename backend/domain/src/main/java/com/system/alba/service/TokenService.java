package com.system.alba.service;

import com.system.alba.common.AppType;
import com.system.alba.config.AppCodeProperties;
import com.system.alba.config.security.TokenProvider;
import com.system.alba.model.domain.Account;
import com.system.alba.model.domain.Token;
import com.system.alba.model.dto.TokenDto;
import com.system.alba.repository.TokenRepository;
import com.system.alba.service.cache.TokenCacheService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(rollbackFor = Exception.class, propagation = Propagation.REQUIRED)
public class TokenService {
    private final TokenProvider tokenProvider;
    private final TokenRepository tokenRepository;
    private final TokenCacheService tokenCacheService;
    private final AppCodeProperties appCodeProperties;

    /**
     * 다중 로그인 설정을 확인하고 토큰 생성
     * - 다중 로그인 비허용 시 기존 토큰 무효화
     */
    public TokenDto.Detail createTokenWithMultiLoginCheck(Account account) {
        // 다중 로그인 허용 여부 확인
        boolean allowMultiLogin = appCodeProperties.getAuth().isMultiLogin();
        if (!allowMultiLogin) {
            revokeExistingTokens(account.getId());
        }

        Token token = tokenProvider.createToken(account);
        token = tokenRepository.save(token);

        // 토큰 캐시 저장
        tokenCacheService.put(token);

        return TokenDto.Detail.Mapper.INSTANCE.sourceToDestination(token);
    }

    /**
     * 토큰 생성 및 캐시 저장 (다중 로그인 체크 없음)
     */
    public TokenDto.Detail createToken(Account account) {
        Token token = tokenProvider.createToken(account);
        token = tokenRepository.save(token);

        tokenCacheService.put(token);

        return TokenDto.Detail.Mapper.INSTANCE.sourceToDestination(token);
    }

    /**
     * 특정 계정의 모든 유효한 토큰 무효화
     */
    public void revokeExistingTokens(String accountId) {
        List<Token> existingTokens = tokenRepository.findByAccount_Id(accountId);
        for (Token token : existingTokens) {
            if (token.isValid()) {
                tokenCacheService.evict(token.getAccessToken());
                token.revoke(AppType.TokenRevokeReason.NEW_LOGIN);
            }
        }
        tokenRepository.saveAll(existingTokens);
    }
}