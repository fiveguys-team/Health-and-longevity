<script setup>
import axios from "axios";
import {onMounted, ref} from "vue";

const APPLICATION_SERVER_URL = process.env.NODE_ENV === 'production' ? ''
    : 'http://localhost:8080/';

const vendorData = ref([]);
const loading = ref(true);

// 더미 데이터
const dummyData = [
  { vendorName: '정관장', maxViewers: 1250 },
  { vendorName: '롯데제과', maxViewers: 980 },
  { vendorName: 'CJ제일제당', maxViewers: 750 },
  { vendorName: '동원F&B', maxViewers: 520 },
  { vendorName: '농심', maxViewers: 420 }
];

const fetchVendorMaxViewers = async () => {
  try {
    loading.value = true;
    const response = await axios.get(`${APPLICATION_SERVER_URL}api/admin/vendors/max-viewers`);
    
    // 데이터가 없거나 빈 배열인 경우 더미 데이터 사용
    if (!response.data || response.data.length === 0) {
      console.log('실제 데이터가 없어서 더미 데이터를 사용합니다.');
      vendorData.value = dummyData;
    } else {
      vendorData.value = response.data;
    }
  } catch (error) {
    console.error('입점업체별 최고 시청자 수 로드 실패:', error);
    console.log('에러로 인해 더미 데이터를 사용합니다.');
    // 에러 시 더미 데이터 사용
    vendorData.value = dummyData;
  } finally {
    loading.value = false;
  }
};

onMounted(() => {
  fetchVendorMaxViewers();
});
</script>

<template>
  <div class="space-y-4">
    <!-- 로딩 상태 -->
    <div v-if="loading" class="flex justify-center items-center py-8">
      <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-500"></div>
    </div>

    <!-- 입점업체별 최고 시청자 수 목록 -->
    <div v-else class="space-y-3">
      <!-- 더미 데이터 표시 알림 -->
      <div v-if="vendorData.length > 0 && vendorData[0].vendorName === '정관장' && vendorData[0].maxViewers === 1250" 
           class="bg-yellow-50 border border-yellow-200 rounded-lg p-3 mb-4">
        <div class="flex items-center">
          <div class="text-yellow-600 mr-2">⚠️</div>
          <div class="text-sm text-yellow-800">
            <strong>더미 데이터 표시 중</strong> - 실제 라이브 데이터가 없어서 샘플 데이터를 보여드립니다.
          </div>
        </div>
      </div>

      <div 
        v-for="(vendor, index) in vendorData" 
        :key="vendor.vendorName"
        class="flex items-center justify-between p-4 bg-white rounded-lg shadow-sm hover:shadow-md transition-shadow duration-200"
      >
        <!-- 순위 및 업체 정보 -->
        <div class="flex items-center space-x-4">
          <!-- 순위 배지 -->
          <div class="flex-shrink-0">
            <div 
              v-if="index < 3" 
              class="w-10 h-10 rounded-full flex items-center justify-center text-white text-sm font-bold"
              :class="{
                'bg-yellow-500': index === 0,
                'bg-gray-400': index === 1,
                'bg-orange-500': index === 2
              }"
            >
              {{ index + 1 }}
            </div>
            <div v-else class="w-10 h-10 rounded-full flex items-center justify-center text-gray-500 text-sm font-bold border-2 border-gray-300">
              {{ index + 1 }}
            </div>
          </div>

          <!-- 업체명 -->
          <div>
            <span class="text-lg font-semibold text-gray-800">{{ vendor.vendorName }}</span>
            <div class="text-sm text-gray-500">이번달 최고 시청자 수</div>
          </div>
        </div>

        <!-- 시청자 수 -->
        <div class="text-right">
          <div class="text-2xl font-bold text-blue-600">
            {{ vendor.maxViewers.toLocaleString() }}명
          </div>
          <div class="text-sm text-gray-500">
            동시 접속자
          </div>
        </div>
      </div>
    </div>

    <!-- 요약 정보 -->
    <div class="mt-6 pt-4 border-t border-gray-200">
      <div class="flex justify-between items-center">
        <span class="text-sm font-medium text-gray-600">총 입점업체</span>
        <span class="text-lg font-bold text-gray-900">{{ vendorData.length }}개사</span>
      </div>
    </div>
  </div>
</template>

<style scoped>
/* 추가 스타일 */
.hover\:shadow-md:hover {
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
}
</style> 