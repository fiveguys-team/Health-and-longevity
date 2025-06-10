import SockJS from 'sockjs-client';
import { Stomp } from '@stomp/stompjs';

class WebSocketService {
    constructor() {
        this.stompClient = null;
        this.connected = false;
    }

    connect(roomId, messageCallback) {
        const socket = new SockJS('http://localhost:8080/connect');
        this.stompClient = Stomp.over(socket);

        this.stompClient.connect({}, () => {
            this.connected = true;
            console.log('WebSocket 연결 성공!');

            // 메시지 구독
            this.stompClient.subscribe(`/topic/${roomId}`, (message) => {
                const receivedMessage = JSON.parse(message.body);
                messageCallback(receivedMessage);
            });
        }, 
        (error) => {
            console.error('WebSocket 연결 실패:', error);
            this.connected = false;
        });
    }

    disconnect() {
        if (this.stompClient) {
            this.stompClient.disconnect();
            this.connected = false;
        }
    }

    sendMessage(roomId, message) {
        if (this.stompClient && this.connected) {
            const chatMessage = {
                message: message,
                sender: "테스트 사용자",  // 실제로는 로그인한 사용자 정보를 사용
                type: "TALK"
            };

            this.stompClient.send(`/publish/chat/send/${roomId}`, {}, JSON.stringify(chatMessage));
        }
    }
}

export const websocketService = new WebSocketService(); 