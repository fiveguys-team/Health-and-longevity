<template>
    <div>
        <NavbarOne/>

        <swiper 
            :modules="[Autoplay, Pagination]"
            :slides-per-view="1" 
            :loop="true" 
            :pagination="{ clickable: true }" 
            :autoplay="{ delay: 3000}" class="carousel-slider-four owl-carousel block">
            <swiper-slide class="relative pt-12 md:pt-20 xl:pt-[100px] pb-12 sm:pb-20 xl:pb-24 px-[15px] sm:px-12 bg-[#F5F5F5] dark:bg-title">
                <div class="max-w-[1720px] mx-auto">
                    <div class="absolute top-5 right-[30%] z-10 hidden lg:block shape-01">
                        <svg class="w-[300px] xl:w-[500px] h-[250px] xl:h-[409px]" viewBox="0 0 501 410" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path opacity="0.1" d="M93.5685 350.941C17.9186 286.326 -22.6142 169.412 13.177 95.6561C48.7857 21.5837 161.217 -9.19765 268.179 2.36595C374.958 13.6135 477.265 67.4732 497.265 147.363C516.948 227.436 454.823 333.672 367.72 380.59C280.8 427.824 169.535 415.374 93.5685 350.941Z" fill="#BB976D"/>
                        </svg>   
                        <div class="absolute top-1/4 left-[10%] xl:left-[20%] z-30">
                            <h4 class="leading-none text-primary dark:text-primary font-semibold">89,000원</h4>
                            <h3 class="leading-none mt-4">프리미엄 종합 비타민</h3>
                            <div class="group mt-[10px]">
                                <router-link to="/product-details" class="text-lg leading-none text-title font-medium text-underline dark:text-white">구매하기</router-link>
                            </div>
                        </div>                  
                    </div>
                    <div class="absolute z-10 right-[10%] xl:right-[40%] bottom-1/4 hidden md:block shape-02">
                        <svg width="101" height="83" viewBox="0 0 101 83" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M29.1775 77.3654C11.2192 68.7991 -2.66244 48.3121 0.433831 32.2115C3.4785 16.0593 23.6043 4.29344 44.8653 0.990749C66.0748 -2.36354 88.626 2.74531 96.6247 17.143C104.572 31.5922 98.0696 55.3303 83.6719 68.9023C69.3259 82.5259 47.1875 85.8802 29.1775 77.3654Z" fill="#BB976D"/>
                        </svg>
                        <div class="text-center absolute top-1/2 left-1/2 transform z-30 -translate-x-1/2 -translate-y-1/2">
                            <h3 class="font-semibold leading-none text-white">-5%</h3>
                            <p class="leading-none text-white mt-1">OFF</p>
                        </div>
                    </div>
                    <div class="flex items-center justify-between gap-8 flex-col sm:flex-row">
                        <div class="relative z-10 sm:max-w-[632px] w-full slider-content">
                            <div class="flex items-end content-top">
                                <span class="font-bold text-5xl sm:text-7xl xl:text-9xl text-title leading-none dark:text-white">2024</span>
                                <img class="-ml-5 sm:-ml-10 w-[150px] sm:w-[200px] lg:w-[250px] xl:w-full" :src="banner3" alt="summer">
                            </div>
                            <h2 class="mt-[10px] font-normal text-3xl sm:text-4xl xl:text-5xl !leading-[1.3] dark:text-white">건강한 삶을 위한 새로운 영양제가 도착했습니다!</h2>
                            <p class="dark:text-white-light mt-3 md:mt-4 sm:max-w-[450px] xl:max-w-full">최신 연구를 바탕으로 개발된 프리미엄 건강기능식품을 만나보세요. 당신의 건강한 라이프스타일을 위한 최적의 선택입니다.</p>
                            <div class="button mt-4 md:mt-6">
                                <router-link class="btn btn-outline" to="/shop-v1" data-text="Shop Now"><span>Shop Now</span></router-link>
                            </div>
                        </div>
                        <div class="sm:max-w-[750px] w-full">
                            <img class="slider-img w-full h-auto max-h-[600px] object-contain transform scale-110" :src="omega3" alt="omega3">
                        </div>
                    </div>
                </div>
            </swiper-slide>
            <swiper-slide class="relative pt-12 md:pt-20 xl:pt-[100px] pb-12 sm:pb-24 px-[15px] sm:px-12 bg-[#F5F5F5] dark:bg-title">
                <div class="max-w-[1720px] mx-auto">
                    <div class="absolute top-5 right-[30%] z-10 hidden lg:block shape-01">
                        <svg class="w-[300px] xl:w-[500px] h-[250px] xl:h-[409px]" viewBox="0 0 501 410" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M93.5685 350.941C17.9186 286.326 -22.6142 169.412 13.177 95.6561C48.7857 21.5837 161.217 -9.19765 268.179 2.36595C374.958 13.6135 477.265 67.4732 497.265 147.363C516.948 227.436 454.823 333.672 367.72 380.59C280.8 427.824 169.535 415.374 93.5685 350.941Z" fill="#627952" fill-opacity="0.1"/>
                        </svg>
                        <div class="absolute top-1/4 left-[10%] xl:left-[20%] z-30">
                            <h4 class="leading-none text-[#627952] dark:text-[#627952] font-semibold">45,000원</h4>
                            <h3 class="leading-none mt-4">오메가3 rTG</h3>
                            <div class="group mt-[10px]">
                                <router-link to="/product-details" class="text-lg leading-none text-title font-medium text-underline dark:text-white">구매하기</router-link>
                            </div>
                        </div>
                    </div>
                    <div class="absolute z-10 right-[10%] xl:right-[40%] bottom-1/4 hidden md:block shape-02">
                        <svg width="102" height="83" viewBox="0 0 102 83" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M30.1541 77.5842C12.1957 69.0178 -1.68588 48.5308 1.41039 32.4302C4.45506 16.278 24.5808 4.51219 45.8419 1.2095C67.0514 -2.14479 89.6025 2.96406 97.6012 17.3617C105.548 31.811 99.0462 55.5491 84.6485 69.1211C70.3024 82.7447 48.1641 86.0989 30.1541 77.5842Z" fill="#627952"/>
                        </svg> 
                        <div class="text-center absolute top-1/2 left-1/2 transform z-30 -translate-x-1/2 -translate-y-1/2">
                            <h3 class="font-semibold leading-none text-white">-5%</h3>
                            <p class="leading-none text-white mt-1">OFF</p>
                        </div>
                    </div>
                    <div class="flex items-center justify-between gap-8 flex-col sm:flex-row">
                        <div class="relative z-10 sm:max-w-[632px] w-full slider-content">
                            <div class="flex items-end content-top">
                                <span class="font-bold text-5xl sm:text-7xl xl:text-9xl text-title leading-none dark:text-white">2024</span>
                                <img class="-ml-5 sm:-ml-10 w-[150px] sm:w-[200px] lg:w-[250px] xl:w-full" :src="banner3" alt="summer">
                            </div>
                            <h2 class="mt-[10px] font-normal text-3xl sm:text-4xl xl:text-5xl !leading-[1.3] dark:text-white">특별한 가격으로 만나는 프리미엄 건강기능식품</h2>
                            <p class="dark:text-white-light mt-3 md:mt-4 sm:max-w-[450px] xl:max-w-full">검증된 원료와 철저한 품질관리로 만든 건강기능식품을 만나보세요. 건강한 삶을 위한 현명한 투자, 지금 시작하세요.</p>
                            <div class="button mt-4 md:mt-6">
                                <router-link class="btn btn-outline" to="/shop-v2" data-text="Shop Now"><span>Shop Now</span></router-link>
                            </div>
                        </div>
                        <div class="sm:max-w-[750px] w-full">
                            <img class="slider-img w-full h-auto max-h-[600px] object-contain transform scale-110" :src="multivitamin" alt="multivitamin">
                        </div>
                    </div>
                </div>
            </swiper-slide>
        </swiper>

        <div class="s-py-100-50 overflow-hidden">
            <div class="container-fluid">
                <div class="max-w-xl mx-auto mb-8 md:mb-12 text-center" data-aos="fade-up">
                    <div>
                        <img :src="like" alt="" class="mx-auto w-14 sm:w-24"/>                                               
                    </div>
                    <h3 class="leading-none mt-4 md:mt-6 text-2xl md:text-3xl">회원님을 위한 추천 상품</h3>
                    <p class="mt-3">회원님의 관심사와 선호도를 바탕으로 엄선된 제품을 추천해드립니다.</p>
                </div>
                <div data-aos="fade-up" data-aos-delay="100">
                    <LayoutOne :productList="productList.slice(0,4)" :classList="'max-w-[1720px] mx-auto grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5 sm:gap-8'"/>
                </div>
            </div>
        </div>

        <div class="s-py-50-100 bg-[#F5F5F5] dark:bg-title">
            <div class="container-fluid">
                <div class="max-w-xl mx-auto mb-8 md:mb-12 text-center" data-aos="fade-up">
                    <div>
                        <img :src="sofa" alt="" class="mx-auto w-14 sm:w-24"/>                                               
                    </div>
                    <h3 class="leading-none mt-4 md:mt-6 text-2xl md:text-3xl">실시간 인기 상품</h3>
                    <p class="mt-3">지금 가장 많은 관심을 받고 있는 인기 제품을 만나보세요.</p>
                </div>
                <div class="max-w-[1720px] mx-auto flex gap-5 sm:gap-8 flex-col lg:flex-row" data-aos="fade-up" data-aos-delay="100">
                    <LayoutOne :productList="productList.slice(4,8)" :classList="'grid sm:grid-cols-2 gap-5 sm:gap-8 lg:max-w-[766px] w-full'"/>
                    <div class="grid sm:grid-cols-2 gap-5 sm:gap-8 lg:max-w-[925px] w-full">
                        <div class="group flex flex-col">
                            <div class="relative overflow-hidden flex-1">
                                <router-link to="/product-details">
                                    <img class="w-full transform group-hover:scale-110 duration-300 h-full object-cover" :src="product1" alt="product-card"/>
                                </router-link>
                                <div class="absolute z-10 top-[50%] right-3 transform -translate-y-[40%] opacity-0 duration-300 transition-all group-hover:-translate-y-1/2 group-hover:opacity-100 flex flex-col items-end gap-3">
                                    <router-link to="#" class="bg-white dark:bg-title dark:text-white bg-opacity-80 flex items-center justify-center gap-2 px-4 py-[10px] text-base leading-none text-title rounded-[40px] h-14 overflow-hidden new-product-icon">
                                        <i class="mdi mdi-cards-heart-outline dark:text-white text-[24px]"></i>                                                                     
                                        <span class="mt-1">찜하기</span>
                                    </router-link>
                                    <router-link to="#" class="bg-white dark:bg-title dark:text-white bg-opacity-80 flex items-center justify-center gap-2 px-4 py-[10px] text-base leading-none text-title rounded-[40px] h-14 overflow-hidden new-product-icon">
                                        <i class="mdi mdi-shopping-outline dark:text-white text-[24px]"></i>    
                                        <span class="mt-1">장바구니 담기</span>
                                    </router-link>
                                    <button class="bg-white dark:bg-title dark:text-white bg-opacity-80 flex items-center justify-center gap-2 px-4 py-[10px] text-base leading-none text-title rounded-[40px] h-14 overflow-hidden new-product-icon quick-view">
                                        <i class="mdi mdi-eye-outline dark:text-white text-[24px]"></i>                                      
                                        <span class="mt-1">미리보기</span>
                                    </button>
                                </div>
                            </div>
                            <div class="lg:pt-6 pt-5 flex gap-3 md:gap-4 flex-col">
                                <h4 class="font-medium leading-none dark:text-white text-lg">78,000원 <span class="text-title/50 line-through pl-2 inline-block">98,000원</span></h4>
                                <div>
                                    <h5 class="font-normal dark:text-white text-xl leading-[1.5]">
                                        <router-link to="/product-details" class="text-underline">
                                            프리미엄 루테인 지아잔틴
                                        </router-link>
                                    </h5>
                                    <ul class="flex items-center gap-2 mt-1">
                                        <li><i class="fa-solid fa-star text-[#EE9818] text-[14px]"></i></li>
                                        <li><i class="fa-solid fa-star text-[#EE9818] text-[14px]"></i></li>
                                        <li><i class="fa-solid fa-star text-[#EE9818] text-[14px]"></i></li>
                                        <li><i class="fa-solid fa-star text-[#EE9818] text-[14px]"></i></li>
                                        <li><i class="fa-solid fa-star text-slate-300 text-[14px]"></i></li>
                                        <li class="dark:text-gray-100">( 1,230 )</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="s-py-50-100">
            <div class="container-fluid">
                <div class="max-w-xl mx-auto mb-8 md:mb-12 text-center" data-aos="fade-up">
                    <div>
                        <img :src="bed" alt="" class="mx-auto w-14 sm:w-24"/>                                               
                    </div>
                    <h3 class="leading-none mt-4 md:mt-6 text-2xl md:text-3xl">신상품</h3>
                    <p class="mt-3">새롭게 입점된 제품들을 가장 먼저 만나보세요.</p>
                </div>
                <div data-aos="fade-up" data-aos-delay="100">
                    <LayoutOne :productList="productList.slice(8,12)" :classList="'max-w-[1720px] mx-auto grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5 sm:gap-8'"/>
                </div>
                <div class="text-center mt-7 md:mt-12">
                    <router-link to="/shop-v1" class="btn btn-outline" data-text="전체상품보기">
                        <span>전체상품보기</span>
                    </router-link>
                </div>
            </div>
        </div>

        <div class="s-py-50">
            <div class="container-fluid">
                <div class="max-w-[1720px] mx-auto">
                    <div class="max-w-xl mx-auto mb-8 md:mb-12 text-center" data-aos="fade-up">
                        <div> 
                            <img :src="comment" class="mx-auto w-14 sm:w-24" alt="" />                                               
                        </div>
                        <h3 class="leading-none mt-4 md:mt-6 text-2xl md:text-3xl">건강정보</h3>
                        <p class="mt-3">건강한 삶을 위한 유용한 정보들을 만나보세요. 전문가들이 제공하는 건강 관리 팁과 영양 정보를 통해 더 건강한 라이프스타일을 만들어보세요.</p>
                    </div>

                    <BlogOne/>
                </div>
            </div>
        </div>

        <div class="s-py-50-100">
            <div class="container-fluid">
                <div class="max-w-xl mx-auto mb-8 md:mb-12 text-center" data-aos="fade-up">
                    <div>
                        <img :src="hand" class="size-16 mx-auto" alt="">                                            
                    </div>
                    <h3 class="leading-none mt-4 md:mt-6 text-2xl md:text-3xl">믿을 수 있는 파트너</h3>
                    <p class="mt-3">식약처 인증을 받은 우수한 제조시설에서 엄선된 원료로 만든 제품만을 제공합니다. 건강과 신뢰를 최우선으로 생각하는 파트너들과 함께합니다.</p>
                </div>
                <div data-aos="fade-up" data-aos-delay="100">
                    <PartnerOne/>
                </div>
            </div>
        </div>
     <FooterThree/>
        <ScrollToTop/>

    </div>
</template>

<script setup>
import { onMounted } from 'vue';

// 이미지 imports
import banner3 from '@/assets/img/shortcode/carousel/Summer.png'
import omega3 from '@/assets/img/home-v1/omega3.png'
import multivitamin from '@/assets/img/home-v1/multivitamin.png'
import sofa from '@/assets/img/svg/sofa.svg'
import like from "@/assets/img/svg/like.svg"
import bed from "@/assets/img/svg/bed.svg"
import product1 from '@/assets/img/home-v1/ftur-pdct-01.jpg'
import hand from "@/assets/img/svg/hand.png"

// 컴포넌트 imports
import NavbarOne from '@/components/navbar/navbar-one.vue';
import LayoutOne from '@/components/product/layout-one.vue';
import ScrollToTop from '@/components/scroll-to-top.vue';
import FooterThree from '@/components/footer/footer-three.vue';

// Swiper imports
import { Swiper, SwiperSlide } from 'swiper/vue';
import { Autoplay, Pagination } from 'swiper/modules';
import 'swiper/swiper-bundle.css';

// 데이터 imports
import { productList } from '@/data/data';

// AOS 애니메이션
import Aos from 'aos';
import 'aos/dist/aos.css';

onMounted(() => {
    Aos.init();
});
</script>