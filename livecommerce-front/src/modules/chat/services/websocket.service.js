// src/modules/chat/services/websocket.service.js
import SockJS from "sockjs-client";
import { Stomp } from "@stomp/stompjs";
import { useAuthStore } from "@/modules/auth/stores/auth"; // auth store import 추가

class WebSocketService {
  constructor() {
    this.stompClient = null;
    this.connected = false;
    this.currentUserId = null; // 현재 연결된 사용자 ID 추적
    this.subscriptions = []; // 구독 정보 저장
  }

  /**
   * 현재 로그인된 사용자 정보 가져오기
   */
  getUserInfo() {
    const authStore = useAuthStore();
    return {
      userId: authStore.id,
      userName: authStore.name,
      token: authStore.token,
    };
  }

  /**
   * 1. WebSocket 서버와 연결
   * 2. 일반 채팅 메시지 구독 → /topic/{roomId}
   * 3. 경고 메시지 구독 → /user/{userId}/queue/warning
   *
   * @param {number} roomId 채팅방 ID
   * @param {Function} messageCallback 정상 메시지 처리 콜백
   * @param {Function} warningCallback 경고 메시지 처리 콜백
   */
  connect(roomId, messageCallback, warningCallback) {
    // 로그인 상태 확인
    const userInfo = this.getUserInfo();
    if (!userInfo.userId) {
      console.error("로그인되지 않은 사용자입니다.");
      return;
    }

    // 이미 같은 사용자로 연결되어 있으면 스킵
    if (this.connected && this.currentUserId === userInfo.userId) {
      console.log("이미 연결되어 있습니다.");
      return;
    }

    const socket = new SockJS("http://localhost:8080/connect");
    this.stompClient = Stomp.over(socket);

    // 인증 헤더 설정
    const headers = {
      Authorization: userInfo.token ? `Bearer ${userInfo.token}` : "",
      userId: userInfo.userId.toString(),
    };

    this.stompClient.connect(
      headers,
      () => {
        this.connected = true;
        this.currentUserId = userInfo.userId;
        console.log(
          "WebSocket 연결 성공! → roomId:",
          roomId,
          "userId:",
          userInfo.userId
        );

        // 일반 메시지 구독
        const topicSub = this.stompClient.subscribe(
          `/topic/${roomId}`,
          (msg) => {
            const received = JSON.parse(msg.body);
            console.log("받은 메시지:", received);
            messageCallback(received);
          }
        );

        // 경고 메시지 구독 - 실제 userId 사용
        const warningSub = this.stompClient.subscribe(
          `/user/${userInfo.userId}/queue/warning`,
          (msg) => {
            const warning = JSON.parse(msg.body);
            console.log("받은 경고 메시지:", warning);
            if (warningCallback) warningCallback(warning);
          }
        );

        // 구독 정보 저장
        this.subscriptions = [topicSub, warningSub];

        // 연결 끊김 감지 (선택사항)
        this.stompClient.ws.onclose = () => {
          console.log("WebSocket 연결이 끊어졌습니다.");
          this.connected = false;
        };
      },
      (error) => {
        console.error("WebSocket 연결 실패 →", error);
        this.connected = false;
        this.currentUserId = null;
      }
    );
  }

  /**
   * WebSocket 연결 해제
   */
  disconnect() {
    // 모든 구독 해제
    this.subscriptions.forEach((sub) => {
      if (sub && sub.unsubscribe) {
        sub.unsubscribe();
      }
    });
    this.subscriptions = [];

    // WebSocket 연결 해제
    if (this.stompClient) {
      this.stompClient.disconnect(() => {
        console.log("WebSocket 연결 해제");
      });
      this.connected = false;
      this.currentUserId = null;
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

    // 현재 로그인된 사용자 정보 가져오기
    const userInfo = this.getUserInfo();

    if (!userInfo.userId) {
      console.error("로그인 정보를 찾을 수 없습니다.");
      return;
    }

    const chatMessage = {
      content: message,
      userId: userInfo.userId,
      userName: userInfo.userName || `사용자${userInfo.userId}`, // 이름이 없으면 기본값
      roomId: roomId,
    };

    // /publish/chat/send/{roomId} 경로로 전송
    this.stompClient.send(
      `/publish/chat/send/${roomId}`,
      {}, // 추가 헤더 (연결 시 인증으로 충분)
      JSON.stringify(chatMessage)
    );

    console.log("메시지 전송 →", chatMessage);
  }
}

// 싱글톤 인스턴스
export const websocketService = new WebSocketService();
