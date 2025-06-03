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
                    For Shopping with Furnixar
                    </h3>
                    <p class="mt-3 text-base sm:text-lg text-paragraph dark:text-white">
                        Please Check your email for Download Invoice . Or <router-link to="/" class="text-primary underline">Click here </router-link>
                    </p>
                    <router-link to="/" class='btn btn-solid mt-4 md:mt-6' data-text="Back to home">
                        <span>Back to home</span>
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
