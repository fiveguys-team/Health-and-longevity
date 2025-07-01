<template>
  <div>
    <NavbarOne />

    <div class="flex items-center gap-4 flex-wrap bg-overlay p-14 sm:p-16 before:bg-title before:bg-opacity-70"
      :style="{ backgroundImage: 'url(' + bg + ')' }">
      <div class="text-center w-full">
        <h2 class="text-white text-8 md:text-[40px] font-normal leading-none text-center">입점 신청</h2>
        <ul
          class="flex items-center justify-center gap-[10px] text-base md:text-lg leading-none font-normal text-white mt-3 md:mt-4">

        </ul>
      </div>
    </div>

    <div class="s-pb-100 s-pt-100">
      <div class="container-fluid">
        <div class="max-w-[800px] mx-auto bg-white rounded-lg shadow p-8">
          <h2 class="text-2xl font-bold mb-6">판매자 정보입력</h2>
          <!-- 안내 영역 -->
          <div class="bg-gray-50 border border-gray-200 rounded p-4 mb-6">
            <div class="flex items-start gap-2 mb-2">
              <div>
                <b>무병건강 입점 전에 준비해주세요!</b><br>
                사업자등록증 및 통신판매업신고증은 입점 전에 미리 준비해주세요.
              </div>
            </div>
          </div>
          <!-- 기본정보 폼 -->
          <form @submit.prevent="onSubmit">
            <div class="border rounded-lg p-6 bg-white">
              <div class="flex items-center justify-between mb-4">
                <h3 class="font-bold text-lg">기본정보</h3>
                <button type="button" class="text-2xl">⌄</button>
              </div>
              <!-- 사업자등록번호 -->
              <div class="mb-4">
                <label class="block font-medium mb-1">사업자등록번호</label>
                <div class="flex gap-2 items-center">
                  <input v-model="businessNumber" type="text" maxlength="10" placeholder="'-'없이 입력"
                    class="flex-1 border rounded px-3 py-2"
                    @input="businessNumber = businessNumber.replace(/\D/g, '').slice(0, 10)">
                  <button type="button" class="border px-4 py-2 rounded text-blue-600 border-blue-400 text-sm"
                    @click="fetchBizInfo">인증하기</button>
                </div>
                <div v-if="bizInfoError" class="text-red-500 text-sm mt-1">{{ bizInfoError }}</div>
              </div>
              <!-- 건강기능식품판매업 인허가번호 -->
              <div class="mb-4">
                <label class="block font-medium mb-1">건강기능식품판매업 인허가번호</label>
                <div class="flex gap-2 items-center">
                  <input v-model="permitNumber" type="text" maxlength="11" placeholder="인허가번호 11자리 입력"
                    class="flex-1 border rounded px-3 py-2"
                    @input="permitNumber = permitNumber.replace(/\D/g, '').slice(0, 11)">
                  <button type="button" class="border px-4 py-2 rounded text-blue-600 border-blue-400 text-sm"
                    @click="fetchPermitInfo">인증하기</button>
                </div>
                <div v-if="permitInfoError" class="text-red-500 text-sm mt-1">{{ permitInfoError }}</div>
              </div>
              <!-- 상호 -->
              <div class="mb-4">
                <label class="block font-medium mb-1">상호</label>
                <input v-model="companyName" type="text" placeholder="상호" class="w-full border rounded px-3 py-2"
                  readonly>
              </div>
              <!-- 대표자 명 -->
              <div class="mb-4">
                <label class="block font-medium mb-1">대표자 명</label>
                <input v-model="ceoName" type="text" placeholder="대표자 명" class="w-full border rounded px-3 py-2"
                  readonly>
              </div>
              <!-- 사업장 주소 -->
              <div class="mb-4">
                <label class="block font-medium mb-1">사업장 주소</label>
                <input v-model="address1" type="text" placeholder="사업장 주소" class="w-full border rounded px-3 py-2 mb-2"
                  readonly>
              </div>
            </div>
            <!-- 서류첨부 안내 및 파일 업로드 UI -->
            <div class="mt-12 mb-8">
              <h3 class="font-bold text-lg mb-2">서류첨부</h3>
              <ul class="text-sm text-gray-700 mb-4">
                <li>- 첨부 서류와 입력 정보가 일치해야 승인됩니다.</li>
                <li>- 첨부 서류는 서류 내용 전체가 확인되는 선명한 고해상도의 이미지를 첨부해 주세요.</li>
              </ul>
              <div class="flex flex-col gap-6">
                <div class="flex items-center gap-4">
                  <label class="w-32 font-medium">사업자등록증</label>
                  <input type="file" accept="image/*" @change="e => onFileChange(e, 'biz')" class="hidden"
                    id="bizFileInput">
                  <label for="bizFileInput"
                    class="border px-8 py-2 rounded cursor-pointer text-center bg-white">첨부하기</label>
                  <div v-if="bizImageUrl" class="ml-4"><img :src="bizImageUrl" alt="사업자등록증 미리보기"
                      class="max-h-20 border" /></div>
                </div>
                <div class="flex items-center gap-4">
                  <label class="w-32 font-medium">통신판매신고증</label>
                  <input type="file" accept="image/*" @change="e => onFileChange(e, 'online')" class="hidden"
                    id="onlineFileInput">
                  <label for="onlineFileInput"
                    class="border px-8 py-2 rounded cursor-pointer text-center bg-white">첨부하기</label>
                  <div v-if="onlineImageUrl" class="ml-4"><img :src="onlineImageUrl" alt="통신판매신고증 미리보기"
                      class="max-h-20 border" /></div>
                </div>
                <div class="flex items-center gap-4">
                  <label class="w-32 font-medium">업체사진</label>
                  <input type="file" accept="image/*" @change="e => onFileChange(e, 'shop')" class="hidden"
                    id="shopFileInput">
                  <label for="shopFileInput"
                    class="border px-8 py-2 rounded cursor-pointer text-center bg-white">첨부하기</label>
                  <div v-if="shopImageUrl" class="ml-4"><img :src="shopImageUrl" alt="업체사진 미리보기"
                      class="max-h-20 border" /></div>
                </div>
              </div>
            </div>
            <!-- 하단 버튼 -->
            <div class="flex justify-center mt-8">
              <button type="submit" class="bg-gray-400 text-white px-6 py-2 rounded"
                :disabled="!canSubmit">제출하기</button>
            </div>
          </form>
        </div>
      </div>
    </div>

    <FooterOne />

    <ScrollToTop />

  </div>
