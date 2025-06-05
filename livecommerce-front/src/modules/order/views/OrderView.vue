<template>
  <div>
    <NavbarOne/>

    <div class="flex items-center gap-4 flex-wrap bg-overlay p-14 sm:p-16 before:bg-title before:bg-opacity-70"
         :style="{backgroundImage:'url(' + bg + ')'}">
      <div class="text-center w-full">
        <h2 class="text-white text-8 md:text-[40px] font-normal leading-none text-center">결제하기</h2>
        <ul class="flex items-center justify-center gap-[10px] text-base md:text-lg leading-none font-normal text-white mt-3 md:mt-4 flex-wrap">
          <li>
            <router-link to="/">홈</router-link>
          </li>
          <li>/</li>
          <li class="text-primary">결제하기</li>
        </ul>
      </div>
    </div>

    <div class="s-py-100">
      <div class="container">
        <div class="max-w-[1220px] mx-auto grid lg:grid-cols-2 gap-[30px] lg:gap-[70px]">
          <div
              class="bg-[#FAFAFA] dark:bg-dark-secondary p-[30px] md:p-[40px] lg:p-[50px] border border-[#17243026] border-opacity-15 rounded-xl"
              data-aos="fade-up">

<!--            <p class="mb-5 w-full bg-white dark:bg-dark-secondary border border-[#E3E5E6] text-title dark:text-white focus:border-primary p-4 outline-none duration-300 whitespace-normal">-->
<!--              쿠폰 코드가 있으신가요?-->
<!--              <button @click="open = !open" class="ml-1 add-coupon-code underline text-[#209A60]">추가하려면 클릭하세요</button>-->
<!--            </p>-->

            <div v-if="open" class="coupon-wrapper gap-3 md:flex mb-[30px]">
              <input
                  class="max-w-[220px] w-full h-12 md:h-14 bg-white dark:bg-dark-secondary border border-[#E3E5E6] text-title dark:text-white focus:border-primary p-4 outline-none duration-300"
                  type="text"
                  placeholder="쿠폰 코드"
              />
              <router-link to="#" class="btn btn-sm-px btn-theme-solid" data-text="쿠폰 적용">
                <span>쿠폰 적용</span>
              </router-link>
            </div>

            <h4 class="font-semibold leading-none text-xl md:text-2xl mb-6 md:mb-[30px]">
              배송지 정보
            </h4>
            <div class="grid gap-5 md:gap-6">
              <div>
                <label class="text-base md:text-lg text-title dark:text-white leading-none mb-2 sm:mb-3 block">이름</label>
                <input
                    v-model="form.name"
                    class="w-full h-12 md:h-14 bg-white dark:bg-dark-secondary border border-[#E3E5E6] text-title dark:text-white focus:border-primary p-4 outline-none duration-300"
                    type="text"
                    placeholder="이름을 입력하세요"/>
              </div>

              <div>
                <label
                    class="text-base md:text-lg text-title dark:text-white leading-none mb-2 sm:mb-3 block">이메일</label>
                <input
                    v-model="form.email"
                    class="w-full h-12 md:h-14 bg-white dark:bg-dark-secondary border border-[#E3E5E6] text-title dark:text-white focus:border-primary p-4 outline-none duration-300"
                    type="text"
                    placeholder="이메일 주소를 입력하세요"
                />
              </div>

              <div>
                <label
                    class="text-base md:text-lg text-title dark:text-white leading-none mb-2 sm:mb-3 block">전화번호</label>
                <input
                    v-model="form.phone"
                    class="w-full h-12 md:h-14 bg-white dark:bg-dark-secondary border border-[#E3E5E6] text-title dark:text-white focus:border-primary p-4 outline-none duration-300"
                    type="number"
                    placeholder="전화번호를 입력하세요"
                />
              </div>
            </div>

