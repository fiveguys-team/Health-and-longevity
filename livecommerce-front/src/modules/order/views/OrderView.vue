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
                    ref="nameRef"
                    v-model="form.name"
                    class="w-full h-12 md:h-14 bg-white dark:bg-dark-secondary border border-[#E3E5E6] text-title dark:text-white focus:border-primary p-4 outline-none duration-300"
                    type="text"
                    placeholder="이름을 입력하세요"/>
                <p v-if="form.name && !isValidName" class="text-sm text-red-500 mt-1">
                  이름은 한글 2~10자 또는 영문 2~20자만 입력 가능합니다.
                </p>
              </div>

              <div>
                <label
                    class="text-base md:text-lg text-title dark:text-white leading-none mb-2 sm:mb-3 block">이메일</label>
                <input
                    ref="emailRef"
                    v-model="form.email"
                    class="w-full h-12 md:h-14 bg-white dark:bg-dark-secondary border border-[#E3E5E6] text-title dark:text-white focus:border-primary p-4 outline-none duration-300"
                    type="text"
                    placeholder="이메일 주소를 입력하세요"
                />
                <p v-if="form.email && !isValidEmail" class="text-sm text-red-500 mt-1">
                  유효한 이메일 형식이 아닙니다. 예: example@domain.com
                </p>
              </div>

              <div>
                <label
                    class="text-base md:text-lg text-title dark:text-white leading-none mb-2 sm:mb-3 block">전화번호</label>
                <input
                    ref="phoneRef"
                    v-model="form.phone"
                    class="w-full h-12 md:h-14 bg-white dark:bg-dark-secondary border border-[#E3E5E6] text-title dark:text-white focus:border-primary p-4 outline-none duration-300"
                    type="text"
                    placeholder="전화번호를 입력하세요"
                />
                <p v-if="form.phone && !isValidPhone" class="text-sm text-red-500 mt-1">
                  010 / 070 / 02~064 지역번호만 허용됩니다.
                </p>
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
                  <button  ref="postcodeButtonRef" @click="openPostcode" class="ml-2 bg-primary text-white px-4 md:px-6 rounded-md">
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
                  v-model="form.note"
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
            <div v-if="orderItem"
                 class="bg-[#FAFAFA] dark:bg-dark-secondary pt-[30px] md:pt-[40px] lg:pt-[50px] px-[30px] md:px-[40px] lg:px-[50px] pb-[30px] border border-[#17243026] border-opacity-15 rounded-xl">
              <h4 class="font-semibold leading-none text-xl md:text-2xl mb-6 md:mb-10">
                상품 정보
              </h4>
              <div class="grid gap-5 mg:gap-6">
                <div class="flex items-center justify-between gap-5">
                  <div class="flex items-center gap-3 md:gap-4 lg:gap-6 cart-product flex-wrap">
                    <div class="w-16 sm:w-[70px] flex-none">
                      <img :src="orderItem.productImage" alt="product" />
                    </div>
                    <div class="flex-1">
                      <h5 class="font-semibold leading-none mt-2">
                        <router-link to="#">{{ orderItem.productName }}</router-link>
                      </h5>
                      <br>
                      <h6 class="leading-none font-medium">{{orderItem.categoryName}}</h6>
                    </div>
                  </div>
                  <h6 class="leading-none">{{ orderItem.price.toLocaleString() }} 원</h6>
                  <h6 class="leading-none text-sm text-gray-500 mt-1">
                  </h6>
                </div>
              </div>
              <div
                  class="mt-6 pt-6 border-t border-bdr-clr dark:border-bdr-clr-drk text-right flex justify-end flex-col w-full ml-auto mr-0">
                <div
                    class="flex justify-between flex-wrap text-base sm:text-lg text-title dark:text-white font-medium mt-3">
                  <span>수량:</span>
                  <span>{{ orderItem.quantity }} 개</span>
                </div>
                <div
                    class="flex justify-between flex-wrap text-base sm:text-lg text-title dark:text-white font-medium mt-3">
                  <span>배송비:</span>
                  <span> {{ deliveryFee.toLocaleString() }} 원</span>
                </div>
                <div
                    class="flex justify-between flex-wrap text-base sm:text-lg text-title dark:text-white font-medium mt-3">
                  <span>총 할인 금액:</span>
                  <span>0 원</span>
                </div>
                <div class="flex justify-between flex-wrap text-base sm:text-lg text-title dark:text-white font-medium">
                  <span>총 주문 금액:</span>
                  <span>{{ totalPrice.toLocaleString() }} 원</span>
                </div>

              </div>
              <div class="mt-6 pt-6 border-t border-bdr-clr dark:border-bdr-clr-drk">
                <div class="flex justify-between flex-wrap font-semibold leading-none text-2xl md:text-3xl">
                  <span>총 결제 금액:</span>
                  <span>{{ totalAmount.toLocaleString() }} 원 </span>
                </div>
              </div>
            </div>
            <div v-else class="text-center text-gray-500 mt-10">
              <p>🛒 주문할 상품이 없습니다.</p>
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
                    @click="handleSubmit"
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
import { useOrderStore } from '@/modules/order/stores/order'
import {computed, ref, reactive, watch, onMounted} from "vue";
import { loadTossPayments } from "@tosspayments/tosspayments-sdk";
import NavbarOne from '@/components/navbar/navbar-one.vue';
import FooterThree from '@/components/footer/footer-three.vue';
import ScrollToTop from '@/components/scroll-to-top.vue';
import 'swiper/swiper-bundle.css';
import Aos from 'aos';
import 'aos/dist/aos.css';
import bg from "@/assets/img/shortcode/breadcumb.jpg";
import  {prepareOrder} from "@/modules/order/services/orderApi";
import {cancelPayment} from "@/modules/payment/services/payment";


