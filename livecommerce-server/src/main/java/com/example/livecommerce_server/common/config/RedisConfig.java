package com.example.livecommerce_server.common.config;


import com.example.livecommerce_server.chat.service.ChatSubscriber;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.connection.lettuce.LettuceConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.listener.PatternTopic;
import org.springframework.data.redis.listener.RedisMessageListenerContainer;
import org.springframework.data.redis.serializer.GenericJackson2JsonRedisSerializer;
import org.springframework.data.redis.serializer.StringRedisSerializer;

/**
 * Redis 설정 클래스 (Step 2: JSON 직렬화 + Pub/Sub 지원)
 *
 * 채팅 시스템에서 사용할 Redis 설정을 관리합니다:
 * 1. 기본 문자열 저장/조회 (StringRedisTemplate)
 * 2. 객체 JSON 직렬화 저장 (RedisTemplate with Jackson)
 * 3. Pub/Sub 메시지 리스너 컨테이너
 */
@Slf4j
@Configuration
public class RedisConfig {

    /**
     * 기본 StringRedisTemplate
     * 간단한 문자열 저장/조회용
     */
    @Bean
    public StringRedisTemplate stringRedisTemplate(RedisConnectionFactory connectionFactory) {
        StringRedisTemplate template = new StringRedisTemplate(connectionFactory);
        log.info(" StringRedisTemplate 빈 생성 완료");
        return template;
    }

    /**
     * 기본 RedisTemplate
     * 일단 간단하게 Object 저장용
     */
//    @Bean
//    public RedisTemplate<String, Object> redisTemplate(RedisConnectionFactory connectionFactory) {
//        RedisTemplate<String, Object> template = new RedisTemplate<>();
//        template.setConnectionFactory(connectionFactory);
//        log.info("RedisTemplate 빈 생성 완료");
//        return template;
//    }

    /**
     * AI 추천 결과(객체) 저장용 RedisTemplate
     * 핵심: Serializer 설정을 추가하여 객체를 JSON으로 저장합니다.
     */
    @Bean
    public RedisTemplate<String, Object> redisTemplate(RedisConnectionFactory connectionFactory) {
        RedisTemplate<String, Object> template = new RedisTemplate<>();
        template.setConnectionFactory(connectionFactory);

        // Key는 일반 문자열, Value는 JSON으로 직렬화
        template.setKeySerializer(new StringRedisSerializer());
        template.setValueSerializer(new GenericJackson2JsonRedisSerializer());

        log.info("✅ AI 추천용 RedisTemplate 설정 완료 (JSON Serializer 적용)");
        return template;
    }

    /**
     * Redis Pub/Sub을 위한 메시지 리스너 컨테이너
     * 이게 뭔가요?
     * - Redis 채널에서 오는 메시지를 "듣는" 역할
     * - 아직 어떤 채널을 들을지는 설정 안함 (다음 단계에서 할 예정)
     * 지금 단계에서는:
     * - 컨테이너만 만들어두기
     * - 실제 구독은 나중에 설정
     */
    @Bean
    public RedisMessageListenerContainer redisMessageListenerContainer(
            RedisConnectionFactory connectionFactory) {

        RedisMessageListenerContainer container = new RedisMessageListenerContainer();
        container.setConnectionFactory(connectionFactory);

        log.info("RedisMessageListenerContainer 빈 생성 완료");
        log.info("   Pub/Sub 메시지 수신 준비 완료");
        log.info("   아직 구체적인 채널 구독은 설정 안함 (다음 단계에서 진행)");

        return container;
    }

    /**
     * 🆕Redis 채널 구독이 설정된 컨테이너 (Phase 2-3: 실제 구독 연결)
     *
     * 이 메소드가 핵심입니다!
     *
     * 역할:
     * 1. RedisMessageListenerContainer 생성
     * 2. ChatSubscriber와 "chat:room:*" 패턴 연결
     * 3. 메시지가 오면 ChatSubscriber.onMessage() 자동 호출
     *
     * 동작 방식:
     * - 다른 서버에서 "chat:room:123"에 메시지 발행
     * - 이 서버의 ChatSubscriber가 자동으로 메시지 수신
     * - ChatSubscriber가 WebSocket으로 클라이언트들에게 전송
     */
    @Bean
    public RedisMessageListenerContainer redisMessageListenerContainerWithSubscription(
            RedisConnectionFactory connectionFactory,
            ChatSubscriber subscriber) {

        RedisMessageListenerContainer container = new RedisMessageListenerContainer();
        container.setConnectionFactory(connectionFactory);

        // 패턴 토픽 생성: "chat:room:*"
        // 의미: "chat:room:" 뒤에 뭐가 와도 다 구독
        // 예시: chat:room:123 , chat:room:456
        PatternTopic chatPattern = new PatternTopic("chat:room:*");

        // 컨테이너에 리스너 등록
        // (누가 처리할까?, 어떤 채널을 들을까?)
        container.addMessageListener(subscriber, chatPattern);

        log.info("✅ Redis 채널 구독 설정 완료");
        log.info("   📌 구독 패턴: chat:room:*");
        log.info("   📌 구독자: ChatSubscriber");
        log.info("   📌 이제 다른 서버에서 메시지 발행하면 자동으로 수신됩니다!");

        return container;
    }

    /**
     * 리프레시 토큰 전용 RedisTemplate (DB 1번 사용)
     */
    @Bean
    @Qualifier("refreshTokenRedisTemplate")
    public StringRedisTemplate refreshTokenRedisTemplate(RedisConnectionFactory connectionFactory) {
        StringRedisTemplate template = new StringRedisTemplate();
        template.setConnectionFactory(connectionFactory);

        // 중요: DB 번호 설정 (기본 0번과 다른 1번 사용)
        template.setKeySerializer(new StringRedisSerializer());
        template.setValueSerializer(new StringRedisSerializer());
        template.setConnectionFactory(connectionFactoryWithDb1(connectionFactory));

        log.info("🔑 리프레시 토큰용 RedisTemplate 빈 생성 완료 (DB: 1)");
        return template;
    }


    /**
     * DB 번호가 1인 Redis 연결 팩토리 생성
     */
    private RedisConnectionFactory connectionFactoryWithDb1(RedisConnectionFactory originalFactory) {
        // 원본 팩토리에서 새로운 구성 생성
        LettuceConnectionFactory lettuceFactory = (LettuceConnectionFactory) originalFactory;
        LettuceConnectionFactory newFactory = new LettuceConnectionFactory(
                lettuceFactory.getStandaloneConfiguration());
        newFactory.setDatabase(1); // 핵심: DB 번호 1로 설정
        newFactory.afterPropertiesSet();
        return newFactory;
    }
}