<!--            -->
            <!-- ── 우편번호 / 기본주소 / 상세주소 ── -->
            <div class="grid gap-5 md:gap-6 mt-5">
              <!-- 우편번호 검색 버튼 + 결과 표시 -->
              <div>
                <label
                    class="text-base md:text-lg text-title dark:text-white leading-none mb-2 sm:mb-3 block">우편번호</label>
                <div class="flex">
                  <input
                      v-model="postalCode"
                      readonly
                      class="flex-1 h-12 md:h-14 bg-white dark:bg-dark-secondary border border-[#E3E5E6] text-title dark:text-white focus:border-primary p-4 outline-none duration-300"
                      placeholder="우편번호를 선택하세요"
                  />
                  <button @click="openPostcode" class="ml-2 bg-primary text-white px-4 md:px-6 rounded-md">
                    우편번호 찾기
                  </button>
                </div>
              </div>

              <!-- 기본주소 표시 (readonly) -->
              <div>
                <label class="text-base md:text-lg text-title dark:text-white leading-none mb-2 sm:mb-3 block">기본주소</label>
                <input
                    v-model="basicAddress"
                    readonly
                    class="w-full h-12 md:h-14 bg-white dark:bg-dark-secondary border border-[#E3E5E6] text-title dark:text-white focus:border-primary p-4 outline-none duration-300"
                    placeholder="기본주소가 여기에 표시됩니다"
                />
              </div>

              <!-- 상세주소 직접 입력 -->
              <div>
                <label
                    class="text-base md:text-lg text-title dark:text-white leading-none mb-2 sm:mb-3 block"
                >상세주소</label
                >
                <input
                    id="detail-address-input"
                    v-model="form.detailAddress"
                    class="w-full h-12 md:h-14 bg-white dark:bg-dark-secondary border border-[#E3E5E6] text-title dark:text-white focus:border-primary p-4 outline-none duration-300"
                    type="text"
                    placeholder="상세주소를 입력하세요 (예: 아파트, 동/호수 등)"
                />
              </div>
            </div>

            <div class="mt-5">
              <label class="text-base md:text-lg text-title dark:text-white leading-none mb-2 sm:mb-3 block">배송 요청사항</label>
              <textarea
                  class="w-full h-[120px] bg-white dark:bg-dark-secondary border border-[#E3E5E6] text-title dark:text-white focus:border-primary p-4 outline-none duration-300"
                  name="Message"
                  placeholder="메시지를 입력하세요"
              ></textarea>
            </div>
            <div class="mt-4 flex items-center">
              <input
                  id="default-address-checkbox"
                  type="checkbox"
                  v-model="isDefaultAddress"
                  class="w-4 h-4 text-primary bg-white border border-[#E3E5E6] rounded focus:ring-primary focus:ring-2"
              />
              <label for="default-address-checkbox" class="ml-2 text-base text-title dark:text-white">
                기본배송지로 설정하기
              </label>
            </div>
          </div>

          <div data-aos="fade-up" data-aos-delay="200">
            <div
                class="bg-[#FAFAFA] dark:bg-dark-secondary pt-[30px] md:pt-[40px] lg:pt-[50px] px-[30px] md:px-[40px] lg:px-[50px] pb-[30px] border border-[#17243026] border-opacity-15 rounded-xl">
              <h4 class="font-semibold leading-none text-xl md:text-2xl mb-6 md:mb-10">
                상품 정보
              </h4>
              <div class="grid gap-5 mg:gap-6">
                <div class="flex items-center justify-between gap-5">
                  <div class="flex items-center gap-3 md:gap-4 lg:gap-6 cart-product flex-wrap">
                    <div class="w-16 sm:w-[70px] flex-none">
                      <img :src="cart1" alt="product">
                    </div>
                    <div class="flex-1">
                      <h6 class="leading-none font-medium">의자</h6>
                      <h5 class="font-semibold leading-none mt-2">
                        <router-link to="#">모던 소파 세트</router-link>
                      </h5>
                    </div>
                  </div>
                  <h6 class="leading-none">$74</h6>
                </div>
                <div class="flex items-center justify-between gap-5">
                  <div class="flex items-center gap-3 md:gap-4 lg:gap-6 cart-product flex-wrap">
                    <div class="w-16 sm:w-[70px] flex-none">
                      <img :src="cart2" alt="product">
                    </div>
                    <div class="flex-1">
                      <h6 class="leading-none font-medium">인테리어</h6>
                      <h5 class="font-semibold leading-none mt-2">
                        <router-link to="#">꽃병이 있는 의자</router-link>
                      </h5>
                    </div>
                  </div>
                  <h6 class="leading-none">$124</h6>
                </div>
                <div class="flex items-center justify-between gap-5">
                  <div class="flex items-center gap-3 md:gap-4 lg:gap-6 cart-product flex-wrap">
                    <div class="w-16 sm:w-[70px] flex-none">
                      <img :src="cart3" alt="product">
                    </div>
                    <div class="flex-1">
                      <h6 class="leading-none font-medium">조명 / 램프</h6>
                      <h5 class="font-semibold leading-none mt-2">
                        <router-link to="#">행잉 램프</router-link>
                      </h5>
                    </div>
                  </div>
                  <h6 class="leading-none">$241</h6>
                </div>
              </div>
              <div
                  class="mt-6 pt-6 border-t border-bdr-clr dark:border-bdr-clr-drk text-right flex justify-end flex-col w-full ml-auto mr-0">
                <div class="flex justify-between flex-wrap text-base sm:text-lg text-title dark:text-white font-medium">
                  <span>총 주문 금액:</span>
                  <span>150,000원</span>
                </div>
                <div
                    class="flex justify-between flex-wrap text-base sm:text-lg text-title dark:text-white font-medium mt-3">
                  <span>배송비:</span>
                  <span>0</span>
                </div>
                <div
                    class="flex justify-between flex-wrap text-base sm:text-lg text-title dark:text-white font-medium mt-3">
                  <span>총 할인 금액:</span>
                  <span>-20,000원</span>
                </div>
              </div>
              <div class="mt-6 pt-6 border-t border-bdr-clr dark:border-bdr-clr-drk">
                <div class="flex justify-between flex-wrap font-semibold leading-none text-2xl md:text-3xl">
                  <span>총 결제 금액:</span>
                  <span>130,000원</span>
                </div>
              </div>
            </div>
            <div class="mt-7 md:mt-12">
