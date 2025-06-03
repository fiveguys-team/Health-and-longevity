<template>
    <div>
        <NavbarOne/>

        <div class="flex items-center gap-4 flex-wrap bg-overlay p-14 sm:p-16 before:bg-title before:bg-opacity-70" :style="{backgroundImage:'url(' + bg + ')'}">
            <div class="text-center w-full">
                <h2 class="text-white text-8 md:text-[40px] font-normal leading-none text-center">Error Page</h2>
                <ul class="flex items-center justify-center gap-[10px] text-base md:text-lg leading-none font-normal text-white mt-3 md:mt-4">
                    <li><router-link to="/">Home</router-link></li>
                    <li>/</li>
                    <li class="text-primary">Error</li>
                </ul>
            </div>
        </div>

        <div class="s-py-100 overflow-hidden">
            <div class="container">
                <div class="flex items-center justify-center gap-5">
                    <h2 class="text-6xl sm:text-[100px] md:text-[150px] font-semibold leading-none" data-aos="fade-right">4</h2>
                    <img class="w-36 sm:w-44 md:w-auto" :src="error" alt="error" data-aos="zoom-in">
                    <h2 class="text-6xl sm:text-[100px] md:text-[150px] font-semibold leading-none" data-aos="fade-left">4</h2>
                </div>
                <div class="max-w-[603px] mx-auto text-center mt-8 md:mt-12">
                    <h2 data-aos="fade-up">Oops Sorry ! Page not found</h2>
                    <p class="mt-4 md:mt-6" data-aos="fade-up">Sorry for the inconvenience. Go to our homepage or check out our  
                    for Fashion, Chair, Decoration...</p>
                    <div data-aos="fade-up" data-aos-delay="100">
                        <router-link class="btn btn-outline mt-4 md:mt-6" to="/" data-text="Go Back To Home">
                            <span>Go Back To Home</span>
                        </router-link>
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
    import FooterOne from '@/components/footer/footer-one.vue';
    import ScrollToTop from '@/components/scroll-to-top.vue';

    import bg from '@/assets/img/shortcode/breadcumb.jpg'
    import error from '@/assets/img/thumb/error.png'

    import Aos from 'aos';

    onMounted(()=>{
        Aos.init()
    })
</script>
