<template>
    <!-- 채팅 컨테이너 전체 영역 -->
    <div class="chat-container h-full flex flex-col bg-white dark:bg-gray-800 rounded-lg shadow-lg">
        <!-- 채팅방 헤더: 제목, 참여자 수, 닫기 버튼 -->
        <div class="chat-header p-4 border-b dark:border-gray-700">
            <div class="flex items-center justify-between">
                <div class="flex items-center space-x-2">
                    <div class="text-lg font-semibold dark:text-white">라이브 채팅</div>
                    <div class="text-sm text-gray-500 dark:text-gray-400">
                        <span class="online-count">{{ participantCount }}</span> 명 시청중
                    </div>
                </div>
                <button @click="leaveRoom"
                    class="text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        </div>

        <!-- 공지사항 섹션 -->
        <div v-if="currentNotice" class="notice-section p-3 bg-blue-50 dark:bg-gray-700 border-b dark:border-gray-600">
            <div class="flex items-center">
                <span class="bg-red-500 text-white text-xs px-2 py-1 rounded mr-2">공지</span>
                <p class="text-sm text-gray-800 dark:text-gray-200 flex-1">{{ currentNotice }}</p>
            </div>
        </div>

        <!-- 채팅 메시지 표시 영역 -->
        <div class="chat-messages flex-1 p-4 overflow-y-auto" ref="messageContainer">
            <div v-for="message in messages" :key="message.id" class="mb-3"
                :class="{ 'flex justify-end': message.isMyMessage }">
                <div class="flex flex-col" :class="{ 'items-end': message.isMyMessage }">
                    <div class="flex items-center" :class="{ 'space-x-reverse': message.isMyMessage }">
                        <span class="text-xs text-gray-500 order-1"
                            :class="{ 'ml-2': !message.isMyMessage, 'mr-2': message.isMyMessage }">
                            {{ formatTime(message.time) }}
                        </span>
                        <span class="font-medium text-gray-900 dark:text-white"
                            :class="{ 'order-2': !message.isMyMessage, 'order-0': message.isMyMessage }">
                            {{ message.displayName }}
                        </span>
                    </div>
                    <p class="mt-1 text-gray-800 dark:text-gray-200 max-w-[80%] break-words" :class="{
                        'bg-blue-500 text-white px-3 py-2 rounded-lg': message.isMyMessage,
                        'bg-gray-100 dark:bg-gray-700 px-3 py-2 rounded-lg': !message.isMyMessage && !message.isWarning,
                        'bg-red-100 text-red-700 px-3 py-2 rounded-lg border border-red-300': message.isWarning
                    }">
                        {{ message.content }}
                    </p>
                </div>
            </div>
        </div>

        <!-- 메시지 입력 영역 -->
        <div class="chat-input p-4 border-t dark:border-gray-700">
            <div class="flex space-x-2">
                <input v-model="newMessage" type="text" placeholder="메시지를 입력하세요..."
                    class="flex-1 px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
                    @keyup.enter="sendMessage">
                <button @click="sendMessage"
                    class="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-500">
                    전송
                </button>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted, nextTick, watch, onBeforeUnmount, computed } from 'vue';
import { websocketService } from '../services/websocket.service';
import { useAuthStore } from "@/modules/auth/stores/auth";

// Props 정의 - 부모 컴포넌트로부터 받을 값들
// eslint-disable-next-line no-undef
const props = defineProps({
    roomId: {
        type: Number,
        required: true,
        validator(value) {
            return value > 0;
        }
    },
    initialAnnouncement: {
        type: String,
        default: '라이브 방송 중에는 예의 바른 채팅 부탁드립니다.'
    }
});

// 상태 관리
const messages = ref([]);
const newMessage = ref('');
const messageContainer = ref(null);
const participantCount = ref(0);
const currentNotice = ref('');

// auth store 인스턴스
const authStore = useAuthStore();

// 현재 로그인한 사용자 ID (반응형)
const currentUserId = computed(() => authStore.id);

// 메시지 수신 처리 - 내 메시지인지 구분 추가
const handleMessage = (receivedMessage) => {
    console.log('서버에서 받은 메시지 전체:', receivedMessage);
    console.log('현재 사용자 ID:', currentUserId.value);
    console.log('메시지 보낸 사용자 ID:', receivedMessage.userId);

    const isMyMessage = String(receivedMessage.userId) === String(currentUserId.value);

    messages.value.push({
        id: Date.now(),
        username: receivedMessage.userName || `사용자${receivedMessage.userId}`,
        displayName: receivedMessage.userName || `사용자${receivedMessage.userId}`,
        content: receivedMessage.content,
        time: receivedMessage.createdAt || new Date().toISOString(),
        isMyMessage: isMyMessage,
        userId: receivedMessage.userId
    });

    nextTick(() => {
        if (messageContainer.value) {
            messageContainer.value.scrollTop = messageContainer.value.scrollHeight;
        }
    });
};

