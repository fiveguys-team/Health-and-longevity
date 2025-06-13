// src/modules/chat/services/websocket.service.js

import SockJS from "sockjs-client";
import { Stomp } from "@stomp/stompjs";

class WebSocketService {
  constructor() {
    this.stompClient = null;
    this.connected = false;
    // 로그인 미구현 상태라 임시로 userId = 1 고정
    this.userId = 1;
  }

  /**
   * 1. WebSocket 서버와 연결
   * 2. 일반 채팅 메시지 구독 → /topic/{roomId}
   * 3. 경고 메시지 구독 → /user/queue/warning
   *
   * @param {number} roomId 채팅방 ID
   * @param {Function} messageCallback 정상 메시지 처리 콜백
   * @param {Function} warningCallback 경고 메시지 처리 콜백
   */
  connect(roomId, messageCallback, warningCallback) {
    const socket = new SockJS("http://localhost:8080/connect");
    this.stompClient = Stomp.over(socket);

    this.stompClient.connect(
      {}, // 헤더가 필요하면 여기에 추가
      () => {
        this.connected = true;
        console.log("WebSocket 연결 성공! → roomId:", roomId);

        // 2. 일반 메시지 구독
        this.stompClient.subscribe(`/topic/${roomId}`, (msg) => {
          const received = JSON.parse(msg.body);
          console.log("받은 메시지:", received);
          messageCallback(received);
        });

        // 3. 경고 메시지 구독
        this.stompClient.subscribe("/user/1/queue/warning", (msg) => {
          const warning = JSON.parse(msg.body);
          console.log("받은 경고 메시지:", warning);
          if (warningCallback) warningCallback(warning);
        });
      },
      (error) => {
        console.error("WebSocket 연결 실패 →", error);
        this.connected = false;
      }
    );
  }

  /**
   * WebSocket 연결 해제
   */
  disconnect() {
    if (this.stompClient) {
      this.stompClient.disconnect();
      this.connected = false;
      console.log("WebSocket 연결 해제");
    }
  }

  /**
   * 채팅 메시지 서버로 전송
   *
   * @param {number} roomId 채팅방 ID
   * @param {string} message 보낼 메시지 내용
   */
  sendMessage(roomId, message) {
    if (!this.connected || !this.stompClient) {
      console.error("WebSocket이 연결되지 않았습니다.");
      return;
    }

    const chatMessage = {
      content: message, // DTO content 필드
      userId: this.userId, // 임시 고정값
      userName: "테스트사용자", // 필요시 변경
    };

    // /publish/chat/send/{roomId} 경로로 전송
    this.stompClient.send(
      `/publish/chat/send/${roomId}`,
      {}, // 헤더
      JSON.stringify(chatMessage)
    );
    console.log("메시지 전송 →", chatMessage);
  }
}

// 인스턴스 내 userId는 1로 고정
export const websocketService = new WebSocketService();
