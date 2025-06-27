<template>
  <div v-if="props.showModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
    <div class="bg-white dark:bg-gray-800 p-8 rounded-lg max-w-md w-full max-h-[90vh] flex flex-col">
      <template v-if="!result.length">
        <h2 class="text-2xl font-bold mb-4 dark:text-white">건강 설문 조사</h2>
        <form @submit.prevent="submitSurvey" class="space-y-4">
          <div>
            <label class="block text-gray-700 dark:text-gray-300 mb-1">성별</label>
            <select v-model="form.gender" class="w-full p-2 border rounded dark:bg-gray-700 dark:text-white">
              <option value="">선택하세요</option>
              <option value="MALE">남성</option>
              <option value="FEMALE">여성</option>
            </select>
          </div>

          <div>
            <label class="block text-gray-700 dark:text-gray-300 mb-1">나이</label>
            <input v-model.number="form.age" type="number"
                   class="w-full p-2 border rounded dark:bg-gray-700 dark:text-white"
                   placeholder="나이를 입력하세요">
          </div>

          <div>
            <label class="block text-gray-700 dark:text-gray-300 mb-1">관심 분야</label>
            <select v-model="form.interest" class="w-full p-2 border rounded dark:bg-gray-700 dark:text-white">
              <option value="">선택하세요</option>
              <option value="IMMUNITY">면역력 강화</option>
              <option value="EYE">눈 건강</option>
              <option value="LIVER">간 건강</option>
              <option value="JOINT">관절 건강</option>
            </select>
          </div>

          <div>
            <label class="block text-gray-700 dark:text-gray-300 mb-1">선호 복용 형태</label>
            <select v-model="form.form" class="w-full p-2 border rounded dark:bg-gray-700 dark:text-white">
              <option value="">선택하세요</option>
              <option value="CAPSULE">캡슐</option>
              <option value="POWDER">분말</option>
              <option value="LIQUID">액상</option>
            </select>
          </div>

          <div>
            <label class="block text-gray-700 dark:text-gray-300 mb-1">알러지 성분</label>
            <input v-model="form.allergy"
                   class="w-full p-2 border rounded dark:bg-gray-700 dark:text-white"
                   placeholder="알러지가 있는 성분을 입력하세요">
          </div>

          <div class="flex justify-end space-x-3">
            <button type="button" @click="closeModal"
                    class="px-4 py-2 bg-gray-300 rounded hover:bg-gray-400 dark:bg-gray-600 dark:hover:bg-gray-700">
              닫기
            </button>
            <button type="button" @click="submitSurvey" :disabled="isSubmitting"
                    class="px-4 py-2 bg-primary text-white rounded hover:bg-primary-dark disabled:opacity-50">
              <span v-if="!isSubmitting">추천받기</span>
              <span v-else>처리 중...</span>
            </button>
          </div>
        </form>
      </template>

      <template v-else>
        <!-- 헤더 부분 -->
        <div class="sticky top-0 bg-white dark:bg-gray-800 pb-4 z-10">
          <div class="flex justify-between items-center mb-2">
            <h2 class="text-xl font-bold dark:text-white">맞춤 추천 결과</h2>
            <button @click="closeModal" class="text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-white">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>
          <p class="text-sm text-gray-500 dark:text-gray-400">설문을 기반으로 추천드립니다</p>
        </div>

        <!-- 결과 카드 - 이미지, 이름, 가격, 주요기능, 복용법, 주의사항 -->
        <div class="space-y-4 mt-2 overflow-y-auto flex-1 pr-2" style="max-height:40vh;">
          <div v-for="product in parsedProducts" :key="product.productId"
               class="bg-gradient-to-r from-blue-50 to-indigo-50 dark:from-gray-700 dark:to-gray-800 p-4 rounded-lg border border-blue-100 dark:border-gray-700 flex gap-4">
            <!-- 이미지 -->
            <img :src="product.productImage" alt="상품 이미지" class="w-24 h-24 object-cover rounded-md border" v-if="product.productImage" />
            <!-- 상품 정보 -->
            <div class="flex-1">
              <div class="flex items-center">
                <h3 class="text-lg font-semibold text-gray-800 dark:text-white">{{ product.name }}</h3>
                <span class="ml-2 bg-blue-100 text-blue-800 text-xs font-medium px-2 py-0.5 rounded-full dark:bg-blue-900 dark:text-blue-300">
                  추천
                </span>
              </div>
              <div class="text-sm text-gray-600 dark:text-gray-300 mt-1" v-if="product.price">
                가격: <b>{{ product.price.toLocaleString() }}원</b>
              </div>
              <div class="text-xs text-gray-500 dark:text-gray-400 mt-1" v-if="product.mainFunction">
                <b>주요기능:</b> {{ product.mainFunction }}
              </div>
              <div class="text-xs text-gray-500 dark:text-gray-400 mt-1" v-if="product.howToTake">
                <b>복용법:</b> {{ product.howToTake }}
              </div>
              <div class="text-xs text-gray-500 dark:text-gray-400 mt-1" v-if="product.precautions">
                <b>주의사항:</b> {{ product.precautions }}
              </div>
            </div>
          </div>
        </div>

        <!-- 닫기 버튼 -->
        <div class="sticky bottom-0 bg-white dark:bg-gray-800 pt-4 pb-2">
          <button @click="closeModal"
                  class="w-full py-2 bg-blue-500 hover:bg-blue-600 text-white rounded-md font-medium transition-colors">
            닫기
          </button>
          <p class="text-xs text-center text-gray-500 dark:text-gray-400 mt-2">
            건강한 삶을 위한 첫걸음
          </p>
        </div>
      </template>
    </div>
  </div>
