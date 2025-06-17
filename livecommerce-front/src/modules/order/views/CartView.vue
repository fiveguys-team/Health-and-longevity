<template>
  <div>
    <NavbarOne/>

    <div class="flex items-center gap-4 flex-wrap bg-overlay p-14 sm:p-16 before:bg-title before:bg-opacity-70" :style="{backgroundImage:'url('+ bg +')'}">
      <div class="text-center w-full">
        <h2 class="text-white text-8 md:text-[40px] font-normal leading-none text-center">Cart</h2>
        <ul class="flex items-center justify-center gap-[10px] text-base md:text-lg leading-none font-normal text-white mt-3 md:mt-4">
          <li><router-link to="/">홈</router-link></li>
          <li>/</li>
          <li class="text-primary">Cart</li>
        </ul>
      </div>
    </div>

    <div class="s-py-100" data-aos="fade-up">
      <div class="container ">
        <div class="flex xl:flex-row flex-col gap-[30px] lg:gap-[30px] xl:gap-[70px]">
          <div class="flex-1 overflow-auto">
            <table id="cart-table" class="responsive nowrap table-wrapper" style="width:100%">
              <thead class="table-header">
              <tr>
                <th class="text-lg md:text-xl font-semibold leading-none text-title dark:text-white">상품 정보</th>
                <th class="text-lg md:text-xl font-semibold leading-none text-title dark:text-white">가격</th>
                <th class="text-lg md:text-xl font-semibold leading-none text-title dark:text-white">수량</th>
                <th class="text-lg md:text-xl font-semibold leading-none text-title dark:text-white">총 금액</th>
                <th class="whitespace-nowrap text-lg md:text-xl font-semibold leading-none text-title dark:text-white">삭제</th>
              </tr>
              </thead>
              <tbody class="table-body">
              <tr v-if="cartItems.length === 0">
                <td colspan="5" class="text-center py-10 text-lg text-gray-500">
                  장바구니에 담긴 상품이 없습니다.
                </td>
              </tr>
              <tr v-for="item in cartItems" :key="item.cartItemId">
                <td class="w-[42%]">
                  <div class="flex items-center gap-3 md:gap-4 lg:gap-6 cart-product">
                    <div class="w-14 sm:w-20 flex-none py-3">
                      <img :src="getImageUrl(item.productImage)" alt="product" />
                    </div>
                    <div class="flex-1">
                      <h6 class="leading-none font-medium">{{ item.categoryName }}</h6>
                      <h5 class="font-semibold leading-none mt-2">
                        <router-link :to="`/product/${item.productId}`">{{ item.productName }}</router-link>
                      </h5>
                    </div>
                  </div>
                </td>
                <td>
                  <h6 class="text-base md:text-lg leading-none text-title dark:text-white font-semibold">₩{{ item.price.toLocaleString() }}</h6>
                </td>
                <td>
                  <IncDec
                      :modelValue="item.quantity"
                      @update:modelValue="(val) => {
    item.quantity = val  // 화면 상 바인딩 수동 적용
    updateQuantity(item.cartItemId, val)
  }"
                  />
