<template>
  <div>
    <NavbarOne/>

    <div class="flex items-center gap-4 flex-wrap bg-overlay p-14 sm:p-16 before:bg-title before:bg-opacity-70" :style="{backgroundImage:'url(' +  bg  + ')'}">
      <div class="text-center w-full">
        <h2 class="text-white text-8 md:text-[40px] font-normal leading-none text-center">Order History</h2>
        <ul class="flex items-center justify-center gap-[10px] text-base md:text-lg leading-none font-normal text-white mt-3 md:mt-4">
          <li><router-link to="/">Home</router-link></li>
          <li>/</li>
          <li class="text-primary">History</li>
        </ul>
      </div>
    </div>
    <div class="container-fluid my-10">
      <div class="max-w-[600px] mx-auto bg-white dark:bg-dark-secondary rounded-xl p-6 border border-bdr-clr shadow">
        <h3 class="text-xl font-semibold mb-4">테스트 이미지 업로드</h3>

        <input type="file" @change="handleFileChange" accept="image/*" />
        <button
            class="mt-3 bg-blue-600 text-white px-4 py-2 rounded"
            :disabled="!selectedFile || uploading"
            @click="uploadImage"
        >
          업로드
        </button>

        <div v-if="uploadedUrl" class="mt-4">
          <p class="text-sm mb-2">업로드된 이미지:</p>
          <img :src="uploadedUrl" alt="업로드 이미지" class="w-40 border rounded" />
        </div>
      </div>
    </div>
    <div class="s-py-100" data-aos="fade-up">
      <div class="container-fluid">
        <div class="max-w-[1720px] mx-auto flex items-start gap-8 md:gap-12 2xl:gap-24 flex-col md:flex-row my-profile-navtab">
          <div class="w-full md:w-[200px] lg:w-[300px] flex-none">
            <ProfileTab/>
          </div>
          <div class="w-full md:w-auto md:flex-1 overflow-auto">
            <div class="bg-[#F8F8F9] dark:bg-dark-secondary p-5 sm:p-8 lg:p-[50px] order-history-table">
              <ul class="order-history">
                <li class="title flex items-center justify-between gap-5 pb-[10px] sm:pb-5 border-b border-bdr-clr dark:border-bdr-clr-drk">
                  <span class="cart-product-title text-lg md:text-xl font-semibold leading-none text-title dark:text-white block w-[270px] sm:w-[310px] xl:w-[330px]">Product</span>
                  <span class="text-lg md:text-xl font-semibold leading-none text-title dark:text-white w-[60px]">Price</span>
                  <span class="text-lg md:text-xl font-semibold leading-none text-title dark:text-white w-[100px]">Status</span>
                </li>
                <li v-for="(item, index) in cartData" :key="index" class="flex items-center justify-between gap-5 py-[15px] sm:py-[15px] border-b border-bdr-clr dark:border-bdr-clr-drk">
                  <div class="flex items-center gap-3 md:gap-4 lg:gap-6 ordered-product w-[270px] sm:w-[310px] xl:w-[330px]">
                    <div class="w-16 sm:w-[90px] flex-none">
                      <img :src="item.image" alt="product">
                    </div>
                    <div class="flex-1">
                      <span class="text-[15px] font-medium leading-none">{{item.tag}}</span>
                      <h5 class="font-semibold leading-none mt-2 md:mt-4"><router-link to="#">{{item.name}}</router-link></h5>
                    </div>
                  </div>

                  <span class="text-base md:text-lg leading-none text-title dark:text-white font-semibold text-left w-[60px]">{{item.price}}</span>

                  <div class="w-[100px]">
                    <router-link v-if="item.status === 'Completed'" to="#" class="bg-[#31A051] py-[7px] px-[10px] font-semibold leading-none text-white text-sm rounded">
                      Completed
                    </router-link>
                    <router-link v-if="item.status === 'Pending'" to="#" class="bg-[#EC991D] py-[7px] px-[10px] font-semibold leading-none text-white text-sm rounded">
                      Pending
                    </router-link>
                    <router-link v-if="item.status === 'Cancel'" to="#" class="bg-[#E13939] py-[7px] px-[10px] font-semibold leading-none text-white text-sm rounded">
                      Cancel
                    </router-link>
                  </div>
                </li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="container-fluid my-10">
      <div class="max-w-[600px] mx-auto bg-white dark:bg-dark-secondary rounded-xl p-6 border border-bdr-clr shadow">
        <h3 class="text-xl font-semibold mb-4">테스트 이미지 업로드</h3>

        <input type="file" @change="handleFileChange" accept="image/*" />
        <button
            class="mt-3 bg-blue-600 text-white px-4 py-2 rounded"
            :disabled="!selectedFile || uploading"
            @click="uploadImage"
        >
          업로드
        </button>

        <div v-if="uploadedUrl" class="mt-4">
          <p class="text-sm mb-2">업로드된 이미지:</p>
          <img :src="uploadedUrl" alt="업로드 이미지" class="w-40 border rounded" />
        </div>
      </div>
    </div>

    <FooterThree/>

    <ScrollToTop/>
  </div>
</template>

<script setup>
import { onMounted } from 'vue';
import { ref } from 'vue'
import NavbarOne from '@/components/navbar/navbar-one.vue';
import ProfileTab from '@/components/profile-tab.vue';
import FooterThree from '@/components/footer/footer-three.vue';
import ScrollToTop from '@/components/scroll-to-top.vue';
import { cartData } from '@/data/data';
import {useAuthStore} from "@/modules/auth/stores/auth";

import Aos from 'aos';
import {uploadFileToNcp} from "@/data/uploadApi";
const authStore = useAuthStore();
const userId = authStore.id

const selectedFile = ref(null)
const uploadedUrl = ref(null)
const uploading = ref(false)

const handleFileChange = (e) => {
  selectedFile.value = e.target.files[0]
}

const uploadImage = async () => {
  if (!selectedFile.value) return

  try {
    uploading.value = true
    const url = await uploadFileToNcp(selectedFile.value, userId)
    uploadedUrl.value = url
    console.log('✅ 업로드 성공:', url) // <<< 여기 url을 db에 꽂으면 됩니다.
  } catch (e) {
    console.error('❌ 업로드 실패', e)
    alert('업로드 실패')
  } finally {
    uploading.value = false
  }
}

onMounted(()=>{
  Aos.init()
})
</script>
