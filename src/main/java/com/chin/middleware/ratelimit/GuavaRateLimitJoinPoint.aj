package com.chin.middleware.ratelimit;

import com.chin.middleware.ratelimit.annotation.GuavaRateLimit;
import com.google.common.util.concurrent.RateLimiter;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.reflect.MethodSignature;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.lang.reflect.Method;
import java.util.concurrent.ConcurrentHashMap;

/**
 * @author qi
 */
@Aspect
public class GuavaRateLimitJoinPoint {

    ConcurrentHashMap<String, RateLimiter> rateLimiterConcurrentHashMap = new ConcurrentHashMap<>();

    Logger logger = LoggerFactory.getLogger(GuavaRateLimitJoinPoint.class);

    @Pointcut("@annotation(com.chin.middleware.ratelimit.annotation.GuavaRateLimit)")
    public void methodPointCut() {}

    @Around("methodPointCut()")
    public Object doRateLimit(ProceedingJoinPoint proceedingJoinPoint){
        MethodSignature methodSignature = (MethodSignature)proceedingJoinPoint.getSignature();
        Method method = methodSignature.getMethod();
        GuavaRateLimit guavaExecuteRateLimiter = method.getAnnotation(GuavaRateLimit.class);
        GuavaRateLimitProperties guavaRateLimiterParam = GuavaRateLimitProperties.builder().
                permitsPerSecond(guavaExecuteRateLimiter.permitsPerSecond()).
                timeUnit(guavaExecuteRateLimiter.timeUnit()).
                warmupPeriod(guavaExecuteRateLimiter.warmupPeriod()).limitKey(guavaExecuteRateLimiter.limitKey()).build();
        String key = guavaRateLimiterParam.getLimitKey();
        RateLimiter rateLimiter = rateLimiterConcurrentHashMap.
                computeIfAbsent(key,param-> RateLimiter.create(guavaRateLimiterParam.getPermitsPerSecond(), guavaRateLimiterParam.getWarmupPeriod(), guavaRateLimiterParam.getTimeUnit()));
        try {
            double rateValue = rateLimiter.acquire();
            logger.info("执行限流方法操作处理:当前qps:{} delay rate limiter value:{}",guavaExecuteRateLimiter.permitsPerSecond(),rateValue);
            return proceedingJoinPoint.proceed(proceedingJoinPoint.getArgs());
        } catch (Throwable e) {
            logger.error("执行限流控制方法失败！",e);
            return null;
        }
    }
}
