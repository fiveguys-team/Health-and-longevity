//package com.example.livecommerce_server.common.config;
//
//
//import org.springframework.beans.factory.annotation.Qualifier;
//import org.springframework.beans.factory.annotation.Value;
//import org.springframework.context.annotation.Bean;
//import org.springframework.context.annotation.Configuration;
//import org.springframework.data.redis.connection.RedisConnectionFactory;
//import org.springframework.data.redis.connection.RedisStandaloneConfiguration;
//import org.springframework.data.redis.connection.lettuce.LettuceConnectionFactory;
//
//@Configuration
//public class RedisConfig {
//
//    @Value("${spring.redis.host}")
//    private String host;
//    @Value("${spring.redis.port}")
//    private int port;
//
//    //    연결기본객체
//    @Bean
//    @Qualifier("chatPubSub")
//    public RedisConnectionFactory chatPubSubFactory(){
//        RedisStandaloneConfiguration configuration = new RedisStandaloneConfiguration();
//        configuration.setHostName(host);
//        configuration.setPort(port);
////        redis pub/sub에서는 특정 데이터베이스에 의존적이지 않음.
////        configuration.setDatabase(0);
//        return new LettuceConnectionFactory(configuration);
//    }
//
//    // p
//}
