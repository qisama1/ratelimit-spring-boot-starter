package com.chin.middleware.ratelimit.config;

import com.chin.middleware.ratelimit.GuavaRateLimitJoinPoint;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * @author qi
 */
@Configuration
public class GuavaRateLimitAutoConfig {

    @Bean(name = "ratelimit-point")
    @ConditionalOnMissingBean
    public GuavaRateLimitJoinPoint guavaRateLimitJoinPoint() {
        return new GuavaRateLimitJoinPoint();
    }

}
