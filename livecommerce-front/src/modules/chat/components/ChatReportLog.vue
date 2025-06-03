<template>
  <div class="p-8">
    <div class="bg-white dark:bg-dark-secondary rounded-lg shadow-lg p-6">
      <h2 class="text-2xl font-bold mb-6">채팅 신고 로그</h2>
      
      <!-- 테이블 -->
      <div class="overflow-x-auto">
        <table class="min-w-full bg-white dark:bg-dark-secondary rounded-lg">
          <thead class="bg-gray-50 dark:bg-dark-light">
            <tr>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">번호</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">채널명</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">신고자</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">신고 대상</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">메시지</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">신고 사유</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">처리 상태</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">관리</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-200 dark:divide-dark-light">
            <tr v-for="report in chatReports" :key="report.id" class="hover:bg-gray-50 dark:hover:bg-dark-light">
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900 dark:text-gray-300">{{ report.id }}</td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900 dark:text-gray-300">{{ report.channelName }}</td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900 dark:text-gray-300">{{ report.reporter }}</td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900 dark:text-gray-300">{{ report.reported }}</td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900 dark:text-gray-300">{{ report.message }}</td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900 dark:text-gray-300">{{ report.reason }}</td>
              <td class="px-6 py-4 whitespace-nowrap text-sm">
                <span :class="{
                  'px-2 py-1 rounded text-xs font-semibold': true,
                  'bg-yellow-100 text-yellow-800': report.status === '대기중',
                  'bg-green-100 text-green-800': report.status === '처리완료',
                  'bg-red-100 text-red-800': report.status === '반려'
                }">
                  {{ report.status }}
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900 dark:text-gray-300">
                <button 
                  @click="handleReport(report.id)"
                  class="text-indigo-600 hover:text-indigo-900 dark:text-indigo-400 dark:hover:text-indigo-300 mr-2">
                  처리
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';

// 신고 데이터 (나중에 API로 대체)
const chatReports = ref([
  {
    id: 1,
    channelName: '눈 건강 방',
    reporter: 'userA',
    reported: 'userB',
    message: '"xxx 해봤요" 욕설',
    reason: '비하발언',
    status: '대기중'
  },
  {
    id: 2,
    channelName: '혈압 관리 방',
    reporter: 'userC',
    reported: 'userD',
    message: '"광고 괜찮네요 광고"',
    reason: '채널규정위반',
    status: '처리완료'
  },
  {
    id: 3,
    channelName: '관절 통증 방',
    reporter: 'userE',
    reported: 'userF',
    message: '"근데 다 병원이 간강에 해로운"',
    reason: '비하발언',
    status: '대기중'
  }
]);

// 신고 처리 함수
const handleReport = (reportId) => {
  // 신고 처리 로직 구현
  console.log(`신고 ID ${reportId} 처리`);
};

onMounted(() => {
  // API 호출 등 초기화 로직
});
</script> 