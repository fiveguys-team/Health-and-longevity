<template>
  <div>
    <NavbarOne/>

    <div class="flex items-center gap-4 flex-wrap bg-overlay p-14 sm:p-16 before:bg-title before:bg-opacity-70" :style="{backgroundImage:'url(' + bg + ')'}">
      <div class="text-center w-full">
        <h2 class="text-white text-8 md:text-[40px] font-normal leading-none text-center">Payment Confirmation</h2>
        <ul class="flex items-center justify-center gap-[10px] text-base md:text-lg leading-none font-normal text-white mt-3 md:mt-4">
          <li><router-link to="/">Home</router-link></li>
          <li>/</li>
          <li class="text-primary">Payment</li>
        </ul>
      </div>
    </div>

    <div class="s-py-100">
      <div class="container">
        <div class="max-w-[800px] mx-auto">
          <h3 class="font-semibold leading-none text-2xl md:text-3xl mb-[30px]">
            Confirm Your Payment
          </h3>
          <div class="overflow-x-auto">
            <table class="min-w-full text-sm border-t border-t-dashed border-t-title pt-[30px] pb-[30px] aos-init aos-animate payment-confirmation-meta-table block border-b border-dashed border-title aos-init aos-animate">
              <tbody class="w-full">
              <tr class="first-th-item pb-4 text-base sm:text-lg text-paragraph dark:text-white">
                <th class="text-base sm:text-lg font-normal">Date</th>
                <th class='text-base sm:text-lg font-normal'>Card Holder</th>
                <th class='text-base sm:text-lg font-normal'>Card Type</th>
              </tr>
              <tr class="first-td-item pb-12 text-lg sm:text-xl text-title dark:text-white font-medium">
                <td>12/31/2024</td>
                <td>John Smith Doe</td>
                <td>Visa</td>
              </tr>
              <tr class="two-th-item pb-4 text-base sm:text-lg font-normal text-paragraph dark:text-white">
                <th class="text-base sm:text-lg font-normal">Card Number</th>
                <td class="text-base sm:text-lg font-normal">eMail</td>
                <td class="text-base sm:text-lg font-normal">Phone</td>
              </tr>
              <tr class="two-td-item text-lg sm:text-xl text-title dark:text-white font-medium">
                <th class='font-medium'>**** **** **** 1234</th>
                <td class='font-medium'>demomail@gmail.com</td>
                <td class='font-medium'>(+11) 01234 56789</td>
              </tr>
              </tbody>
            </table>
          </div>

          <div class="flex justify-between items-center flex-wrap gap-4 mt-[30px]">
            <h4 class="text-xl font-medium leading-none mb-0">
              Subtotal : $850
            </h4>
            <div class="flex gap-3">
              <router-link to="#" class="btn btn-secondory-solid" data-text="Cancel Payment">
                <span>Cancel Payment</span>
              </router-link>
              <button class="btn btn-solid" data-text="Confirm Payment">
                <span>Confirm Payment</span>
              </button>
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
import NavbarOne from '@/components/navbar/navbar-one.vue';
import FooterThree from '@/components/footer/footer-three.vue';
import ScrollToTop from '@/components/scroll-to-top.vue';

import bg from '@/assets/img/shortcode/breadcumb.jpg'
</script>
