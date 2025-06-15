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

    <!-- Body: Video + Products and Chat Side by Side -->
    <div class="live-body">
      <!-- Left: Video and Products -->
      <div class="main-content">
        <!-- Video Area -->
        <div class="live-video-container">
          <div class="video-placeholder">라이브</div>
        </div>

        <!-- Products Display (1-3개) -->
        <div class="products">
          <div
              class="product-card"
              v-for="item in limitedProducts"
              :key="item.id"
          >
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

      <!-- Right: Chat Area -->
      <div class="chat-area">
        <chat-container />
      </div>
    </div>
  </div>
</template>

<script setup>
import {ref, computed, onMounted, onBeforeUnmount} from 'vue';
import ChatContainer from '@/modules/chat/components/ChatContainer.vue';

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
  {
    id: 1,
    imageUrl: 'https://via.placeholder.com/180x120',
    productName: '상품1',
    discountPrice: 25000,
    originalPrice: 30000
  },
  {
    id: 2,
    imageUrl: 'https://via.placeholder.com/180x120',
    productName: '상품2',
    discountPrice: 18000,
    originalPrice: 22000
  },
  {
    id: 3,
    imageUrl: 'https://via.placeholder.com/180x120',
    productName: '상품3',
    discountPrice: 32000,
    originalPrice: 40000
  },
]);
const limitedProducts = computed(() => products.value.slice(0, 3));
</script>

<style scoped>
.live-consumer {
  width: 100%;
  max-width: 1400px;
  margin: 0 auto;
  padding: 24px;
  box-sizing: border-box;
  font-family: 'Noto Sans KR', sans-serif;
  color: #333;
  height: 100vh;
  display: flex;
  flex-direction: column;
}

.live-info-bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: #fafafa;
  padding: 12px 16px;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
  margin-bottom: 16px;
  font-size: 14px;
}

.live-title {
  font-size: 18px;
  font-weight: 600;
  color: #2c3e50;
}

.vendor-name {
  color: #7f8c8d;
}

.viewer-count {
  display: flex;
  align-items: center;
}

.viewer-number {
  margin-right: 4px;
  color: #e74c3c;
  font-weight: 600;
}

.timer {
  font-weight: 500;
  color: #2980b9;
}

/* Flex container for main and chat */
.live-body {
  display: flex;
  gap: 24px;
  flex: 1;
  min-height: 0;
}

.main-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  min-height: 0;
}

/* Use aspect-ratio for consistent video sizing */
.live-video-container {
  position: relative;
  width: 100%;
  aspect-ratio: 16 / 9;
  background-color: #000;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  margin-bottom: 16px;
}

.video-placeholder {
  position: absolute;
  inset: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  font-size: 28px;
  font-weight: 500;
}

/* Products below video */
.products {
  display: flex;
  gap: 16px;
  flex: 1;
  margin-top: 30px;
}

.product-card {
  flex: 1;
  background: #fff;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  border-radius: 8px;
  padding: 12px;
  text-align: center;
  height: fit-content;
}

.product-image img {
  width: 100%;
  height: auto;
  border-radius: 6px;
  margin-bottom: 8px;
}

.product-name {
  font-size: 16px;
  font-weight: 600;
  margin-bottom: 6px;
}

.price {
  display: flex;
  justify-content: center;
  align-items: baseline;
}

.discount-price {
  font-size: 16px;
  color: #e74c3c;
  font-weight: 600;
  margin-right: 6px;
}

.original-price {
  font-size: 14px;
  color: #bdc3c7;
  text-decoration: line-through;
}

/* Chat area - 전체 높이를 꽉 차도록 수정 */
.chat-area {
  width: 350px;
  display: flex;
  flex-direction: column;
  height: 100%;
  min-height: 0;
}

/* ChatContainer가 chat-area 전체 높이를 차지하도록 */
.chat-area :deep(chat-container) {
  height: 100%;
  display: flex;
  flex-direction: column;
}

/* Responsive Breakpoints */
@media (max-width: 1024px) {
  .live-body {
    flex-direction: column;
  }

  .chat-area {
    width: 100%;
    height: 400px;
    margin-top: 24px;
  }

  .products {
    flex-wrap: wrap;
  }

  .product-card {
    flex: 1 1 calc(50% - 16px);
    margin-bottom: 16px;
  }
}

@media (max-width: 600px) {
  .live-info-bar {
    flex-direction: column;
    align-items: flex-start;
    gap: 8px;
  }

  .live-info-bar > * {
    width: 100%;
  }

  .product-card {
    flex: 1 1 100%;
  }

  .chat-area {
    height: 300px;
  }
}
</style>