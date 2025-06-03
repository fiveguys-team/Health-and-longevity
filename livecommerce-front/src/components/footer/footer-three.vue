<template>
    <div class="s-pt-100 bg-snow dark:bg-title 2xl:pb-[100px]">
        <div class="container-fluid max-w-[1720px] mx-auto">
            <div class="flex flex-col 2xl:flex-row items-start justify-between gap-10">
                <div class="max-w-[478px] w-full text-left sm:text-center 2xl:text-left sm:mx-auto 2xl:mx-0">
                    <router-link class="cursor-pointer block" to="/" aria-label="Furnixar">
                        <img :src="logoDark" alt="" class='dark:hidden w-[120px] sm:w-[200px]'/> 
                        <img :src="logoLight" alt="" class='dark:block hidden w-[120px] sm:w-[200px]'/>
                    </router-link>  
                    <p class="mt-[15px]">Furnixar is a modern furniture template for an eCommerce website designed to help you create an impressive online store for your furniture. </p>
                    <div class="flex items-center gap-4 mt-6 sm:justify-center 2xl:justify-start">
                        <router-link to="#" class="w-10 h-10 rounded-full border border-[#898F95] border-opacity-50 flex items-center justify-center group hover:border-primary duration-300" aria-label="Facebook">
                            <i class="fa-brands fa-facebook-f text-[#5B646D] dark:text-white group-hover:text-primary duration-300"></i>
                        </router-link>
                        <router-link to="#" class="w-10 h-10 rounded-full border border-[#898F95] border-opacity-50 flex items-center justify-center group hover:border-primary duration-300" aria-label="Twitter">
                            <i class="fa-brands fa-twitter text-[#5B646D] dark:text-white group-hover:text-primary duration-300"></i>
                        </router-link>
                        <router-link t0="#" class="w-10 h-10 rounded-full border border-[#898F95] border-opacity-50 flex items-center justify-center group hover:border-primary duration-300" aria-label="Instagram">
                            <i class="fa-brands fa-instagram text-[#5B646D] dark:text-white group-hover:text-primary duration-300"></i>
                        </router-link>
                        <router-link to="#" class="w-10 h-10 rounded-full border border-[#898F95] border-opacity-50 flex items-center justify-center group hover:border-primary duration-300" aria-label="Linkedin">
                            <i class="fa-brands fa-linkedin-in text-[#5B646D] dark:text-white group-hover:text-primary duration-300"></i>
                        </router-link>
                    </div>
                </div>
                <div class="grid grid-cols-2 sm:grid-cols-3 2xl:max-w-[1094px] w-full lg:flex items-start justify-between gap-10">
                    <div class="lg:w-[300px] order-7 2xl:order-none col-span-2 md:col-span-1">
                        <h4 class="leading-none mb-5 md:mb-6 text-xl">Subscribe Newsletter</h4>
                        <div class="flex flex-col gap-[10px] sm:items-start">
                            <input class="w-full h-12 md:h-14 bg-transparent border border-primary p-4 outline-none dark:text-white placeholder:text-title dark:placeholder:text-white" type="text" placeholder="Enter your email address">
                            <button class="btn btn-primary-solid" data-text="Subscribe"><span>Subscribe</span></button>
                        </div>
                    </div>
                    <div>
                        <h4 class="leading-none mb-5 md:mb-6 text-xl">Sitemap</h4>
                        <ul class="text-title dark:text-white leading-none flex flex-col gap-4">
                            <li v-for="(item, index) in footerLink1" :key="index" class="duration-100 hover:text-primary inline-block group"><router-link class="text-underline-primary" :to="item.link">{{item.name}}</router-link></li>
                        </ul>
                    </div>
                    <div>
                        <h4 class="leading-none mb-5 md:mb-6 text-xl">Others</h4>
                        <ul class="text-title dark:text-white leading-none flex flex-col gap-4">
                            <li v-for="(item, index) in footerLink2" :key="index" class="duration-100 hover:text-primary inline-block group"><router-link class="text-underline-primary" :to="item.link">{{item.name}}</router-link></li>
                        </ul>
                    </div>
                    <div>
                        <h4 class="leading-none mb-5 md:mb-6 text-xl">쇼핑하기</h4>
                        <ul class="text-title dark:text-white leading-none flex flex-col gap-4">
                            <li class="duration-100 hover:text-primary inline-block group"><router-link class="text-underline-primary" to="/category/vitamin">비타민</router-link></li>
                            <li class="duration-100 hover:text-primary inline-block group"><router-link class="text-underline-primary" to="/category/mineral">미네랄</router-link></li>
                            <li class="duration-100 hover:text-primary inline-block group"><router-link class="text-underline-primary" to="/category/protein">단백질</router-link></li>
                            <li class="duration-100 hover:text-primary inline-block group"><router-link class="text-underline-primary" to="/category/omega">오메가</router-link></li>
                        </ul>
                    </div>
                    <div>
                        <h4 class="leading-none mb-5 md:mb-6 text-xl">고객센터</h4>
                        <ul class="text-title dark:text-white leading-none flex flex-col gap-4">
                            <li class="duration-100 hover:text-primary inline-block group"><router-link class="text-underline-primary" to="/notice">공지사항</router-link></li>
                            <li class="duration-100 hover:text-primary inline-block group"><router-link class="text-underline-primary" to="/faq">자주묻는질문</router-link></li>
                            <li class="duration-100 hover:text-primary inline-block group"><router-link class="text-underline-primary" to="/qna">1:1문의</router-link></li>
                            <li class="duration-100 hover:text-primary inline-block group"><router-link class="text-underline-primary" to="/review">상품후기</router-link></li>
                        </ul>
                    </div>
                    <div>
                        <h4 class="leading-none mb-5 md:mb-6 text-xl">회사소개</h4>
                        <ul class="text-title dark:text-white leading-none flex flex-col gap-4">
                            <li class="duration-100 hover:text-primary inline-block group"><router-link class="text-underline-primary" to="/about">회사소개</router-link></li>
                            <li class="duration-100 hover:text-primary inline-block group"><router-link class="text-underline-primary" to="/terms">이용약관</router-link></li>
                            <li class="duration-100 hover:text-primary inline-block group"><router-link class="text-underline-primary" to="/privacy">개인정보처리방침</router-link></li>
                            <li class="duration-100 hover:text-primary inline-block group"><router-link class="text-underline-primary" to="/partners">제휴문의</router-link></li>
                        </ul>
                    </div>
                    <div>
                        <h4 class="leading-none mb-5 md:mb-6 text-xl">고객상담</h4>
                        <ul class="text-title dark:text-white leading-none flex flex-col gap-4">
                            <li class="duration-100 text-xl font-bold">1544-0000</li>
                            <li class="duration-100">평일 09:00 - 18:00</li>
                            <li class="duration-100">점심 12:00 - 13:00</li>
                            <li class="duration-100">주말/공휴일 휴무</li>
                        </ul>
                    </div>
                </div>
            </div>
            <p class="text-title dark:text-white pb-5 2xl:pb-0 mt-12 2xl:mt-6 text-center 2xl:text-left">© {{year}} 무병장수 주식회사 | 사업자등록번호: 000-00-00000 | 대표: 홍길동</p>
        </div>
    </div>
</template>

<script setup>
import logoDark from '@/assets/img/svg/logo.png'
import logoLight from '@/assets/img/svg/logo.png'
import { ref } from 'vue';

const year = ref(new Date().getFullYear());
</script>

<style lang="scss" scoped>

</style>