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
                :class="{ 'flex justify-end': message.username === '나' }">
                <div class="flex flex-col" :class="{ 'items-end': message.username === '나' }">
                    <div class="flex items-center" :class="{ 'space-x-reverse': message.username === '나' }">
                        <span class="text-xs text-gray-500 order-1"
                            :class="{ 'ml-2': message.username !== '나', 'mr-2': message.username === '나' }">
                            {{ formatTime(message.time) }}
                        </span>
                        <span class="font-medium text-gray-900 dark:text-white"
                            :class="{ 'order-2': message.username !== '나', 'order-0': message.username === '나' }">
                            {{ message.username }}
                        </span>
                    </div>
                    <p class="mt-1 text-gray-800 dark:text-gray-200 max-w-[80%] break-words" :class="{
                        'bg-blue-500 text-white px-3 py-2 rounded-lg': message.username === '나',
                        'bg-gray-100 dark:bg-gray-700 px-3 py-2 rounded-lg': message.username !== '나'
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
import { ref, onMounted, nextTick, watch, onBeforeUnmount } from 'vue';
import { websocketService } from '../services/websocket.service';

// 상태 관리
const messages = ref([]);
const newMessage = ref("");
const messageContainer = ref(null);
const participantCount = ref(0);
const currentNotice = ref("");

// 테스트용 roomId
const roomId = 1; // 실제로는 props로 받아야 함

const handleMessage = (message) => {
    console.log('서버에서 받은 메시지:', message);

    // 메시지 타입에 따른 처리
    if (message.type === 'PARTICIPANT_COUNT') {
        // 참여자 수 업데이트 메시지 처리
        participantCount.value = message.count;
    } else {
        // 일반 채팅 메시지 처리
        messages.value.push({
            id: Date.now(),
            content: message.content,
            userName: message.userName || message.userId,
            timestamp: new Date().toISOString(),
        });
    }
};

// 메시지 전송
const sendMessage = () => {
    if (!newMessage.value.trim()) return;

    websocketService.sendMessage(roomId, newMessage.value);
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

onMounted(() => {
    // 테스트용 초기 데이터
    currentNotice.value = "라이브 방송 중에는 예의 바른 채팅 부탁드립니다.";
    participantCount.value = 128;

    // WebSocket 연결
    websocketService.connect(roomId, handleMessage);
});

onBeforeUnmount(() => {
    websocketService.disconnect();
});
</script>

<style scoped>
/* 채팅 컨테이너 높이 설정 */
.chat-container {
    height: 600px;
}

/* 스크롤바 스타일링 */
.chat-messages {
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

/* 공지사항 섹션 애니메이션 */
.notice-section {
    animation: fadeIn 0.3s ease-in-out;
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
</style>