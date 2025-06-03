<template>
    <div>
        <NavbarOne/>

        <div class="flex">
            <div class="w-1/2 hidden md:block lg:flex-1">
                <img class="h-full object-cover" :src="bg" alt="forget password">
            </div>
            <div class="w-full md:w-1/2 lg:max-w-lg xl:max-w-3xl lg:w-full py-16 px-[20px] sm:px-8 lg:p-16 xl:p-24 relative z-10 flex items-center overflow-hidden">
                <div class="mx-auto md:mx-0 max-w-md">
                    <h2 class="leading-none" data-aos="fade-up">Forget Password</h2>
                    <p class="text-lg mt-[15px]" data-aos="fade-up" data-aos-delay="100">Buy & sale your exclusive product only on Furnixar</p>
                    <div class="mt-7" data-aos="fade-up" data-aos-delay="200">
                        <label class="text-base sm:text-lg font-medium leading-none mb-2.5 block dark:text-white">Email</label>
                        <input class="w-full h-12 md:h-14 bg-white dark:bg-transparent border border-bdr-clr focus:border-primary p-4 outline-none duration-300" type="email" placeholder="Enter your email address">
                    </div>
                    <div data-aos="fade-up" data-aos-delay="300">
                        <router-link to="#" class="btn btn-theme-solid mt-[15px]" data-text="Send Info">
                            <span>Send Info</span>
                        </router-link>
                    </div>
                    <p class="text-lg mt-[15px]" data-aos="fade-up" data-aos-delay="400">
                        Note: We will send a password reset link to your email
                    </p>
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

    import bg from '@/assets/img/bg/forget-pass.jpg'
    import Aos from 'aos';

    onMounted(()=>{
        Aos.init()
    })
</script>