function generateRandomString() {
  return window.btoa(Math.random().toString()).slice(0, 20);
}

const orderStore = useOrderStore()

const orderItem = computed(() => orderStore.orderItem)
const totalPrice = computed(() => {
  return orderItem.value.price * orderItem.value.quantity;
})
const totalAmount = computed(() => {
  return totalPrice.value + deliveryFee.value;
})

const deliveryFee = computed(() => totalPrice.value >= 50000 ? 0 : 3000)

const nameRegex = /^([가-힣]{2,10}|[a-zA-Z\s]{2,20})$/
const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
const phoneRegex = /^(010|070|0(2|3[1-3]|4[1-4]|5[1-5]|6[1-4]))\d{7,8}$/

const isValidName = computed(() => nameRegex.test(form.name))
const isValidEmail = computed(() => emailRegex.test(form.email))
const isValidPhone = computed(() => phoneRegex.test(form.phone.replace(/-/g, '')))

// ─── 1. ‘배송지’ 폼 데이터 (reactive 객체) ───
const form = reactive({
  name: "",
  email: "",
  phone: "",
  detailAddress: "",
  note: "",
});

const nameRef = ref(null)
const emailRef = ref(null)
const phoneRef = ref(null)
const postcodeButtonRef = ref(null)

const postalCode = ref("");
const basicAddress = ref("");

// “기본배송지로 설정” 여부
const isDefaultAddress = ref(false);

const handleSubmit = () => {
  if (!nameRegex.test(form.name)) {
    alert('유효한 이름을 입력해주세요')
    return
  }
  if (!emailRegex.test(form.email)) {
    alert('유효한 이메일을 입력해주세요')
    return
  }
  if (!phoneRegex.test(String(form.phone).replace(/-/g, ''))) {
    alert('유효한 전화번호를 입력해주세요')
    return
  }
  if (!postalCode.value || !basicAddress.value) {
    alert('주소를 입력해주세요. "우편번호 찾기" 버튼을 눌러 주소를 입력하세요.')
    return
  }
  if(!form.detailAddress) {
    alert('상세주소를 입력해주세요')
    return
  }

  requestPayment();


}

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
const amount = computed(() => ({
  currency: "KRW",
  value: totalAmount.value || 0,
}));

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
    await widgets.value.setAmount(amount.value);

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
  if (!widgets.value || !ready.value) {
    alert("시스템에 오류가 있습니다 관리자에게 문의하세요.");
    return;
  }

  if (!orderItem.value || totalAmount.value <= 0) {
    alert("결제 금액이 유효하지 않습니다.");
    return;
  }


  if(orderItem.value.stockCount <= 0){
    alert('해당 제품의 재고 수량이 부족합니다!');
    return;
  }

  let orderId = ''

  try {
    const payload = {
      userId: 1, //추후 본인 아이디로 변경필요.
      orderItems: [
        {
          productId: orderItem.value.productId,
          quantity: orderItem.value.quantity,
        }
      ],
      shippingRequest: form.note,
      postalCode: postalCode.value,
      basicAddress: basicAddress.value,
      detailedAddress: form.detailAddress
    };


    const res = await prepareOrder(payload);
    const { orderName, customerName } = res.data;
    orderId = res.data.orderId;

    await widgets.value.requestPayment({
      orderId,
      orderName,
      customerName,
      successUrl: `${window.location.origin}/payment-success`,
      failUrl: `${window.location.origin}/payment-failure`
    });

  } catch (error) {
    if (error.code === 'USER_CANCEL') {
      await cancelPayment(orderId);
      alert('결제가 취소되었습니다.');
    } else {
      console.error("Error requesting payment:", error);
    }
  }
}

onMounted(() => {
  Aos.init();
  if (!orderStore.orderItem) {
    const saved = sessionStorage.getItem('orderItem')
    if (saved) {
      orderStore.setOrderItem(JSON.parse(saved))
    }
  }
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
