package com.system.alba.config.security;

import com.system.alba.config.AppProperties;
import com.system.alba.model.domain.Account;
import com.system.alba.model.domain.Token;
import com.system.alba.model.dto.TokenDto;
import com.system.alba.repository.TokenRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.UUID;

@Component
@RequiredArgsConstructor
public class TokenProvider {
    private final AppProperties appProperties;
    private final TokenRepository tokenRepository;

    public Token createToken(Account account) {
        String newAccessToken = UUID.randomUUID().toString();
        String newRefreshToken = UUID.randomUUID().toString();

        Token token = new Token();
        token.setAccount(account);
        token.setAccessToken(newAccessToken);
        token.setRefreshToken(newRefreshToken);
        token.setRoles(account.getRoles());
        LocalDateTime now = LocalDateTime.now();
        token.setAccessExpiresAt(now.plusSeconds(appProperties.getAuth().getAccessExpiresSeconds()));
        token.setRefreshExpiresAt(now.plusSeconds(appProperties.getAuth().getRefreshExpiresSeconds()));
        token.setRevokedYn(false);
        return token;
    }

    @Transactional
    public TokenDto.Detail createTokenDto(Account account) {
        Token token = createToken(account);
        token = tokenRepository.save(token);
        TokenDto.Detail data = TokenDto.Detail.Mapper.INSTANCE.sourceToDestination(token);
        return data;
    }

}