// 경고 메시지 처리 함수
const handleWarning = (warningMessage) => {
    messages.value.push({
        id: Date.now(),
        username: '시스템',
        displayName: '시스템',
        content: warningMessage.content,
        time: new Date().toISOString(),
        isWarning: true,
        isMyMessage: false
    });

    const idx = messages.value.length - 1;

    setTimeout(() => {
        messages.value.splice(idx, 1);
    }, 3000);
};

// 메시지 전송 - props.roomId 사용
const sendMessage = () => {
    if (!newMessage.value.trim()) return;

    if (!currentUserId.value) {
        console.error("로그인이 필요합니다.");
        return;
    }

    websocketService.sendMessage(props.roomId, newMessage.value);
    newMessage.value = '';
};

// 채팅방 나가기
const leaveRoom = () => {
    websocketService.disconnect();
};

// 시간 포맷팅
const formatTime = (isoString) => {
    const date = new Date(isoString);
    return date.toLocaleTimeString('ko-KR', {
        hour: '2-digit',
        minute: '2-digit'
    });
};

// 새 메시지가 추가될 때마다 스크롤을 맨 아래로 이동
watch(() => messages.value, async () => {
    await nextTick();
    if (messageContainer.value) {
        messageContainer.value.scrollTop = messageContainer.value.scrollHeight;
    }
}, { deep: true });

// 참여자 수 구독 함수
const subscribeToParticipants = (roomId) => {
    setTimeout(() => {
        if (websocketService.stompClient && websocketService.stompClient.connected) {
            websocketService.stompClient.subscribe(
                `/topic/room.${roomId}.participants`,
                (message) => {
                    participantCount.value = parseInt(message.body, 10);
                },
                { roomId: roomId.toString() }
            );
        }
    }, 500);
};

// roomId 변경 감지
watch(() => props.roomId, (newRoomId, oldRoomId) => {
    if (newRoomId !== oldRoomId && oldRoomId) {
        console.log(`채팅방 변경: ${oldRoomId} → ${newRoomId}`);

        websocketService.disconnect();
        messages.value = [];

        setTimeout(() => {
            websocketService.connect(newRoomId, handleMessage, handleWarning);
            subscribeToParticipants(newRoomId);
        }, 100);
    }
});

onMounted(() => {
    // props에서 받은 공지사항으로 초기화
    currentNotice.value = props.initialAnnouncement;

    // props.roomId로 WebSocket 연결
    console.log(`채팅방 연결 시작 - roomId: ${props.roomId}`);
    websocketService.connect(props.roomId, handleMessage, handleWarning);

    // 실시간 참여자 수 구독
    subscribeToParticipants(props.roomId);

    // 사용자 변경 감지
    watch(() => authStore.id, (newId, oldId) => {
        if (newId !== oldId && oldId !== null) {
            console.log("사용자 변경 감지:", oldId, "→", newId);

            websocketService.disconnect();

            if (newId) {
                setTimeout(() => {
                    websocketService.connect(props.roomId, handleMessage, handleWarning);
                    subscribeToParticipants(props.roomId);
                }, 100);
            }
        }
    });
});

onBeforeUnmount(() => {
    console.log(`채팅방 연결 해제 - roomId: ${props.roomId}`);
    websocketService.disconnect();
});
</script>

<style scoped>
/* 채팅 전체 컨테이너를 부모 높이에 맞춰 유연하게 설정 */
.chat-container {
    height: 100%;
    display: flex;
    flex-direction: column;
    background-color: white;
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    overflow: hidden;
}

/* 채팅 메시지 영역은 유동적으로 늘어나고 스크롤 가능 */
.chat-messages {
    flex: 1;
    padding: 1rem;
    overflow-y: auto;

    /* 스크롤바 스타일 */
    scrollbar-width: thin;
    scrollbar-color: rgba(156, 163, 175, 0.5) transparent;
}

.chat-messages::-webkit-scrollbar {
    width: 6px;
}

.chat-messages::-webkit-scrollbar-track {
    background: transparent;
}

.chat-messages::-webkit-scrollbar-thumb {
    background-color: rgba(156, 163, 175, 0.5);
    border-radius: 3px;
}

/* 공지사항 애니메이션 */
.notice-section {
    animation: fadeIn 0.3s ease-in-out;
    background-color: #ebf8ff;
    border-bottom: 1px solid #cbd5e0;
    padding: 0.75rem;
}

@keyframes fadeIn {
    from {
        opacity: 0;
        transform: translateY(-10px);
    }

    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* 입력창 고정 */
.chat-input {
    padding: 1rem;
    border-top: 1px solid #e2e8f0;
    background-color: white;
    flex-shrink: 0;
}

/* 헤더 고정 */
.chat-header {
    flex-shrink: 0;
}
</style>