package com.system.alba.service.cache;

import com.system.alba.cache.CacheConstants;
import com.system.alba.model.cache.ClientTokenCacheData;
import com.system.alba.model.domain.Token;
import com.system.alba.repository.TokenRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.Cache;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class TokenCacheService {

    private final CacheManager cacheManager;
    private final TokenRepository tokenRepository;

    // 토큰 캐시 조회 (캐시 미스 시 DB 조회 후 캐시 저장)
    @Cacheable(value = CacheConstants.TOKEN_CACHE, key = "#p0", unless = "#result == null")
    public ClientTokenCacheData getToken(String accessToken) {
        log.debug("Token cache miss, loading from DB: {}", accessToken.substring(0, 8) + "...");

        Token token = tokenRepository.findByAccessToken(accessToken).orElse(null);
        if (token == null) {
            return null;
        }

        return ClientTokenCacheData.from(token);
    }

    // 토큰 캐시 저장
    public void put(String accessToken, ClientTokenCacheData cacheData) {
        try {
            Cache cache = cacheManager.getCache(CacheConstants.TOKEN_CACHE);
            if (cache != null) {
                cache.put(accessToken, cacheData);
                log.debug("Token cached: {}", accessToken.substring(0, 8) + "...");
            }
        } catch (Exception e) {
            log.warn("Failed to cache token: {}", e.getMessage());
        }
    }

    // Token 엔티티로 캐시 저장
    public void put(Token token) {
        ClientTokenCacheData cacheData = ClientTokenCacheData.from(token);
        put(token.getAccessToken(), cacheData);
    }

    // 토큰 캐시 삭제
    @CacheEvict(value = CacheConstants.TOKEN_CACHE, key = "#p0")
    public void evict(String accessToken) {
        log.debug("Token cache evicted: {}", accessToken.substring(0, 8) + "...");
    }

    // 계정의 모든 토큰 캐시 삭제 (계정 정보 변경 시 호출)
    public void evictByAccountNo(Long accountNo) {
        List<Token> tokens = tokenRepository.findByAccount_No(accountNo);
        Cache cache = cacheManager.getCache(CacheConstants.TOKEN_CACHE);

        if (cache != null) {
            for (Token token : tokens) {
                cache.evict(token.getAccessToken());
            }
            log.debug("Token cache evicted for accountNo: {}, count: {}", accountNo, tokens.size());
        }
    }
}
