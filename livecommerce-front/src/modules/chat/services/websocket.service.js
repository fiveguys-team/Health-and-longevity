import SockJS from "sockjs-client";
import { Stomp } from "@stomp/stompjs";

class WebSocketService {
  constructor() {
    this.stompClient = null;
    this.connected = false;
  }

  connect(roomId, messageCallback) {
    // 서버 설정의 엔드포인트에 맞춤
    const socket = new SockJS("http://localhost:8080/connect");
    this.stompClient = Stomp.over(socket);

    this.stompClient.connect(
      {},
      () => {
        this.connected = true;
        console.log("WebSocket 연결 성공!");

        // 메시지 구독 (서버 Controller의 convertAndSend 경로와 일치)
        this.stompClient.subscribe(`/topic/${roomId}`, (message) => {
          const receivedMessage = JSON.parse(message.body);
          console.log("받은 메시지:", receivedMessage);
          messageCallback(receivedMessage);
        });
      },
      (error) => {
        console.error("WebSocket 연결 실패:", error);
        this.connected = false;
      }
    );
  }

  disconnect() {
    if (this.stompClient) {
      this.stompClient.disconnect();
      this.connected = false;
      console.log("WebSocket 연결 해제");
    }
  }

  sendMessage(roomId, message) {
    if (this.stompClient && this.connected) {
      // ChatMessageReqDto에 맞는 구조 - userName 필드 추가!
      const chatMessage = {
        content: message, // DTO의 content 필드에 맞춤
        userId: 123, // 데모 데이터에 존재하는 user_id
        userName: "테스트사용자", // userName 필드 추가!
        // roomId는 URL 파라미터로 전달됨
        // createdAt은 서버에서 설정
      };

      // 서버 설정의 /publish prefix에 맞춤
      this.stompClient.send(
        `/publish/chat/send/${roomId}`,
        {},
        JSON.stringify(chatMessage)
      );
      console.log("메시지 전송:", chatMessage);
    } else {
      console.error("WebSocket이 연결되지 않았습니다.");
    }
  }
}

export const websocketService = new WebSocketService();
