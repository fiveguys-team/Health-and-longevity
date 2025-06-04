<template>
  <div class="max-w-2xl mx-auto p-8 bg-white rounded-lg shadow">
    <h2 class="text-2xl font-bold mb-6">상품 등록</h2>

    <!-- 인증번호 + 버튼 -->
    <div class="flex gap-2 mb-4 items-center">
      <label class="w-32 font-medium text-right">인증번호</label>
      <input type="text" class="flex-1 border px-3 py-2" placeholder="품목제조번호" />
      <button class="px-4 py-2 bg-blue-500 text-white rounded">인증</button>
    </div>

    <!-- api로 받는 정보 안내 -->
    <p class="text-sm text-gray-500 mb-4 text-center">아래는 API로 받은 정보입니다 (수정불가)</p>

    <!-- 자동 입력 항목 -->
    <div v-for="label in apiFields" :key="label" class="flex mb-3 items-center">
      <label class="w-32 font-medium text-right">{{ label }}</label>
      <input type="text" class="flex-1 border px-3 py-2 bg-gray-100 text-gray-600" :placeholder="label" readonly />
    </div>

    <!-- 직접 입력 안내 -->
    <p class="text-sm text-gray-500 my-4 text-center">아래는 입점업체가 직접 입력하는 항목입니다</p>

    <!-- 직접 입력 항목 -->
    <div v-for="label in customFields" :key="label" class="flex mb-3 items-center">
      <label class="w-32 font-medium text-right">{{ label }}</label>
      <input type="text" class="flex-1 border px-3 py-2" :placeholder="label" />
    </div>

    <!-- 이미지 업로드 -->
    <div class="flex mb-3 items-center">
      <label class="w-32 font-medium text-right">이미지</label>
      <input type="file" class="flex-1" />
    </div>

    <!-- 분류 (드롭다운) -->
    <div class="flex mb-6 items-center">
      <label class="w-32 font-medium text-right">분류</label>
      <select class="flex-1 border px-3 py-2">
        <option disabled selected>선택하세요</option>
        <option>혈압</option>
        <option>눈</option>
        <option>뼈/관절/연결성분</option>
        <option>장건강</option>
        <option>영양보충</option>
      </select>
    </div>

    <!-- 버튼 -->
    <div class="flex justify-center gap-4">
      <button class="px-6 py-2 bg-gray-300 text-black rounded">취소</button>
      <button class="px-6 py-2 bg-green-500 text-white rounded">등록</button>
    </div>
  </div>
</template>

<script setup>
const apiFields = [
  '품목명', '유통기한', '허가일자',
  '섭취방법', '주된 기능성', '섭취시 주의사항',
  '보관방법', '기준규격', '원재료'
]

const customFields = ['수량', '가격']
</script>
