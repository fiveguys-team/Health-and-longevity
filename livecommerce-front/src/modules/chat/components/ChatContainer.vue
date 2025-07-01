<template>
    <!-- 채팅 컨테이너 전체 영역 -->
    <div class="chat-container flex flex-col h-full bg-white dark:bg-gray-900">
        <!-- 채팅방 헤더: 제목, 참여자 수 -->
        <div class="chat-header p-4 border-b border-gray-200 dark:border-gray-700">
            <div class="flex items-center justify-between">
                <div class="flex items-center space-x-3">
                    <i class="fas fa-comments text-blue-500 text-xl"></i>
                    <div class="text-lg font-bold text-gray-800 dark:text-white">라이브 채팅</div>
                </div>
                <div class="flex items-center space-x-2 text-sm font-medium text-gray-600 dark:text-gray-400">
                    <i class="fas fa-users text-gray-400"></i>
                    <span><span class="font-bold text-gray-800 dark:text-white">{{ participantCount }}</span>명</span>
                </div>
            </div>
        </div>

        <!-- 공지사항 섹션 -->
        <div v-if="currentNotice"
            class="notice-section p-3 bg-blue-50 dark:bg-gray-800 border-b border-gray-200 dark:border-gray-700">
            <div class="flex items-center">
                <span class="bg-red-500 text-white text-xs font-semibold px-2 py-1 rounded-full mr-3">공지</span>
                <p class="text-sm text-gray-800 dark:text-gray-200 flex-1">{{ currentNotice }}</p>
            </div>
        </div>

        <!-- 채팅 메시지 표시 영역 -->
        <div class="chat-messages flex-1 p-4 overflow-y-auto" ref="messageContainer">
            <div v-for="message in messages" :key="message.id" class="message-group mb-4 flex"
                :class="message.isMyMessage ? 'justify-end' : 'justify-start'">
                <div class="flex items-end max-w-[85%]" :class="message.isMyMessage ? 'flex-row-reverse' : 'flex-row'">

                    <!-- 메시지 컨텐츠 -->
                    <div class="message-content mx-2">
                        <!-- 보낸 사람 (내 메시지가 아닐 경우) -->
                        <div v-if="!message.isMyMessage"
                            class="text-sm font-semibold text-gray-700 dark:text-gray-300 mb-1">
                            {{ message.displayName }}
                        </div>
                        <div class="text-base p-3 rounded-lg break-words" :class="{
                            'bg-blue-500 text-white rounded-br-none': message.isMyMessage,
                            'bg-gray-100 dark:bg-gray-700 text-gray-800 dark:text-gray-200 rounded-bl-none': !message.isMyMessage && !message.isWarning,
                            'bg-red-100 text-red-800 border border-red-200 rounded-lg': message.isWarning
                        }">
                            {{ message.content }}
                        </div>
                    </div>

                    <!-- 시간 -->
                    <div class="text-xs text-gray-400 dark:text-gray-500 self-end whitespace-nowrap">
                        {{ formatTime(message.time) }}
                    </div>
                </div>
            </div>
        </div>

        <!-- 메시지 입력 영역 -->
        <div class="chat-input p-4 border-t border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-800">
            <div class="flex items-center space-x-3">
                <input v-model="newMessage" type="text" placeholder="메시지를 입력하세요..."
                    class="flex-1 w-full px-4 py-2 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-full focus:outline-none focus:ring-2 focus:ring-blue-500 dark:text-white transition"
                    @keyup.enter="sendMessage">
                <button @click="sendMessage" :disabled="!newMessage.trim()"
                    class="px-4 py-2 bg-blue-500 text-white rounded-full hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 disabled:bg-gray-400 disabled:cursor-not-allowed transition-colors duration-200 flex-shrink-0">
                    <i class="fas fa-paper-plane"></i>
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