</template>

<script setup>
import NavbarOne from '@/components/navbar/navbar-one.vue';
import bg from '@/assets/img/shortcode/breadcumb.jpg'

import { onMounted, ref, computed } from 'vue';
import Aos from 'aos';
import FooterOne from '@/components/footer/footer-one.vue';
import ScrollToTop from '@/components/scroll-to-top.vue';
import axiosInstance from "@/api/axios";
import { useAuthStore } from "@/modules/auth/stores/auth";
import { uploadFileToNcp } from '@/data/uploadApi.js';
import { useRouter } from 'vue-router';

const authStore = useAuthStore()
const businessNumber = ref("")
const permitNumber = ref("")
const ceoName = ref("")
const companyName = ref("")
const address1 = ref("")
const bizInfoError = ref("")
const permitInfoError = ref("")
const canSubmit = computed(() => {
  return (
    businessNumber.value.length === 10 &&
    companyName.value &&
    ceoName.value &&
    address1.value &&
    permitNumber.value.length === 11 &&
    bizImageUrl.value &&
    onlineImageUrl.value &&
    shopImageUrl.value
  );
});
const bizImage = ref(null);
const bizImageUrl = ref('');
const onlineImage = ref(null);
const onlineImageUrl = ref('');
const shopImage = ref(null);
const shopImageUrl = ref('');

const router = useRouter();

onMounted(() => {
  Aos.init()
})

