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

    // connect 시에는 headers 없이 연결
    this.stompClient.connect(
      {},
      () => {
        this.connected = true;
        console.log("WebSocket 연결 성공!");

        // subscribe 시 roomId를 header로 전달
        this.stompClient.subscribe(
          `/topic/${roomId}`,
          (message) => {
            const receivedMessage = JSON.parse(message.body);
            console.log("받은 메시지:", receivedMessage);
            messageCallback(receivedMessage);
          },
          { roomId: String(roomId) } // subscribe header에 roomId 전달
        );
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
      // ChatMessageReqDto에 맞는 구조
      const chatMessage = {
        content: message,
        userId: 1, // 테스트용 더미 데이터
        userName: "테스트사용자" // 테스트용 더미 데이터
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
