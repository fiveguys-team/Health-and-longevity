<template>
  <div class="live-consumer">
    <!-- Live Info Bar -->
    <div class="live-info-bar">
      <div class="live-title">{{ broadcastTitle }}</div>
      <div class="vendor-name">{{ vendorName }}</div>
      <div class="viewer-count">
        <span class="viewer-number">{{ viewerCount }}</span>명
      </div>
      <div class="timer">⏱ {{ displayElapsed }} 방송중</div>
    </div>

    <!-- Video Area (placeholder) -->
    <div class="live-video-container">
      <div class="video-placeholder">라이브</div>
    </div>

    <!-- Products Display (1-3개) -->
    <div class="products">
      <div class="product-card" v-for="item in limitedProducts" :key="item.id">
        <div class="product-image">
          <img :src="item.imageUrl" alt="상품 이미지" />
        </div>
        <div class="product-name">{{ item.productName }}</div>
        <div class="price">
          <span class="discount-price">{{ item.discountPrice }}원</span>
          <span class="original-price">{{ item.originalPrice }}원</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onBeforeUnmount } from 'vue';

// 방송 정보
const broadcastTitle = ref('방송 제목');
const vendorName = ref('입점업체명');
const viewerCount = ref(1234);

// 타이머
const startTime = Date.now();
const now = ref(Date.now());
let timerId;

onMounted(() => {
  timerId = setInterval(() => {
    now.value = Date.now();
  }, 1000);
});

onBeforeUnmount(() => {
  clearInterval(timerId);
});

const displayElapsed = computed(() => {
  const diff = Math.floor((now.value - startTime) / 1000);
  const h = String(Math.floor(diff / 3600)).padStart(2, '0');
  const m = String(Math.floor((diff % 3600) / 60)).padStart(2, '0');
  const s = String(diff % 60).padStart(2, '0');
  return `${h}:${m}:${s}`;
});

// 상품 데이터 (최대 3개 표시)
const products = ref([
  { id: 1, imageUrl: 'https://via.placeholder.com/180x120', productName: '상품1', discountPrice: 25000, originalPrice: 30000 },
  { id: 2, imageUrl: 'https://via.placeholder.com/180x120', productName: '상품2', discountPrice: 18000, originalPrice: 22000 },
  { id: 3, imageUrl: 'https://via.placeholder.com/180x120', productName: '상품3', discountPrice: 32000, originalPrice: 40000 },
]);

const limitedProducts = computed(() => products.value.slice(0, 3));
</script>

<style scoped>
.live-consumer {
  max-width: 900px;
  margin: 0 auto;
  padding: 24px;
  font-family: 'Noto Sans KR', sans-serif;
  color: #333;
}

.live-info-bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: #fafafa;
  padding: 12px 16px;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.05);
  margin-bottom: 16px;
  font-size: 14px;
}

.live-title { font-size: 18px; font-weight: 600; color: #2c3e50; }
.vendor-name { color: #7f8c8d; }
.viewer-count { display: flex; align-items: center; }
.viewer-number { margin-right: 4px; color: #e74c3c; font-weight: 600; }
.timer { font-weight: 500; color: #2980b9; }

.live-video-container {
  position: relative;
  width: 100%;
  padding-top: 56.25%;
  background-color: #000;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  margin-bottom: 24px;
}
.video-placeholder {
  position: absolute;
  top: 50%; left: 50%; transform: translate(-50%, -50%);
  color: #fff; font-size: 28px; font-weight: 500;
}

.products {
  display: flex;
  justify-content: space-between;
  width: 100%;
}
.product-card {
  flex: 1;
  background: #fff;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  border-radius: 8px;
  padding: 12px;
  text-align: center;
  margin-right: 16px;
}
.product-card:last-child { margin-right: 0; }

.product-image img {
  width: 100%;
  height: auto;
  border-radius: 6px;
  margin-bottom: 8px;
}

.product-name { font-size: 16px; font-weight: 600; margin-bottom: 6px; }
.price { display: flex; justify-content: center; align-items: baseline; }
.discount-price { font-size: 16px; color: #e74c3c; font-weight: 600; margin-right: 6px; }
.original-price { font-size: 14px; color: #bdc3c7; text-decoration: line-through; }
</style>