<!--                  <IncDec :modelValue="item.quantity" @update:modelValue="(val) => updateQuantity(item.cartItemId, val)" />-->
                </td>
                <td>
                  <h6 class="text-base md:text-lg leading-none text-title dark:text-white font-semibold">
                    ₩{{ (item.price * item.quantity).toLocaleString() }}
                  </h6>
                </td>
                <td>
                  <button class="w-8 h-8 bg-[#E8E9EA] dark:bg-dark-secondary flex items-center justify-center ml-auto duration-300 text-title dark:text-white"
                          @click="removeItem(item.cartItemId)">
                    <svg class="fill-current" width="12" height="12" viewBox="0 0 12 12">
                      <path d="M0.546875 1.70822L1.70481 0.550293L5.98646 4.83195L10.2681 0.550293L11.3991 1.6813L7.11746 5.96295L11.453 10.2985L10.295 11.4564L5.95953 7.12088L1.67788 11.4025L0.546875 10.2715L4.82853 5.98988L0.546875 1.70822Z"/>
                    </svg>
                  </button>
                </td>
              </tr>
              </tbody>
            </table>
          </div>

          <div>
            <div class="mb-[30px]">
            </div>
            <div class="bg-[#FAFAFA] dark:bg-dark-secondary pt-[30px] md:pt-[40px] px-[30px] md:px-[40px] pb-[30px] border border-[#17243026] border-opacity-15 rounded-xl">
              <div class="text-right flex justify-end flex-col w-full ml-auto mr-0">
                <div class="flex justify-between flex-wrap text-base sm:text-lg text-title dark:text-white font-medium">
                  <span>Sub Total:</span>
                  <span>$870</span>
                </div>
                <div class="flex justify-between flex-wrap text-base sm:text-lg text-title dark:text-white font-medium mt-3">
                  <span>Coupon Discount:</span>
                  <span>-$20</span>
                </div>
                <div class="flex justify-between flex-wrap text-base sm:text-lg text-title dark:text-white font-medium mt-3">
                  <span>VAT:</span>
                  <span> $5</span>
                </div>

              </div>
              <div class="mt-6 pt-6 border-t border-bdr-clr dark:border-bdr-clr-drk">
                <div class="flex justify-between flex-wrap text-base sm:text-lg text-title dark:text-white font-medium mt-3">
                  <div>
                    <label class="flex items-center gap-[10px] categoryies-iteem">
                      <input class="appearance-none hidden" type="radio" name="item-type">
                      <span class="w-4 h-4 rounded-full border border-title dark:border-white flex items-center justify-center duration-300">
                                                <svg class="duration-300 opacity-0" width="8" height="8" viewBox="0 0 10 10" fill="none" xmlns="http://www.w3.org/2000/svg">
                                                    <rect width="10" height="10" rx="5" fill="#BB976D"/>
                                                </svg>
                                            </span>
                      <span class="sm:text-lg text-title dark:text-white block sm:leading-none transform translate-y-[3px] select-none">Free Shipping:</span>
                    </label>
                  </div>
                  <span> $0</span>
                </div>
                <div class="flex justify-between flex-wrap text-base sm:text-lg text-title dark:text-white font-medium mt-3">
                  <div>
                    <label class="flex items-center gap-[10px] categoryies-iteem">
                      <input class="appearance-none hidden" type="radio" name="item-type">
                      <span class="w-4 h-4 rounded-full border border-title dark:border-white flex items-center justify-center duration-300">
                                                <svg class="duration-300 opacity-0" width="8" height="8" viewBox="0 0 10 10" fill="none" xmlns="http://www.w3.org/2000/svg">
                                                    <rect width="10" height="10" rx="5" fill="#BB976D"/>
                                                </svg>
                                            </span>
                      <span class="sm:text-lg text-title dark:text-white block sm:leading-none transform translate-y-[3px] select-none"> Fast Shipping:</span>
                    </label>
                  </div>
                  <span>$10</span>
                </div>
                <div class="flex justify-between flex-wrap text-base sm:text-lg text-title dark:text-white font-medium mt-3">
                  <div>
                    <label class="flex items-center gap-[10px] categoryies-iteem">
                      <input class="appearance-none hidden" type="radio" name="item-type">
                      <span class="w-4 h-4 rounded-full border border-title dark:border-white flex items-center justify-center duration-300">
                                                <svg class="duration-300 opacity-0" width="8" height="8" viewBox="0 0 10 10" fill="none" xmlns="http://www.w3.org/2000/svg">
                                                    <rect width="10" height="10" rx="5" fill="#BB976D"/>
                                                </svg>
                                            </span>
                      <span class="sm:text-lg text-title dark:text-white block sm:leading-none transform translate-y-[3px] select-none"> Local Pickup:</span>
                    </label>
                  </div>
                  <span>$15</span>
                </div>
              </div>
              <div class="mt-6 pt-6 border-t border-bdr-clr dark:border-bdr-clr-drk">
                <div class="flex justify-between flex-wrap font-semibold leading-none text-2xl">
                  <span>Total:</span>
                  <span>&nbsp;$850</span>
                </div>
              </div>
            </div>
            <div class="sm:mt-[10px] py-5 flex items-end gap-3 flex-wrap justify-end">
              <router-link to="/shop-v1" class="btn btn-sm btn-outline !text-title hover:!text-white before:!z-[-1] dark:!text-white dark:hover:!text-title">
                Continue Shopping
              </router-link>
              <router-link to="/checkout" class="btn btn-sm btn-theme-solid !text-white hover:!text-primary before:!z-[-1]">
                Checkout
              </router-link>
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
import { onMounted, ref } from 'vue'

import NavbarOne from '@/components/navbar/navbar-one.vue'
import IncDec from '@/components/inc-dec.vue'
import FooterThree from '@/components/footer/footer-three.vue'
import ScrollToTop from '@/components/scroll-to-top.vue'

import Aos from 'aos'
import {getCartByUserId, getCartItems, updateCartItemQuantity, deleteCartItem} from "@/modules/order/services/orderApi";
import {useAuthStore} from "@/modules/auth/stores/auth";

const authStore = useAuthStore();
const userId = authStore.id;

// ✅ 상태 변수
const cartData = ref(null)
const cartItems = ref([])

onMounted(async () => {
  Aos.init()

  try {
    // 1. 유저 ID로 cartId 조회
    const res = await getCartByUserId(userId)
    cartData.value = res.data
    const cartId = cartData.value?.cartId

    if (!cartId) {
      console.warn('장바구니가 존재하지 않습니다.')
      return
    }

    // 2. cartId로 장바구니 아이템 조회
    const itemsRes = await getCartItems(cartId)
    cartItems.value = itemsRes.data
    console.log('장바구니 상품목록', cartItems.value)

  } catch (e) {
    console.error('장바구니 불러오기 실패:', e)
  }
})

async function updateQuantity(cartItemId, newQuantity) {
  try {
    await updateCartItemQuantity({ cartItemId, quantity: newQuantity });
    console.log(`[✅ 수량 변경] cartItemId: ${cartItemId}, quantity: ${newQuantity}`);
  } catch (e) {
    console.error('[❌ 수량 변경 실패]', e);
    alert('수량 변경 중 문제가 발생했습니다.');
  }
}

async function removeItem(cartItemId) {
  if (!confirm('해당 상품을 장바구니에서 삭제하시겠습니까?')) return;

  try {
    await deleteCartItem(cartItemId);
    cartItems.value = cartItems.value.filter(item => item.cartItemId !== cartItemId);
    console.log(`[🗑️ 삭제 성공] cartItemId: ${cartItemId}`);
  } catch (e) {
    console.error('[❌ 삭제 실패]', e);
    alert('상품 삭제 중 오류가 발생했습니다.');
  }
}

function getImageUrl(filename) {
  return `http://localhost:8080/uploads/images/${filename}`;
}
</script>
