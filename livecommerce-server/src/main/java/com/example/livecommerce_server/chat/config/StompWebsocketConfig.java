package com.example.livecommerce_server.chat.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.ChannelRegistration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
@EnableWebSocketMessageBroker
public class StompWebsocketConfig implements WebSocketMessageBrokerConfigurer {


//    private final StompHandler stompHandler;
//
//
//    public StompHandler(StompHandler stompHandler) {
//        this.stompHandler = stompHandler;
//    }

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/connect")
                .setAllowedOriginPatterns("*")  //
                .withSockJS();
    }

    @Override
    public void configureMessageBroker(MessageBrokerRegistry registry) {
        //        /publish/1형태로 메시지 발행해야 함을 설정
        //            /publish로 시작하는 url패턴으로 메시지가 발행되면 @Controller 객체의 @MessaMapping메서드로 라우팅
        registry.setApplicationDestinationPrefixes("/publish");

        //        /topic/1형태로 메시지를 수신(subscribe)해야 함을 설정
        // /topic/1형태로 메시지를 수신(subscribe)해야 함을 설정
        // /user 경로 추가!! 이 부분이 누락되어 있었습니다
        registry.enableSimpleBroker("/topic", "/user");

        // 사용자별 메시지를 위한 설정 추가!!
        registry.setUserDestinationPrefix("/user");
    }

    @Override
    public void configureClientInboundChannel(ChannelRegistration registration) {

    }

}




