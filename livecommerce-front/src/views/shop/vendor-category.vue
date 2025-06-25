<template>
  <div>
    <NavbarOne />


    <!-- 🟦 배경 이미지 + 타이틀 -->
    <div
        class="flex items-center gap-4 flex-wrap bg-overlay py-16 sm:py-20 before:bg-title before:bg-opacity-70"
        :style="{ backgroundImage: 'url(' + bg + ')' }"
    >
      <div class="text-center w-full">
        <h2 class="text-white text-4xl md:text-5xl font-semibold leading-none">
          업체별 목록
        </h2>
        <ul class="flex justify-center gap-2 text-base md:text-lg text-white mt-4">

        </ul>
      </div>
    </div>

    <!-- 🔍 검색창 (배경 아래, 오른쪽 정렬) -->
    <div class="container-fluid max-w-6xl mx-auto mt-8 flex justify-end items-center gap-2">
      <input
          v-model="searchInput"
          type="text"
          placeholder="업체명을 입력하세요"
          class="px-4 py-2 border rounded focus:outline-none focus:ring w-[240px]"
      />
      <button
          @click="applySearch"
          class="px-4 py-2 bg-primary text-white rounded hover:bg-opacity-80 transition"
      >
        검색
      </button>
    </div>

    <!-- 🟩 업체 목록 -->
    <div class="pt-20 pb-24 bg-white">
      <div class="max-w-[1720px] mx-auto px-4">
        <div
            class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-10" data-aos="fade-up"
        >
          <div
              v-for="vendor in filteredVendors"
              :key="vendor.vendorId"
              class="bg-white border rounded-lg shadow hover:shadow-md hover:scale-105 transform transition duration-200 p-4"
          >
            <router-link :to="`/vendor/${vendor.vendorId}/products`">
              <img
                  src="/no-image.png"
                  alt="업체 이미지"
                  class="w-full h-40 object-cover rounded mb-4"
              />
              <h3 class="text-xl font-semibold text-primary hover:underline">
                {{ vendor.name }}
              </h3>
              <span
                  v-if="vendor.status === 'PENDING'"
                  class="text-xs bg-yellow-400 text-white px-2 py-1 rounded-full mt-2 inline-block"
              >
                신규 업체
              </span>
            </router-link>
          </div>
        </div>

        <!-- ⚠️ 등록된 업체가 없는 경우 -->
        <div
            v-if="filteredVendors.length === 0"
            class="text-center text-gray-500 mt-10"
        >
          등록된 업체가 없습니다.
        </div>
      </div>
    </div>

    <FooterOne />
    <ScrollToTop />
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import axiosInstance from '@/api/axios'
import NavbarOne from '@/components/navbar/navbar-one.vue'
import FooterOne from '@/components/footer/footer-one.vue'
import ScrollToTop from '@/components/scroll-to-top.vue'
import bg from '@/assets/img/shortcode/breadcumb.jpg'

const vendorList = ref([])

onMounted(() => {
  fetchVendors()
})

async function fetchVendors() {
  try {
    const res = await axiosInstance.get('/api/product/company')
    vendorList.value = res.data
  } catch (err) {
    console.error('❌ 업체 목록 불러오기 실패', err)
  }
}

const searchInput = ref('')
const searchText = ref('') // 🔍 상태

const applySearch = () => {
  searchText.value = searchInput.value
}

const filteredVendors = computed(() => {
  const keyword = searchText.value.trim().toLowerCase()
  if (!keyword) return vendorList.value
  return vendorList.value.filter(v =>
      v.name?.toLowerCase().includes(keyword)
  )
})

</script>
