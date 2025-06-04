<template>
  <div class="p-8 max-w-4xl mx-auto">
    <h2 class="text-2xl font-bold mb-6">상품 상세 정보</h2>
    <div class="border p-6 rounded shadow space-y-4">
      <p><strong>상품명:</strong> 홍삼농축액</p>
      <p><strong>업체명:</strong> 한국인삼공사</p>
      <p><strong>인증번호:</strong> 2009-29</p>
      <p><strong>원재료:</strong> 홍삼농축액(Rg1과 Rb1의 합)</p>
      <p><strong>상품 설명:</strong> 면역력 증진, 피로 개선에 도움을 줄 수 있음</p>
      <p><strong>등록일:</strong> 2025-05-28</p>
    </div>

    <div class="flex justify-center mt-8 gap-4">
      <button class="bg-green-600 text-white px-6 py-2 rounded">승인</button>
      <button class="bg-red-600 text-white px-6 py-2 rounded">거절</button>
    </div>
  </div>
</template>

<script setup>
// 실제 구현 시 route 파라미터로 상품 ID 받아와서 API 요청 예정
</script>