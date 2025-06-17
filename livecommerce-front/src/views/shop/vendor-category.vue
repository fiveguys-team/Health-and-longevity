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

    <!-- 🟩 업체 목록 -->
    <div class="pt-20 pb-24 bg-white">
      <div class="container-fluid">
        <div
            class="max-w-6xl mx-auto grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-10"
            data-aos="fade-up"
        >
          <div
              v-for="vendor in vendorList"
              :key="vendor.vendorId"
              class="bg-white border rounded-xl shadow-md hover:shadow-xl hover:scale-105 transform transition duration-300 p-6"
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
            v-if="vendorList.length === 0"
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
import { ref, onMounted } from 'vue'
import axios from '@/utils/axios'
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
    const res = await axios.get('/product/company')
    vendorList.value = res.data
  } catch (err) {
    console.error('❌ 업체 목록 불러오기 실패', err)
  }
}
</script>