<!--              <h4 class="font-semibold leading-none text-xl md:text-2xl mb-6 md:mb-10">결제 방법</h4>-->
              <div class="wrapper">
                <div class="box_section">
                  <!-- 결제 UI -->
                  <div id="payment-method"></div>
                  <!-- 이용약관 UI -->
                  <div id="agreement"></div>
                </div>
              </div>
              <div class="mt-4 md:mt-6 flex flex-wrap gap-3">
                <router-link to="#" class="btn btn-outline" data-text="장바구니로 돌아가기"><span>장바구니로 돌아가기</span></router-link>
                <button
                    :disabled="!ready"
                    @click="requestPayment"
                    class="btn btn-theme-solid"
                    data-text="결제하기">
                  <span>결제하기</span>
                </button>

              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <FooterThree/>
    <ScrollToTop/>
  </div>
</template>

<script setup>
import { ref, reactive, watch, onMounted } from "vue";
import { loadTossPayments } from "@tosspayments/tosspayments-sdk";
import NavbarOne from '@/components/navbar/navbar-one.vue';
import FooterThree from '@/components/footer/footer-three.vue';
import ScrollToTop from '@/components/scroll-to-top.vue';
import 'swiper/swiper-bundle.css';
import Aos from 'aos';
import 'aos/dist/aos.css';
import bg from "@/assets/img/shortcode/breadcumb.jpg";
import cart1 from "@/assets/img/gallery/cart/cart-01.jpg";
import cart2 from "@/assets/img/gallery/cart/cart-02.jpg";
import cart3 from "@/assets/img/gallery/cart/cart-03.jpg";

function generateRandomString() {
  return window.btoa(Math.random().toString()).slice(0, 20);
}


// ─── 1. ‘배송지’ 폼 데이터 (reactive 객체) ───
const form = reactive({
  name: "",
  email: "",
  phone: "",
  detailAddress: "",
  note: "",
});

const postalCode = ref("");
const basicAddress = ref("");