</template>

<script setup>
import {ref, defineEmits, computed, defineProps} from 'vue'
import axiosInstance from "@/api/axios";
import { useAuthStore } from '@/modules/auth/stores/auth';

const props = defineProps({
  showModal: {
    type: Boolean,
    default: false
  }
});

const authStore = useAuthStore();
const emit = defineEmits(['close', 'recommend']);
const isSubmitting = ref(false)
const form = ref({
  gender: '',
  age: '',
  interest: '',
  form: '',
  allergy: ''
})
const result = ref([])

// 결과 텍스트를 파싱하여 구조화된 데이터로 변환
const parsedProducts = computed(() => {
  // result.value가 배열이면 그대로 반환
  if (Array.isArray(result.value)) return result.value;
  return [];
});

const closeModal = () => {
  result.value = '';
  // 세션 스토리지에 설문 표시 여부 저장 (로그아웃 전까지 유지)
  if (authStore.id) {
    sessionStorage.setItem(`surveyShown_${authStore.id}`, 'true');
  }
  emit('close');
}

const submitSurvey = async () => {
  // 1. 필수 입력값 검증
  if (!form.value.gender || !form.value.age || !form.value.interest) {
    alert('성별, 나이, 관심 분야는 필수 입력 항목입니다.');
    return;
  }
  if (isNaN(form.value.age)) {
    alert('나이는 숫자로 입력해주세요.');
    return;
  }
  isSubmitting.value = true;
  try {
    const response = await axiosInstance.post('/api/recommendations', form.value);
    result.value = response.data;
    // 세션 스토리지에 설문 표시 여부 저장 (로그아웃 전까지 유지)
    if (authStore.id) {
      sessionStorage.setItem(`surveyShown_${authStore.id}`, 'true');
    }
    emit('recommend', result.value);
  } catch (error) {
    let errorMessage = '추천 요청에 실패했습니다.';
    if (error.response) {
      errorMessage += `\n상태 코드: ${error.response.status}`;
      if (error.response.data) {
        errorMessage += `\n에러 메시지: ${JSON.stringify(error.response.data)}`;
      }
    } else if (error.request) {
      errorMessage += '\n서버로부터 응답이 없습니다.';
    } else {
      errorMessage += `\n${error.message}`;
    }
    alert(errorMessage);
  } finally {
    isSubmitting.value = false;
  }
}
</script>

<style scoped>
/* 모달 애니메이션 */
.modal-enter-active, .modal-leave-active {
  transition: opacity 0.3s, transform 0.3s;
}
.modal-enter-from, .modal-leave-to {
  opacity: 0;
  transform: scale(0.95);
}

/* 스크롤바 스타일링 */
::-webkit-scrollbar {
  width: 8px;
}
::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 4px;
}
::-webkit-scrollbar-thumb {
  background: #c5c5c5;
  border-radius: 4px;
}
::-webkit-scrollbar-thumb:hover {
  background: #a8a8a8;
}
.dark ::-webkit-scrollbar-track {
  background: #374151;
}
.dark ::-webkit-scrollbar-thumb {
  background: #4b5563;
}
.dark ::-webkit-scrollbar-thumb:hover {
  background: #6b7280;
}

/* 그라데이션 배경 */
.bg-gradient-to-r {
  background-size: 200% 200%;
  animation: gradient 3s ease infinite;
}
@keyframes gradient {
  0% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
  100% { background-position: 0% 50%; }
}

/* 카드 호버 효과 */
.shadow-md {
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}
.shadow-md:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
}
</style>