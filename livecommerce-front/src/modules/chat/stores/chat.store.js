import { defineStore } from 'pinia';

/**
 * 채팅 관련 상태 관리를 위한 Pinia 스토어
 * Redis와 WebSocket을 통한 실시간 채팅 데이터를 관리합니다.
 */
export const useChatStore = defineStore('chat', {
    state: () => ({
        // Redis List에서 가져온 최근 메시지들을 저장 (최대 50개)
        // LRANGE chatroom:{roomId} 0 49 명령어로 가져온 결과를 저장
        messages: [],          

        // Redis Set에 저장된 참여자 목록과 동기화
        // SMEMBERS chatroom:{roomId}:participants 결과와 동기화
        participants: new Set(), 

        // Redis Set의 참여자 수를 저장
        // SCARD chatroom:{roomId}:participants 명령어의 결과값
        participantCount: 0,   

        // 현재 로그인한 사용자 정보
        currentUser: {
            userId: null,      // 사용자 고유 식별자
            username: null,    // 사용자 이름
            avatar: null       // 프로필 이미지 URL
        },

        // WebSocket 연결 상태
        isConnected: false,    

        // 현재 접속한 채팅방 ID
        roomId: null,

        // 공지사항 텍스트
        notice: null,

        // 관리자 여부
        isAdmin: false
    }),

    actions: {
        /**
         * WebSocket 연결 상태를 설정합니다.
         * @param {boolean} status - 연결 상태
         */
        setConnectionStatus(status) {
            this.isConnected = status;
        },

        /**
         * 채팅방 입장 처리
         * 1. WebSocket을 통해 채팅방 구독
         * 2. Redis SADD로 참여자 추가
         * 3. Redis LRANGE로 최근 메시지 로드
         * @param {string} roomId - 채팅방 ID
         */
        enterRoom(roomId) {
            this.roomId = roomId;
            // WebSocket subscribe 로직 추가 예정
            // 예: stompClient.subscribe('/topic/chat/' + roomId, callback);
        },

        /**
         * 채팅방 퇴장 처리
         * 1. WebSocket 구독 해제
         * 2. Redis SREM으로 참여자 제거
         * 3. 로컬 상태 초기화
         */
        leaveRoom() {
            this.roomId = null;
            this.messages = [];
            this.participants.clear();
            this.participantCount = 0;
            // WebSocket unsubscribe 로직 추가 예정
        },

        /**
         * Redis에서 가져온 최근 메시지들을 설정
         * LRANGE chatroom:{roomId} 0 49 명령어의 결과를 저장
         * @param {Array} messages - 최근 메시지 배열
         */
        setRecentMessages(messages) {
            this.messages = messages;
        },

        /**
         * 새로운 채팅 메시지 추가
         * 1. Redis LPUSH로 메시지 저장
         * 2. Redis LTRIM으로 최근 50개만 유지
         * 3. WebSocket을 통해 다른 클라이언트에게 브로드캐스트
         * @param {Object} message - 채팅 메시지 객체
         */
        addMessage(message) {
            this.messages.push(message);
            // 최대 50개까지만 유지 (Redis의 LTRIM 동작 방식과 동일)
            if (this.messages.length > 50) {
                this.messages.shift();
            }
        },

        /**
         * 채팅방 참여자 추가
         * Redis SADD chatroom:{roomId}:participants {userId} 명령어와 동기화
         * @param {string} userId - 사용자 ID
         */
        addParticipant(userId) {
            this.participants.add(userId);
            this.participantCount = this.participants.size;
        },

        /**
         * 채팅방 참여자 제거
         * Redis SREM chatroom:{roomId}:participants {userId} 명령어와 동기화
         * @param {string} userId - 사용자 ID
         */
        removeParticipant(userId) {
            this.participants.delete(userId);
            this.participantCount = this.participants.size;
        },

        /**
         * 참여자 수 설정
         * Redis SCARD chatroom:{roomId}:participants 명령어의 결과값 설정
         * @param {number} count - 참여자 수
         */
        setParticipantCount(count) {
            this.participantCount = count;
        },

        /**
         * 현재 사용자 정보 설정
         * @param {Object} user - 사용자 정보 객체
         */
        setCurrentUser(user) {
            this.currentUser = user;
        },

        /**
         * 공지사항 설정
         * Redis SET chatroom:{roomId}:notice {notice} 명령어와 동기화
         * @param {string} notice - 공지사항 텍스트
         */
        setNotice(notice) {
            this.notice = notice;
            // WebSocket을 통해 서버에 공지사항 업데이트 요청
            // 예: stompClient.send("/app/chat/" + this.roomId + "/notice", {}, notice);
        },

        /**
         * 관리자 권한 설정
         * @param {boolean} isAdmin - 관리자 여부
         */
        setAdminStatus(isAdmin) {
            this.isAdmin = isAdmin;
        },

        /**
         * 채팅방 입장 시 공지사항 로드
         * Redis GET chatroom:{roomId}:notice 명령어로 가져온 결과를 저장
         */
        loadNotice() {
            // WebSocket을 통해 서버에 공지사항 요청
            // 예: stompClient.send("/app/chat/" + this.roomId + "/notice/get");
        }
    }
}); 