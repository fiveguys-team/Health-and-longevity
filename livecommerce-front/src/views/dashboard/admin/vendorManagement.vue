<template>
  <div>
    <div class="s-py-100" data-aos="fade-up">
      <div class="container-fluid">
        <div class="max-w-[1720px] mx-auto flex items-start gap-8 md:gap-12 2xl:gap-24 flex-col md:flex-row my-profile-navtab">
          <div class="w-full md:w-auto md:flex-1 overflow-auto">
            <div class="bg-white dark:bg-dark-secondary rounded-lg shadow-lg p-6">
              <h2 class="text-2xl font-bold mb-6 text-title dark:text-white">입점업체 관리</h2>
              <table class="min-w-full bg-white dark:bg-dark-secondary rounded-lg overflow-hidden">
                <thead class="bg-gray-50 dark:bg-dark-light">
                  <tr>
                    <th class="px-4 py-3 text-left text-sm font-semibold text-title dark:text-white">이름</th>
                    <th class="px-4 py-3 text-left text-sm font-semibold text-title dark:text-white">이메일</th>
                    <th class="px-4 py-3 text-left text-sm font-semibold text-title dark:text-white">사업자번호</th>
                    <th class="px-4 py-3 text-left text-sm font-semibold text-title dark:text-white">인허가번호</th>
                    <th class="px-4 py-3 text-left text-sm font-semibold text-title dark:text-white">처리상태</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="(vendor, index) in vendors" :key="index" class="border-b border-bdr-clr dark:border-bdr-clr-drk hover:bg-gray-50 dark:hover:bg-dark-light cursor-pointer" @click="fetchVendorDetails(vendor)">
                    <td class="px-4 py-3 text-base text-title dark:text-white">{{ vendor.name }}</td>
                    <td class="px-4 py-3 text-base text-title dark:text-white">{{ vendor.email }}</td>
                    <td class="px-4 py-3 text-base text-title dark:text-white">{{ vendor.businessNumber }}</td>
                    <td class="px-4 py-3 text-base text-title dark:text-white">{{ vendor.permitNumber }}</td>
                    <td class="px-4 py-3 text-base text-title dark:text-white">
                      <span
                        v-if="vendor.status === 'APPROVED'"
                        class="bg-green-100 text-green-700 px-4 py-1 rounded font-semibold text-base inline-block"
                      >승인</span>
                      <span
                        v-else-if="vendor.status === 'PENDING'"
                        class="bg-yellow-100 text-yellow-800 px-4 py-1 rounded font-semibold text-base inline-block"
                      >대기중</span>
                      <span
                        v-else-if="vendor.status === 'REJECTED'"
                        class="bg-red-100 text-red-700 px-4 py-1 rounded font-semibold text-base inline-block"
                      >반려</span>
                      <span v-else>{{ vendor.status }}</span>
                    </td>
                  </tr>
                </tbody>
              </table>

            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- 상세 정보 모달 -->
  <div v-if="modalVisible" class="fixed inset-0 bg-black bg-opacity-40 z-50 flex items-center justify-center">
    <div class="bg-white dark:bg-dark-secondary p-8 rounded-xl shadow-2xl w-full max-w-[540px] max-h-[85vh] overflow-y-auto relative">
      <h3 class="text-2xl font-bold mb-2 text-title dark:text-white">입점업체 상세정보</h3>
      <hr class="my-3 border-gray-200 dark:border-gray-700">
      <div class="mb-4 flex flex-col gap-1">
        <div class="flex items-center gap-2 text-base">
          <span class="font-semibold text-gray-700 dark:text-gray-200">이름:</span>
          <span>{{ selectedVendor?.name }}</span>
        </div>
        <div class="flex items-center gap-2 text-base">
          <span class="font-semibold text-gray-700 dark:text-gray-200">이메일:</span>
          <span>{{ selectedVendor?.email }}</span>
        </div>
      </div>
      <div class="mb-6">
        <h4 class="font-semibold text-lg mb-2 text-title dark:text-white">사업자 등록 정보</h4>
        <div v-if="parsedBizInfo">
          <table class="w-full text-sm border rounded overflow-hidden">
            <tbody>
              <tr v-for="(value, key) in parsedBizInfo" :key="key" class="border-b last:border-b-0">
                <td class="py-1 px-2 font-medium bg-gray-50 dark:bg-dark-light w-1/3">{{ key }}</td>
                <td class="py-1 px-2">{{ value }}</td>
              </tr>
            </tbody>
          </table>
        </div>
        <div v-else class="text-sm text-gray-400">정보 없음</div>
      </div>
      <div class="mb-6">
        <h4 class="font-semibold text-lg mb-2 text-title dark:text-white">인허가 정보</h4>
        <div v-if="parsedPermitInfo">
          <table class="w-full text-sm border rounded overflow-hidden">
            <tbody>
              <tr v-for="(value, key) in parsedPermitInfo" :key="key" class="border-b last:border-b-0">
                <td class="py-1 px-2 font-medium bg-gray-50 dark:bg-dark-light w-1/3">{{ key }}</td>
                <td class="py-1 px-2">{{ value }}</td>
              </tr>
            </tbody>
          </table>
        </div>
        <div v-else class="text-sm text-gray-400">정보 없음</div>
      </div>
      <div class="flex gap-4 mb-6 justify-center items-center">
        <div class="flex flex-col items-center">
          <span class="text-xs text-gray-500 mb-1">사업자등록증</span>
          <a :href="selectedVendor?.bImg" target="_blank" rel="noopener">
            <img :src="selectedVendor?.bImg || 'https://via.placeholder.com/240x160?text=No+Image'" alt="사업자등록증"
              class="w-56 h-36 object-contain border rounded bg-gray-50 shadow" />
          </a>
        </div>
        <div class="flex flex-col items-center">
          <span class="text-xs text-gray-500 mb-1">통신판매신고증</span>
          <a :href="selectedVendor?.pImg" target="_blank" rel="noopener">
            <img :src="selectedVendor?.pImg || 'https://via.placeholder.com/240x160?text=No+Image'" alt="통신판매신고증"
              class="w-56 h-36 object-contain border rounded bg-gray-50 shadow" />
          </a>
        </div>
      </div>
      <div class="flex justify-end gap-2 mt-2">
        <template v-if="selectedVendor?.status !== 'APPROVED' && selectedVendor?.status !== 'REJECTED'">
          <button @click="updateVendorStatus('APPROVED')" class="px-4 py-2 bg-green-600 text-white rounded hover:bg-green-500 transition">승인</button>
          <button @click="updateVendorStatus('REJECTED')" class="px-4 py-2 bg-red-600 text-white rounded hover:bg-red-500 transition">반려</button>
        </template>
        <button @click="modalVisible = false" class="px-4 py-2 bg-gray-800 text-white rounded hover:bg-gray-700 transition">닫기</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import axiosInstance from '@/api/axios';
