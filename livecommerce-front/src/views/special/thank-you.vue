<template>
    <div>
        <NavbarOne/>

        <div class="py-16 sm:py-24">
            <div class="container">
                <div class="max-w-[710px] mx-auto text-center p-7 sm:p-10 lg:p-12">
                    <div class="div">
                        <img :src="bg" alt="thank-you">
                    </div>
                    <h3 class="leading-[1.2] mt-4 md:mt-6 text-2xl md:text-[32px] font-bold text-title dark:text-white">
                    무병장수를 이용해 주셔서 감사합니다
                    </h3>
                    <p class="mt-3 text-base sm:text-lg text-paragraph dark:text-white">
                        영수증을 이메일로 발송해드렸습니다. <router-link to="/" class="text-primary underline">여기를 클릭</router-link>하여 확인하실 수 있습니다.
                    </p>
                    <router-link to="/" class='btn btn-solid mt-4 md:mt-6' data-text="메인으로 돌아가기">
                        <span>메인으로 돌아가기</span>
                    </router-link>
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
    import FooterOne from '@/components/footer/footer-one.vue';
    import ScrollToTop from '@/components/scroll-to-top.vue';

    import bg from '@/assets/img/thank-you.png'
    
    import Aos from 'aos';

    onMounted(()=>{
        Aos.init()
    })
</script>
