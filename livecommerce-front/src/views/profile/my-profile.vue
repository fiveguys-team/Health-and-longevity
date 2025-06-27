<template>
    <div>
        <NavbarOne/>

        <div class="flex items-center gap-4 flex-wrap bg-overlay p-14 sm:p-16 before:bg-title before:bg-opacity-70" :style="{backgroundImage:'url(' + bg + ')'}">
            <div class="text-center w-full">
                <h2 class="text-white text-8 md:text-[40px] font-normal leading-none text-center">My Profile</h2>
                <ul class="flex items-center justify-center gap-[10px] text-base md:text-lg leading-none font-normal text-white mt-3 md:mt-4">
                    <li><router-link to="/">Home</router-link></li>
                    <li>/</li>
                    <li class="text-primary">Profile</li>
                </ul>
            </div>
        </div>

        <div class="s-py-100" data-aos="fade-up">
            <div class="container-fluid">
                <div class="max-w-[1720px] mx-auto flex items-start gap-8 md:gap-12 2xl:gap-24 flex-col md:flex-row my-profile-navtab">
                    <div class="w-full md:w-[200px] lg:w-[300px] flex-none">
                       <ProfileTab/>
                    </div>
                    <div class="w-full md:w-auto md:flex-1 overflow-auto">
                        <div class="w-full max-w-[951px] bg-[#F8F8F9] dark:bg-dark-secondary p-5 sm:p-8 lg:p-[50px] rounded-xl shadow-md">
                          <template v-if="loading">
                            <div>로딩 중...</div>
                          </template>
                          <template v-else-if="error">
                            <div class="text-red-500">{{ error }}</div>
                          </template>
                          <template v-else-if="vendorInfo">
                            <div class="mb-8">
                              <h3 class="text-xl font-bold mb-4 text-primary">사용자 정보</h3>
                              <div class="bg-white dark:bg-gray-800 rounded-lg shadow p-6 flex flex-col sm:flex-row gap-6 items-center">
                                <div class="flex-1">
                                  <div class="mb-2"><span class="font-semibold text-gray-700 dark:text-gray-200">이름:</span> {{ vendorInfo.name }}</div>
                                  <div><span class="font-semibold text-gray-700 dark:text-gray-200">이메일:</span> {{ vendorInfo.email }}</div>
                                </div>
                              </div>
                            </div>
                            <div>
                              <h3 class="text-xl font-bold mb-4 text-primary">입점 신청 정보</h3>
                              <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                                <div class="bg-white dark:bg-gray-800 rounded-lg shadow p-6 flex flex-col gap-2">
                                  <span class="text-gray-500 dark:text-gray-400 text-sm">사업자번호</span>
                                  <span class="font-semibold text-lg">{{ vendorInfo.businessNumber }}</span>
                                </div>
                                <div class="bg-white dark:bg-gray-800 rounded-lg shadow p-6 flex flex-col gap-2">
                                  <span class="text-gray-500 dark:text-gray-400 text-sm">통신판매번호</span>
                                  <span class="font-semibold text-lg">{{ vendorInfo.permitNumber }}</span>
                                </div>
                                <div class="bg-white dark:bg-gray-800 rounded-lg shadow p-6 flex flex-col gap-2">
                                  <span class="text-gray-500 dark:text-gray-400 text-sm">상태</span>
                                  <span class="font-semibold text-lg">
                                    <span v-if="vendorInfo.status === 'APPROVED'" class="text-green-600">승인</span>
                                    <span v-else-if="vendorInfo.status === 'PENDING'" class="text-yellow-600">심사중</span>
                                    <span v-else-if="vendorInfo.status === 'REJECTED'" class="text-red-600">반려</span>
                                    <span v-else>{{ vendorInfo.status }}</span>
                                  </span>
                                </div>
                                <div v-if="vendorInfo.bImg" class="bg-white dark:bg-gray-800 rounded-lg shadow p-6 flex flex-col gap-2 items-center">
                                  <span class="text-gray-500 dark:text-gray-400 text-sm">사업자등록증</span>
                                  <a :href="vendorInfo.bImg" target="_blank">
                                    <img :src="vendorInfo.bImg" alt="사업자등록증" class="w-24 h-24 object-contain rounded border" />
                                    <span class="block mt-2 text-blue-500 underline text-xs">이미지 보기</span>
                                  </a>
                                </div>
                                <div v-if="vendorInfo.pImg" class="bg-white dark:bg-gray-800 rounded-lg shadow p-6 flex flex-col gap-2 items-center">
                                  <span class="text-gray-500 dark:text-gray-400 text-sm">통신판매증</span>
                                  <a :href="vendorInfo.pImg" target="_blank">
                                    <img :src="vendorInfo.pImg" alt="통신판매증" class="w-24 h-24 object-contain rounded border" />
                                    <span class="block mt-2 text-blue-500 underline text-xs">이미지 보기</span>
                                  </a>
                                </div>
                              </div>
                            </div>
                          </template>
                          <template v-else>
                            <div>입점 신청 정보가 없습니다.</div>
                          </template>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <FooterOne/>

        <ScrollToTop/>
        
    </div>
</template>

<script setup>
import NavbarOne from '@/components/navbar/navbar-one.vue';
import bg from '@/assets/img/shortcode/breadcumb.jpg'
import { onMounted, ref } from 'vue';
import Aos from 'aos';
import ProfileTab from '@/components/profile-tab.vue';
import FooterOne from '@/components/footer/footer-one.vue';
import ScrollToTop from '@/components/scroll-to-top.vue';
import { useAuthStore } from '@/modules/auth/stores/auth';
import axiosInstance from '@/api/axios';

const authStore = useAuthStore();
const vendorInfo = ref(null);
const loading = ref(true);
const error = ref('');

onMounted(async () => {
  Aos.init();
  if (authStore.id) {
    try {
      const { data } = await axiosInstance.get('/member/vendor-info', {
        params: { userId: authStore.id }
      });
      vendorInfo.value = data;
    } catch (e) {
      error.value = '입점업체 정보 조회 실패';
    } finally {
      loading.value = false;
    }
  } else {
    loading.value = false;
  }
});
</script>