// “기본배송지로 설정” 여부
const isDefaultAddress = ref(false);

function openPostcode() {
  // window.daum.Postcode 객체가 로드되어 있어야 함
  new window.daum.Postcode({
    oncomplete(data) {
      // data.zonecode: 5자리 우편번호
      // data.address: 기본주소 (도로명 또는 지번)
      postalCode.value = data.zonecode;
      basicAddress.value = data.address;

      // 상세주소 입력칸으로 포커스 이동
      const detailInput = document.getElementById("detail-address-input");
      if (detailInput) {
        detailInput.focus();
      }
    }
  }).open();
}

// TODO: 개발자센터에서 발급받은 결제 위젯 연동용 Client Key로 변경하세요.
const clientKey = "test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm";
// TODO: 실제 서비스에서는 로그인한 사용자의 고유 ID(예: userId) 등을 넣어야 합니다.
const customerKey = generateRandomString();

// ─── 반응형 상태 정의 ───
const ready = ref(false);
const widgets = ref(null);

// 금액, 통화 정보
const amount = reactive({
  currency: "KRW",
  value: 50000,
});

async function fetchPaymentWidgets() {
  try {
    // TossPayments SDK 초기화
    const tossPayments = await loadTossPayments(clientKey);

    // ─── 회원 결제를 위한 위젯 생성 (로그인한 사용자의 식별키인 customerKey 사용) ───
    widgets.value = tossPayments.widgets({ customerKey });

    // ─── 비회원 결제를 원하실 경우 아래처럼 변경하여 사용하세요. ───
    // widgets.value = tossPayments.widgets({ customerKey: ANONYMOUS });
  } catch (error) {
    console.error("Error fetching payment widget:", error);
  }
}

async function renderPaymentWidgets() {
  if (!widgets.value) return;

  try {
    // 1) 위젯에 주문 금액 세팅 (renderPaymentMethods, renderAgreement 호출 전에 반드시 설정해야 함)
    await widgets.value.setAmount(amount);

    // 2) 결제 UI와 약관 UI 동시 렌더링
    await Promise.all([
      // ─── 결제 수단 UI 렌더링 ───
      widgets.value.renderPaymentMethods({
        selector: "#payment-method", // template의 <div id="payment-method">와 일치해야 함
        variantKey: "DEFAULT",
      }),
      // ─── 이용약관 UI 렌더링 ───
      widgets.value.renderAgreement({
        selector: "#agreement",      // template의 <div id="agreement">와 일치해야 함
        variantKey: "AGREEMENT",
      }),
    ]);

    ready.value = true;
  } catch (error) {
    console.error("Error rendering payment widgets:", error);
  }
}

async function requestPayment() {
  if (!widgets.value || !ready.value) return;

  try {
    // 결제 요청 전, 서버에 orderId와 amount를 저장/검증하는 로직이 선행되어야 안전합니다.
    await widgets.value.requestPayment({
      orderId: generateRandomString(),                   // 고유 주문 번호 (서버와 일치해야 함)
      orderName: "토스 티셔츠 외 2건",                     // 결제창에 표시될 상품명
      successUrl: `${window.location.origin}/payment-success`, // 결제 성공 후 리디렉트 URL
      failUrl: `${window.location.origin}/payment-failure`,              // 결제 실패 후 리디렉트 URL
      customerEmail: "customer123@gmail.com",
      customerName: "김토스",
      // 가상계좌나 퀵이체 휴대폰 자동완성을 위해 필요한 경우 활성화하세요.
      // customerMobilePhone: "01012341234",
    });
  } catch (error) {
    console.error("Error requesting payment:", error);
  }
}

onMounted(() => {
  Aos.init();
});

// 컴포넌트 마운트 시 결제 위젯 초기화 & 렌더링
onMounted(async () => {
  await fetchPaymentWidgets();
  await renderPaymentWidgets();
});

watch(isDefaultAddress, (newVal) => {
  console.log("기본배송지 설정 여부:", newVal);
  // 실제로는 이 시점에 서버 API 호출 → 폼 데이터(form + newVal) 전송
});

</script>
