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

            <p class="mb-5 w-full bg-white dark:bg-dark-secondary border border-[#E3E5E6] text-title dark:text-white focus:border-primary p-4 outline-none duration-300 whitespace-normal">
              쿠폰 코드가 있으신가요?
              <button @click="open = !open" class="ml-1 add-coupon-code underline text-[#209A60]">추가하려면 클릭하세요</button>
            </p>

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
              청구 정보
            </h4>
            <div class="grid gap-5 md:gap-6">
              <div>
                <label
                    class="text-base md:text-lg text-title dark:text-white leading-none mb-2 sm:mb-3 block">이름</label>
                <input
                    class="w-full h-12 md:h-14 bg-white dark:bg-dark-secondary border border-[#E3E5E6] text-title dark:text-white focus:border-primary p-4 outline-none duration-300"
                    type="text"
                    placeholder="이름을 입력하세요"
                />
              </div>

              <div>
                <label
                    class="text-base md:text-lg text-title dark:text-white leading-none mb-2 sm:mb-3 block">이메일</label>
                <input
                    class="w-full h-12 md:h-14 bg-white dark:bg-dark-secondary border border-[#E3E5E6] text-title dark:text-white focus:border-primary p-4 outline-none duration-300"
                    type="text"
                    placeholder="이메일 주소를 입력하세요"
                />
              </div>

              <div>
                <label
                    class="text-base md:text-lg text-title dark:text-white leading-none mb-2 sm:mb-3 block">전화번호</label>
                <input
                    class="w-full h-12 md:h-14 bg-white dark:bg-dark-secondary border border-[#E3E5E6] text-title dark:text-white focus:border-primary p-4 outline-none duration-300"
                    type="number"
                    placeholder="전화번호를 입력하세요"
                />
              </div>
            </div>

            <div class="grid md:grid-cols-2 gap-5 md:gap-6">
              <div class="mt-5">
                <label
                    class="text-base md:text-lg text-title dark:text-white leading-none mb-2 sm:mb-3 block">도/시</label>
                <select class="nice-select select-active p-4 !bg-white dark:!bg-dark-secondary">
                  <option value="1">Sylht</option>
                  <option value="2">Dhaka</option>
                  <option value="2">Chittagong</option>
                  <option value="2">Rajshahi</option>
                  <option value="2">Bogura</option>
                </select>
              </div>

              <div class="mt-5">
                <label
                    class="text-base md:text-lg text-title dark:text-white leading-none mb-2 sm:mb-3 block">우편번호</label>
                <input
                    class="w-full h-12 md:h-14 bg-white dark:bg-dark-secondary border border-[#E3E5E6] text-title dark:text-white focus:border-primary p-4 outline-none duration-300"
                    type="text"
                    placeholder="우편번호를 입력하세요"
                />
              </div>

              <div>
                <label class="text-base md:text-lg text-title dark:text-white leading-none mb-2 sm:mb-3 block">주소
                  1</label>
                <input
                    class="w-full h-12 md:h-14 bg-white dark:bg-dark-secondary border border-[#E3E5E6] text-title dark:text-white focus:border-primary p-4 outline-none duration-300"
                    type="text"
                    placeholder="주소를 입력하세요"
                />
              </div>

              <div>
                <label class="text-base md:text-lg text-title dark:text-white leading-none mb-2 sm:mb-3 block">주소
                  2</label>
                <input
                    class="w-full h-12 md:h-14 bg-white dark:bg-dark-secondary border border-[#E3E5E6] text-title dark:text-white focus:border-primary p-4 outline-none duration-300"
                    type="text"
                    placeholder="주소를 입력하세요"
                />
              </div>
            </div>
            <div class="mt-5">
              <label class="text-base md:text-lg text-title dark:text-white leading-none mb-2 sm:mb-3 block">추가
                메모</label>
              <textarea
                  class="w-full h-[120px] bg-white dark:bg-dark-secondary border border-[#E3E5E6] text-title dark:text-white focus:border-primary p-4 outline-none duration-300"
                  name="Message"
                  placeholder="메시지를 입력하세요"
              ></textarea>
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
                  <span>소계:</span>
                  <span>$870</span>
                </div>
                <div
                    class="flex justify-between flex-wrap text-base sm:text-lg text-title dark:text-white font-medium mt-3">
                  <span>쿠폰 할인:</span>
                  <span>-$20</span>
                </div>
                <div
                    class="flex justify-between flex-wrap text-base sm:text-lg text-title dark:text-white font-medium mt-3">
                  <span>부가세:</span>
                  <span>$5</span>
                </div>
              </div>
              <div class="mt-6 pt-6 border-t border-bdr-clr dark:border-bdr-clr-drk">
                <div
                    class="flex justify-between flex-wrap text-base sm:text-lg text-title dark:text-white font-medium mt-3">
                  <div>
                    <label class="flex items-center gap-[10px] categoryies-iteem">
                      <input class="appearance-none hidden" type="radio" name="item-type">
                      <span
                          class="w-4 h-4 rounded-full border border-title dark:border-white flex items-center justify-center duration-300">
                            <svg class="duration-300 opacity-0" width="8" height="8" viewBox="0 0 10 10" fill="none"
                                 xmlns="http://www.w3.org/2000/svg">
                              <rect width="10" height="10" rx="5" fill="#BB976D"/>
                            </svg>
                          </span>
                      <span
                          class="sm:text-lg text-title dark:text-white block sm:leading-none transform translate-y-[3px] select-none">무료 배송:</span>
                    </label>
                  </div>
                  <span>$0</span>
                </div>
                <div
                    class="flex justify-between flex-wrap text-base sm:text-lg text-title dark:text-white font-medium mt-3">
                  <div>
                    <label class="flex items-center gap-[10px] categoryies-iteem">
                      <input class="appearance-none hidden" type="radio" name="item-type">
                      <span
                          class="w-4 h-4 rounded-full border border-title dark:border-white flex items-center justify-center duration-300">
                            <svg class="duration-300 opacity-0" width="8" height="8" viewBox="0 0 10 10" fill="none"
                                 xmlns="http://www.w3.org/2000/svg">
                              <rect width="10" height="10" rx="5" fill="#BB976D"/>
                            </svg>
                          </span>
                      <span
                          class="sm:text-lg text-title dark:text-white block sm:leading-none transform translate-y-[3px] select-none">빠른 배송:</span>
                    </label>
                  </div>
                  <span>$10</span>
                </div>
                <div
                    class="flex justify-between flex-wrap text-base sm:text-lg text-title dark:text-white font-medium mt-3">
                  <div>
                    <label class="flex items-center gap-[10px] categoryies-iteem">
                      <input class="appearance-none hidden" type="radio" name="item-type">
                      <span
                          class="w-4 h-4 rounded-full border border-title dark:border-white flex items-center justify-center duration-300">
                            <svg class="duration-300 opacity-0" width="8" height="8" viewBox="0 0 10 10" fill="none"
                                 xmlns="http://www.w3.org/2000/svg">
                              <rect width="10" height="10" rx="5" fill="#BB976D"/>
                            </svg>
                          </span>
                      <span
                          class="sm:text-lg text-title dark:text-white block sm:leading-none transform translate-y-[3px] select-none">매장 픽업:</span>
                    </label>
                  </div>
                  <span>$15</span>
                </div>
              </div>
              <div class="mt-6 pt-6 border-t border-bdr-clr dark:border-bdr-clr-drk">
                <div class="flex justify-between flex-wrap font-semibold leading-none text-2xl md:text-3xl">
                  <span>합계:</span>
                  <span>$850</span>
                </div>
              </div>
            </div>
            <div class="mt-7 md:mt-12">
              <h4 class="font-semibold leading-none text-xl md:text-2xl mb-6 md:mb-10">결제 방법</h4>
              <div class="wrapper">
                <div class="box_section">
                  <!-- 결제 UI -->
                  <div id="payment-method"></div>

                  <!-- 이용약관 UI -->
                  <div id="agreement"></div>

                </div>

                <!-- 결제하기 버튼 -->
                <button
                    :disabled="!ready"
                    @click="requestPayment"
                    class="button"
                    style="margin-top: 30px"
                >
                  결제하기
                </button>
              </div>

              <div class="mt-6 sm:mt-8 md:mt-10">
                <label class="flex items-center gap-2 iam-agree">
                  <input class="appearance-none hidden" type="checkbox" name="categories">
                  <span
                      class="w-6 h-6 rounded-[5px] border-2 border-title dark:border-white flex items-center justify-center duration-300">
                        <svg class="duration-300 opacity-0 text-title dark:text-white fill-current" width="15"
                             height="12" viewBox="0 0 20 15" fill="none" xmlns="http://www.w3.org/2000/svg">
                          <path
                              d="M18.3819 0.742676L6.10461 11.8998L2.25731 8.06381L0.763672 9.55745L6.20645 15.0002L20 2.32686L18.3819 0.742676Z"/>
                        </svg>
                      </span>
                  <span
                      class="text-base sm:text-lg text-title dark:text-white leading-none sm:leading-none select-none inline-block transform translate-y-[3px]">모든 약관에 동의합니다</span>
                </label>
              </div>
              <div class="mt-4 md:mt-6 flex flex-wrap gap-3">
                <router-link to="#" class="btn btn-outline" data-text="장바구니로 돌아가기"><span>장바구니로 돌아가기</span></router-link>
                <router-link to="#" class="btn btn-theme-solid" data-text="주문하기"><span>주문하기</span></router-link>

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
import { onMounted } from 'vue';

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


onMounted(() => {
  Aos.init();
});

import { ref, reactive } from "vue";
import { loadTossPayments } from "@tosspayments/tosspayments-sdk";

function generateRandomString() {
  return window.btoa(Math.random().toString()).slice(0, 20);
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
      successUrl: `${window.location.origin}/widget/success`, // 결제 성공 후 리디렉트 URL
      failUrl: `${window.location.origin}/fail`,              // 결제 실패 후 리디렉트 URL
      customerEmail: "customer123@gmail.com",
      customerName: "김토스",
      // 가상계좌나 퀵이체 휴대폰 자동완성을 위해 필요한 경우 활성화하세요.
      // customerMobilePhone: "01012341234",
    });
  } catch (error) {
    console.error("Error requesting payment:", error);
  }
}

// 컴포넌트 마운트 시 결제 위젯 초기화 & 렌더링
onMounted(async () => {
  await fetchPaymentWidgets();
  await renderPaymentWidgets();
});


</script>