import Aos from 'aos';

const vendors = ref([]);

const fetchVendors = async () => {
  try {
    const res = await axiosInstance.get('/api/admin/vendor-all');
    vendors.value = res.data;
  } catch (err) {
    console.error('Failed to load vendors:', err);
  }
};

onMounted(() => {
  fetchVendors();
  Aos.init();
});

const permitInfo = ref(null);
const bizInfo = ref(null);

const modalVisible = ref(false);
const selectedVendor = ref(null);

const fetchVendorDetails = async (vendor) => {
  selectedVendor.value = vendor;
  modalVisible.value = true;

  const brno = vendor.businessNumber;
  const permitNo = vendor.permitNumber;

  try {
    const bizRes = await fetch(
      `https://apis.data.go.kr/1130000/MllBsDtl_2Service/getMllBsInfoDetail_2?serviceKey=PTY%2F8NBCWhVCT%2FlhebNE45b8Jt0KV9pJaKwij0gQeHtEbErxkcC9aio%2FA4NmpZdZtzlhHhcI9X6D%2FAQX859pHg%3D%3D&pageNo=1&numOfRows=1&resultType=json&brno=${brno}`
    );
    const permitRes = await fetch(
      `https://openapi.foodsafetykorea.go.kr/api/058ed8873b274df3a4c4/I1290/json/1/5/LCNS_NO=${permitNo}`
    );

    bizInfo.value = await bizRes.json();
    permitInfo.value = await permitRes.json();
  } catch (err) {
    console.error('API 호출 실패:', err);
  }
};

const updateVendorStatus = async (status) => {
  try {
    const payload = {
      userId: selectedVendor.value.userId,
      status: status
    };

    if (status === 'APPROVED' && parsedPermitInfo.value) {
      payload.name = parsedPermitInfo.value.업체명;
      payload.address = parsedPermitInfo.value.주소;
    }

    await axiosInstance.post('/api/admin/vendor-update', payload);
    modalVisible.value = false;
    fetchVendors();
  } catch (err) {
    console.error('처리 상태 업데이트 실패:', err);
  }
};

const parsedBizInfo = computed(() => {
  const item = bizInfo.value?.items?.[0];
  if (!item) return null;
  return {
    업체명: item.bzmnNm,
    대표자: item.rprsvNm,
    업종: item.ntslPrdlstCn,
    주소: item.lctnRnAddr,
    상태: item.operSttusCdNm,
    등록일자: item.dclrDate
  };
});

const parsedPermitInfo = computed(() => {
  const item = permitInfo.value?.I1290?.row?.[0];
  if (!item) return null;
  return {
    업체명: item.BSSH_NM,
    대표자: item.PRSDNT_NM,
    업종: item.INDUTY_NM,
    주소: item.LOCP_ADDR,
    허가일자: item.PRMS_DT,
  };
});
</script>