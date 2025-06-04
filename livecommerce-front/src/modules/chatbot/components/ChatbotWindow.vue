<template>
<div class="fixed bottom-6 right-6 w-[400px] bg-white rounded-2xl shadow-2xl overflow-hidden border-2 border-gray-100">
  <div class="bg-primary p-5 flex justify-between items-center">
    <div class="flex items-center gap-3">
      <h3 class="text-xl text-white font-bold">건강 상담</h3>
    </div>
    <button @click="toggleChat" class="text-white hover:text-gray-200 text-xl">
      <span v-if="isOpen">−</span>
      <span v-else>+</span>
    </button>
  </div>

  <div v-show="isOpen" class="flex flex-col h-[500px]">
    <div class="flex-1 p-5 overflow-y-auto bg-gray-50" ref="messageContainer">
      <div v-for="(message, index) in messages" :key="index" 
           class="mb-4" 
           :class="{'flex justify-end': message.isUser, 'flex justify-start': !message.isUser}">
        <div :class="{
          'max-w-[80%] rounded-2xl p-4 text-lg': true,
          'bg-primary text-white': message.isUser,
          'bg-white shadow-md text-gray-800': !message.isUser
        }">
          {{ message.text }}
        </div>
      </div>
    </div>

    <div class="border-t-2 p-5 bg-white">
      <div class="flex gap-3">
        <input 
          v-model="userInput"
          @keyup.enter="sendMessage"
          type="text"
          placeholder="메시지를 입력해주세요..."
          class="flex-1 border-2 rounded-xl px-5 py-3 text-lg focus:outline-none focus:border-primary"
        >
        <button 
          @click="sendMessage"
          class="bg-primary text-white px-6 py-3 rounded-xl hover:bg-primary-dark text-lg font-semibold min-w-[80px]"
        >
          전송
        </button>
      </div>
    </div>
  </div>
</div>
</template>

<script setup>
import { ref, onMounted, nextTick } from 'vue'

const isOpen = ref(true)
const userInput = ref('')
const messages = ref([
  { 
    text: '안녕하세요! 무병장수 건강 상담 챗봇입니다.\n어떤 건강 관련 문의사항이 있으신가요?', 
    isUser: false 
  }
])
const messageContainer = ref(null)

const toggleChat = () => {
  isOpen.value = !isOpen.value
}

const scrollToBottom = async () => {
  await nextTick()
  if (messageContainer.value) {
    messageContainer.value.scrollTop = messageContainer.value.scrollHeight
  }
}

const sendMessage = async () => {
  if (!userInput.value.trim()) return

  messages.value.push({
    text: userInput.value,
    isUser: true
  })

  await scrollToBottom()

  setTimeout(() => {
    messages.value.push({
      text: '현재 상담원과 연결 중입니다. 잠시만 기다려주세요.',
      isUser: false
    })
    scrollToBottom()
  }, 1000)

  userInput.value = ''
}

onMounted(() => {
  scrollToBottom()
})
</script>

<style scoped>
.message-container::-webkit-scrollbar {
  width: 8px;
}

.message-container::-webkit-scrollbar-thumb {
  background-color: #e2e8f0;
  border-radius: 4px;
}

.message-container::-webkit-scrollbar-track {
  background-color: #f8fafc;
}
</style> 