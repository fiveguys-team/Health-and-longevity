<template>
    <div>
        <NavbarOne/>

        <div class="flex items-center gap-4 flex-wrap bg-overlay p-14 sm:p-16 before:bg-title before:bg-opacity-70" :style="{backgroundImage:'url(' + bg + ')'}">
            <div class="text-center w-full">
                <h2 class="text-white text-8 md:text-[40px] font-normal leading-none text-center">Pricing</h2>
                <ul class="flex items-center justify-center gap-[10px] text-base md:text-lg leading-none font-normal text-white mt-3 md:mt-4">
                    <li><router-link to="/">Home</router-link></li>
                    <li>/</li>
                    <li class="text-primary">Pricing</li>
                </ul>
            </div>
        </div>

        <div class="s-py-100">
            <div class="container">
                <div class="max-w-xl mx-auto mb-8 text-center" data-aos="fade-up">
                    <div>
                        <img :src="about" class="w-16 mx-auto" alt="">
                    </div>
                    <h3 class="font-medium leading-none mt-4 md:mt-6 text-2xl md:text-3xl">Choose Price Plan</h3>
                    <p class="mt-3">Discover the ideal plan to suit your budget and requirements. Choose flexibility and affordability with our tailored pricing options.</p>
                </div>
                <div class="mb-8 flex items-center justify-center">
                    <div class="switch-wrapper p-[5px] bg-[#F7F7F7] dark:bg-dark-card-bg border border-title/10 dark:border-white/10 rounded-[70px] mx-auto relative inline-flex">
                        <input id="monthly" type="radio" name="switch" checked @change="onInputChange()">
                        <input id="yearly" type="radio" name="switch" @change="onInputChange()">
                        <label for="monthly">Monthly</label>
                        <label for="yearly">Yearly</label>
                        <span class="highlighter"></span>
                    </div>
                </div>
                <div class="flex flex-wrap justify-center lg:grid sm:grid-cols-2 lg:grid-cols-3 gap-5 md:gap-[30px] max-w-[1342px] mx-auto">
                    <div v-for="(item, index) in pricingData" :key="index" class="w-full sm:w-[47%] lg:w-auto flex flex-col justify-between bg-primary bg-opacity-10 px-7 md:px-10 py-8 md:py-12 group" data-aos="fade-up" data-aos-delay="100">
                        <div>
                            <h4 class="font-normal leading-none">{{item.title}}</h4>
                            <span v-if="price" class="block text-title dark:text-white text-4xl md:text-5xl font-bold leading-none mt-4 md:mt-6 duration-300 price" data-monthly="9" data-yearly="99">{{item.month}}</span>
                            <span v-if="!price" class="block text-title dark:text-white text-4xl md:text-5xl font-bold leading-none mt-4 md:mt-6 duration-300 price" data-monthly="9" data-yearly="99">{{item.year}}</span>
                            <ul class="mt-4 md:mt-6 flex flex-col gap-[15px]">
                                <li v-for="(el, index) in item.feature" :key="index" class="flex items-center gap-[10px] text-title dark:text-white-light">
                                    <svg width="14" height="13" viewBox="0 0 14 13" fill="none" xmlns="http://www.w3.org/2000/svg">
                                        <path d="M4.80386 12.9623L4.6596 12.7166C3.57757 10.8731 0.699387 6.95693 0.670357 6.91758L0.585938 6.80285L1.66876 5.73317L4.76732 7.89681C6.70934 5.38699 8.51847 3.65968 9.70196 2.6474C11.0094 1.52905 11.8372 1.02863 11.8716 1.00787L11.9107 0.984375H13.8186L13.4955 1.27213C9.41548 4.90614 4.98911 12.6371 4.94486 12.7147L4.80386 12.9623Z" fill="#BB976D"/>
                                    </svg>
                                    {{el}}
                                </li>
                            </ul>
                        </div>
                        <div class="mt-4 md:mt-6">
                            <router-link class="btn btn-theme-outline duration-300 group-hover:border-primary" to="#" data-text="Subscribe">
                                <span class="duration-300 group-hover:text-primary">Subscribe</span>
                            </router-link>
                        </div>
                    </div>
                </div>
            </div>
        </div>

         <div class="bg-[#FFF7F0] dark:bg-primary dark:bg-opacity-10 py-12">
            <div class="container">

            </div>
        </div>

        <FooterOne/>

        <ScrollToTop/>
    </div>
</template>

<script setup>
    import { onMounted, ref } from 'vue';
    import NavbarOne from '@/components/navbar/navbar-one.vue';
    import FooterOne from '@/components/footer/footer-one.vue';
    import ScrollToTop from '@/components/scroll-to-top.vue';

    import bg from '@/assets/img/shortcode/breadcumb.jpg'
    import about from '@/assets/img/svg/about.svg'

    import Aos from 'aos';

    import { pricingData } from '@/data/data';


    onMounted(()=>{
        Aos.init()
    })

    const price = ref(true)

    const  onInputChange=()=>{
        price.value = !price.value
    }
</script>
