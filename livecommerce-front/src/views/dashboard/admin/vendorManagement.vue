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
                    <td class="px-4 py-3 text-base text-title dark:text-white">{{ vendor.status }}</td>
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
    <div class="bg-white dark:bg-dark-secondary p-8 rounded-lg max-w-2xl w-full shadow-xl">
      <h3 class="text-xl font-bold mb-4">입점업체 상세정보</h3>
      <p><strong>이름:</strong> {{ selectedVendor?.name }}</p>
      <p><strong>이메일:</strong> {{ selectedVendor?.email }}</p>

      <div class="mt-4">
        <h4 class="font-semibold">사업자 등록 정보</h4>
        <div v-if="parsedBizInfo">
          <p v-for="(value, key) in parsedBizInfo" :key="key" class="text-sm">
            <strong>{{ key }} : </strong> {{ value }}
          </p>
        </div>
        <div v-else class="text-sm text-gray-500">정보 없음</div>
      </div>

      <div class="mt-4">
        <h4 class="font-semibold">인허가 정보</h4>
        <div v-if="parsedPermitInfo">
          <p v-for="(value, key) in parsedPermitInfo" :key="key" class="text-sm">
            <strong>{{ key }} : </strong> {{ value }}
          </p>
        </div>
        <div v-else class="text-sm text-gray-500">정보 없음</div>
      </div>

      <div class="mt-6 text-right space-x-2">
        <template v-if="selectedVendor?.status !== 'APPROVED' && selectedVendor?.status !== 'REJECTED'">
          <button @click="updateVendorStatus('APPROVED')" class="px-4 py-2 bg-green-600 text-white rounded hover:bg-green-500">승인</button>
          <button @click="updateVendorStatus('REJECTED')" class="px-4 py-2 bg-red-600 text-white rounded hover:bg-red-500">반려</button>
        </template>
        <button @click="modalVisible = false" class="px-4 py-2 bg-gray-800 text-white rounded hover:bg-gray-700">닫기</button>
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
    const res = await axiosInstance.get('/admin/vendor-all');
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

    await axiosInstance.post('/admin/vendor-update', payload);
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