package com.chin.middleware.ratelimit.annotation;

import java.lang.annotation.*;
import java.util.concurrent.TimeUnit;

/**
 * @author qi
 */
@Documented
@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.TYPE, ElementType.METHOD})
public @interface GuavaRateLimit {

    /**
     * 指定用的RateLimit的Key
     */
    String limitKey() default "default";

    /**
     * 返回的RateLimiter的速率，意味着每秒有多少个许可变成有效。
     */
    int permitsPerSecond() default 500;

    /**
     * 在这段时间内RateLimiter会增加它的速率，在抵达它的稳定速率或者最大速率之前
     */
    int warmupPeriod() default 5;

    /**
     * 参数warmupPeriod 的时间单位
     */
    TimeUnit timeUnit() default TimeUnit.SECONDS;


}
