<template>
  <div v-if="showModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
    <div class="bg-white dark:bg-gray-800 p-8 rounded-lg max-w-md w-full">
      <template v-if="!result">
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

<!--      <template v-else>-->
<!--        <h2 class="text-2xl font-bold mb-4 dark:text-white">추천 상품</h2>-->
<!--        <div class="bg-gray-100 dark:bg-gray-700 p-4 rounded mb-4">-->
<!--          <pre class="whitespace-pre-wrap">{{ result }}</pre>-->
<!--        </div>-->
<!--        <button @click="closeModal"-->
<!--                class="px-4 py-2 bg-primary text-white rounded hover:bg-primary-dark w-full">-->
<!--          닫기-->
<!--        </button>-->
<!--      </template>-->
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

        <!-- 결과 카드 - 더 컴팩트하게 변경 -->
        <div class="space-y-4 mt-2">
          <div v-for="(product, index) in parsedProducts" :key="index"
               class="bg-gradient-to-r from-blue-50 to-indigo-50 dark:from-gray-700 dark:to-gray-800 p-4 rounded-lg border border-blue-100 dark:border-gray-700">
            <div class="flex items-start">
              <div class="bg-white dark:bg-gray-800 p-2 rounded-md shadow-sm mr-3">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-blue-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z" />
                </svg>
              </div>

              <div class="flex-1">
                <div class="flex items-center">
                  <h3 class="text-lg font-semibold text-gray-800 dark:text-white">{{ product.name }}</h3>
                  <span class="ml-2 bg-blue-100 text-blue-800 text-xs font-medium px-2 py-0.5 rounded-full dark:bg-blue-900 dark:text-blue-300">
                    추천
                  </span>
                </div>

                <p class="text-sm text-gray-600 dark:text-gray-300 mt-1">{{ product.description }}</p>

                <div class="mt-2 flex flex-wrap gap-1">
                  <span v-for="(benefit, idx) in product.benefits" :key="idx"
                        class="bg-blue-50 text-blue-800 text-xs px-2 py-0.5 rounded-full dark:bg-blue-900 dark:text-blue-300">
                    {{ benefit }}
                  </span>
                </div>
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
import {ref, onMounted, defineEmits, computed} from 'vue'
import axiosInstance from "@/api/axios";

const emit = defineEmits(['close']); // 이벤트 추가

const showModal = ref(false)
const isSubmitting = ref(false)
const form = ref({
  gender: '',
  age: '',
  interest: '',
  form: '',
  allergy: ''
})
const result = ref('')

// 결과 텍스트를 파싱하여 구조화된 데이터로 변환
const parsedProducts = computed(() => {
  if (!result.value) return [];

  try {
    // 텍스트에서 각 제품 분리
    const productStrings = result.value.split('\n').filter(p => p.trim());

    return productStrings.map(productStr => {
      // 제품명과 설명 분리
      const match = productStr.match(/\[(.*?)\]\s*-\s*(.*?)\s*-\s*(.*)/);

      if (match && match.length >= 4) {
        return {
          name: match[1],
          benefits: match[2].split(' 및 '), // 혜택 분리
          description: match[3]
        };
      }

      // 파싱 실패 시 원본 텍스트 반환
      return {
        name: "추천 상품",
        benefits: ["건강 혜택"],
        description: productStr
      };
    });
  } catch (e) {
    console.error("결과 파싱 오류:", e);
    return [{
      name: "추천 상품",
      benefits: ["건강 혜택"],
      description: result.value
    }];
  }
});

onMounted(() => {
  showModal.value = true
})

const closeModal = () => {
  showModal.value = false
  result.value = ''
  emit('close'); // 부모 컴포넌트에 닫기 이벤트 전달
}

const submitSurvey = async () => {
  // 1. 필수 입력값 검증
  if (!form.value.gender || !form.value.age || !form.value.interest) {
    alert('성별, 나이, 관심 분야는 필수 입력 항목입니다.');
    return;
  }

  // 2. 숫자 유효성 검사
  if (isNaN(form.value.age)) {
    alert('나이는 숫자로 입력해주세요.');
    return;
  }

  // 3. 제출 상태 업데이트
  isSubmitting.value = true;

  try {
    console.log('API 요청 시작', form.value);

    // 4. API 호출
    const response = await axiosInstance.post('/api/recommendations', form.value);

    console.log('API 응답:', response);

    // 5. 응답 처리
    result.value = response.data;

  } catch (error) {
    console.error('추천 요청 실패:', error);

    // 7. 상세한 에러 메시지
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
    // 8. 제출 상태 초기화
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