const vendorRegistration = async () => {
  if (businessNumber.value.length !== 10 || permitNumber.value.length !== 11) {
    alert("사업자등록번호는 10자리, 인허가번호는 11자리 숫자로 입력해주세요.");
    return;
  }

  // 서버에서 현재 사용자의 입점 상태 확인
  const { data: vendorStatus } = await axiosInstance.get(`/api/member/vendor-status?userId=${authStore.id}`);
  console.log('userId:', authStore.id, 'vendorStatus:', vendorStatus);
  if (vendorStatus && vendorStatus !== "REJECTED") {
    alert("이미 입점 신청 중이거나 승인된 업체입니다.");
    return;
  }

  const registrationData = {
    userId: authStore.id,
    name: companyName.value,
    address: address1.value,
    businessNumber: businessNumber.value,
    permitNumber: permitNumber.value,
    vendorImg: shopImageUrl.value,
    bImg: bizImageUrl.value,
    pImg: onlineImageUrl.value
  };

  await axiosInstance.post("/api/member/vendor-registration", registrationData);
};

const fetchBizInfo = async () => {
  bizInfoError.value = '';
  if (businessNumber.value.length !== 10) {
    bizInfoError.value = '사업자등록번호 10자리를 입력하세요.';
    ceoName.value = '';
    companyName.value = '';
    address1.value = '';
    return;
  }
  try {
    const res = await fetch(
      `https://apis.data.go.kr/1130000/MllBsDtl_2Service/getMllBsInfoDetail_2?serviceKey=PTY%2F8NBCWhVCT%2FlhebNE45b8Jt0KV9pJaKwij0gQeHtEbErxkcC9aio%2FA4NmpZdZtzlhHhcI9X6D%2FAQX859pHg%3D%3D&pageNo=1&numOfRows=1&resultType=json&brno=${businessNumber.value}`
    );
    const data = await res.json();
    const item = data?.items?.[0];
    if (item) {
      ceoName.value = item.rprsvNm || '';
      companyName.value = item.bzmnNm || '';
      address1.value = item.lctnAddr || '';
      bizInfoError.value = '';
    } else {
      bizInfoError.value = '사업자 정보를 찾을 수 없습니다.';
      ceoName.value = '';
      companyName.value = '';
      address1.value = '';
    }
  } catch (e) {
    bizInfoError.value = '사업자 정보 조회 실패';
    ceoName.value = '';
    companyName.value = '';
    address1.value = '';
  }
};

const onFileChange = async (e, type) => {
  const file = e.target.files[0];
  if (!file) return;
  if (file.size > 5 * 1024 * 1024) {
    alert('5MB 이하의 이미지만 첨부 가능합니다.');
    return;
  }
  if (!file.type.startsWith('image/')) {
    alert('이미지 파일만 첨부 가능합니다.');
    return;
  }
  let uploadedUrl = '';
  try {
    uploadedUrl = await uploadFileToNcp(file, authStore.id);
    console.log('uploadedUrl:', uploadedUrl);
  } catch (err) {
    alert('이미지 업로드에 실패했습니다.');
    return;
  }
  if (type === 'biz') {
    bizImage.value = file;
    bizImageUrl.value = uploadedUrl;
  } else if (type === 'online') {
    onlineImage.value = file;
    onlineImageUrl.value = uploadedUrl;
  } else if (type === 'shop') {
    shopImage.value = file;
    shopImageUrl.value = uploadedUrl;
  }
};

const fetchPermitInfo = async () => {
  permitInfoError.value = '';
  if (permitNumber.value.length !== 11) {
    permitInfoError.value = '인허가번호 11자리를 입력하세요.';
    return;
  }
  try {
    const res = await fetch(
      `https://openapi.foodsafetykorea.go.kr/api/058ed8873b274df3a4c4/I1290/json/1/5/LCNS_NO=${permitNumber.value}`
    );
    const data = await res.json();
    const item = data?.I1290?.row?.[0];
    if (item) {
      companyName.value = item.BSSH_NM || companyName.value;
      address1.value = item.LOCP_ADDR || address1.value;
      permitInfoError.value = '';
    } else {
      permitInfoError.value = '인허가 정보를 찾을 수 없습니다.';
    }
  } catch (e) {
    permitInfoError.value = '인허가 정보 조회 실패';
  }
};

const onSubmit = async (event) => {
  event?.preventDefault?.();
  if (canSubmit.value) {
    try {
      await vendorRegistration();
      alert("신청이 완료되었습니다.");
      router.push('/my-profile');
    } catch (error) {
      console.error('입점 신청 실패:', error);
      alert("입점 신청에 실패했습니다. 다시 시도해주세요.");
    }
  }
};

</script>