<template>
    <div>
        <NavbarOne/>

        <div class="flex items-center gap-4 flex-wrap bg-overlay p-14 sm:p-16 before:bg-title before:bg-opacity-70" :style="{backgroundImage:'url(' +  bg  + ')'}">
            <div class="text-center w-full">
                <h2 class="text-white text-8 md:text-[40px] font-normal leading-none text-center">Order History</h2>
                <ul class="flex items-center justify-center gap-[10px] text-base md:text-lg leading-none font-normal text-white mt-3 md:mt-4">
                    <li><router-link to="/">Home</router-link></li>
                    <li>/</li>
                    <li class="text-primary">History</li>
                </ul>
            </div>
        </div>

        <div class="s-py-100" data-aos="fade-up">
            <div class="container-fluid">
                <div class="max-w-[1720px] mx-auto flex items-start gap-8 md:gap-12 2xl:gap-24 flex-col md:flex-row my-profile-navtab">
                    <div class="w-full md:w-[200px] lg:w-[300px] flex-none">
                        <ProfileTab/>
                    </div>
                    <div class="w-full md:w-auto md:flex-1 overflow-auto">
                        <div class="bg-[#F8F8F9] dark:bg-dark-secondary p-5 sm:p-8 lg:p-[50px] order-history-table">
                            <ul class="order-history">
                                <li class="title flex items-center justify-between gap-5 pb-[10px] sm:pb-5 border-b border-bdr-clr dark:border-bdr-clr-drk">
                                    <span class="cart-product-title text-lg md:text-xl font-semibold leading-none text-title dark:text-white block w-[270px] sm:w-[310px] xl:w-[330px]">Product</span>
                                    <span class="text-lg md:text-xl font-semibold leading-none text-title dark:text-white w-[60px]">Price</span>
                                    <span class="text-lg md:text-xl font-semibold leading-none text-title dark:text-white w-[100px]">Status</span>
                                </li>
                                <li v-for="(item, index) in cartData" :key="index" class="flex items-center justify-between gap-5 py-[15px] sm:py-[15px] border-b border-bdr-clr dark:border-bdr-clr-drk">
                                    <div class="flex items-center gap-3 md:gap-4 lg:gap-6 ordered-product w-[270px] sm:w-[310px] xl:w-[330px]">
                                        <div class="w-16 sm:w-[90px] flex-none">
                                            <img :src="item.image" alt="product">
                                        </div>
                                        <div class="flex-1">
                                            <span class="text-[15px] font-medium leading-none">{{item.tag}}</span>
                                            <h5 class="font-semibold leading-none mt-2 md:mt-4"><router-link to="#">{{item.name}}</router-link></h5>
                                        </div>
                                    </div>

                                    <span class="text-base md:text-lg leading-none text-title dark:text-white font-semibold text-left w-[60px]">{{item.price}}</span>

                                    <div class="w-[100px]">
                                        <router-link v-if="item.status === 'Completed'" to="#" class="bg-[#31A051] py-[7px] px-[10px] font-semibold leading-none text-white text-sm rounded">
                                            Completed
                                        </router-link>
                                        <router-link v-if="item.status === 'Pending'" to="#" class="bg-[#EC991D] py-[7px] px-[10px] font-semibold leading-none text-white text-sm rounded">
                                            Pending
                                        </router-link>
                                        <router-link v-if="item.status === 'Cancel'" to="#" class="bg-[#E13939] py-[7px] px-[10px] font-semibold leading-none text-white text-sm rounded">
                                            Cancel
                                        </router-link>
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <FooterOne/>
        
        <ScrollToTop/>
    </div>
</template>

<script setup>
    import { onMounted } from 'vue';

    import NavbarOne from '@/components/navbar/navbar-one.vue';
    import ProfileTab from '@/components/profile-tab.vue';
    import FooterOne from '@/components/footer/footer-one.vue';
    import ScrollToTop from '@/components/scroll-to-top.vue';

    import bg from '@/assets/img/shortcode/breadcumb.jpg'

    import { cartData } from '@/data/data';

    import Aos from 'aos';

    onMounted(()=>{
        Aos.init()
    })
</script>