// 🆕 최근 메시지 처리 함수 (입장 시 받는 이전 메시지들)
const handleRecentMessages = (response) => {
    try {
        const message = JSON.parse(response.body);

        console.log('최근 메시지 수신:', message);

        // 최근 메시지는 앞쪽에 추가 (시간순으로 오래된 것부터)
        messages.value.unshift({
            id: message.messageId || `recent_${Date.now()}_${Math.random()}`,
            username: message.userName || `사용자${message.userId}`,
            displayName: message.userName || `사용자${message.userId}`,
            content: message.content,
            time: message.createdAt || new Date().toISOString(),
            isMyMessage: String(message.userId) === String(currentUserId.value),
            userId: message.userId
        });

        // 스크롤을 맨 아래로 (최신 메시지가 보이도록)
        nextTick(() => {
            if (messageContainer.value) {
                messageContainer.value.scrollTop = messageContainer.value.scrollHeight;
            }
        });

    } catch (error) {
        console.error('최근 메시지 처리 중 오류:', error);
    }
};

// 메시지 수신 처리 - 내 메시지인지 구분 추가 (새로운 실시간 메시지)
const handleMessage = (receivedMessage) => {
    console.log('서버에서 받은 메시지 전체:', receivedMessage);
    console.log('현재 사용자 ID:', currentUserId.value);
    console.log('메시지 보낸 사용자 ID:', receivedMessage.userId);

    const isMyMessage = String(receivedMessage.userId) === String(currentUserId.value);

    // 새 메시지는 뒤쪽에 추가 (실시간)
    messages.value.push({
        id: receivedMessage.messageId || Date.now(),
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
                {
                    roomId: roomId.toString(),
                    userId: authStore.id.toString()  // ✅ userId 헤더 추가
                }
            );
        }
    }, 500);
};

// 🆕 최근 메시지 구독 함수
const subscribeToRecentMessages = () => {
    setTimeout(() => {
        if (websocketService.stompClient && websocketService.stompClient.connected) {
            console.log('최근 메시지 구독 시작');

            websocketService.stompClient.subscribe(`/user/${authStore.id}/queue/recent-messages`, handleRecentMessages);

            console.log('최근 메시지 구독 완료');
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
            subscribeToRecentMessages(); // 🆕 최근 메시지 구독 추가
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

    // 🆕 최근 메시지 구독
    subscribeToRecentMessages();

    // 사용자 변경 감지
    watch(() => authStore.id, (newId, oldId) => {
        if (newId !== oldId && oldId !== null) {
            console.log("사용자 변경 감지:", oldId, "→", newId);

            websocketService.disconnect();

            if (newId) {
                setTimeout(() => {
                    websocketService.connect(props.roomId, handleMessage, handleWarning);
                    subscribeToParticipants(props.roomId);
                    subscribeToRecentMessages(); // 🆕 최근 메시지 구독 추가
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
    display: flex;
    flex-direction: column;
    overflow: hidden;
    min-height: 700px;
    height: 100%;
}

/* 채팅 메시지 영역은 유동적으로 늘어나고 스크롤 가능 */
.chat-messages {
    scrollbar-width: thin;
    scrollbar-color: #a0aec0 #f1f5f9;
    /* 스크롤바 색상, 트랙 색상 */
}

.chat-messages::-webkit-scrollbar {
    width: 6px;
}

.chat-messages::-webkit-scrollbar-track {
    background: #f1f5f9;
    /* light: gray-100 */
}

.dark .chat-messages::-webkit-scrollbar-track {
    background: #1f2937;
    /* dark: gray-800 */
}

.chat-messages::-webkit-scrollbar-thumb {
    background-color: #a0aec0;
    /* light: gray-400 */
    border-radius: 3px;
}

.dark .chat-messages::-webkit-scrollbar-thumb {
    background-color: #4b5563;
    /* dark: gray-600 */
}

/* 공지사항 애니메이션 */
.notice-section {
    animation: fadeInDown 0.5s ease-in-out;
}

@keyframes fadeInDown {
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