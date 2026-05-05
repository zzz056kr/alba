package com.system.alba.config;

import com.system.alba.common.AppConstants;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;

@Configuration
public class ApplicationConfig {

    @Bean
    public MessageSourceAccessor messageSourceAccessor() {
        ReloadableResourceBundleMessageSource messageSource = new ReloadableResourceBundleMessageSource();
        messageSource.setBasenames("classpath:messages/messages", "classpath:messages/websocket-messages");
        messageSource.setDefaultEncoding(AppConstants.ENCODING);
        return new MessageSourceAccessor(messageSource);
    }

}
