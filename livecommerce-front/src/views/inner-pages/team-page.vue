<template>
    <div>
        <NavbarOne/>

        <div class="flex items-center gap-4 flex-wrap bg-overlay p-14 sm:p-16 before:bg-title before:bg-opacity-70" :style="{backgroundImage:'url(' + bg + ')'}">
            <div class="text-center w-full">
                <h2 class="text-white text-8 md:text-[40px] font-normal leading-none text-center">Team Member</h2>
                <ul class="flex items-center justify-center gap-[10px] text-base md:text-lg leading-none font-normal text-white mt-3 md:mt-4">
                    <li><router-link to="/">Home</router-link></li>
                    <li>/</li>
                    <li class="text-primary">Team</li>
                </ul>
            </div>
        </div>

        <div class="py-16">
            <div class="container-fluid">
                <div class="max-w-[1720px] mx-auto grid lg:grid-cols-2 gap-[30px]">
                    <div v-for="(item, index) in teamDataTwo" :key="index" class="group sm:grid sm:grid-cols-2 bg-[#F8F5F0] dark:bg-[#1E2A35]" data-aos="fade-up">
                        <div :class="item.class1">
                            <img class="w-full object-cover h-full" :src="item.image" alt="team member">
                        </div>
                        <div :class="item.class2">
                            <div class="sm:max-w-[294px]">
                                <h4 class="font-semibold leading-none text-xl md:text-2xl duration-300 transition-all group-hover:text-primary"><router-link to="#">{{item.name}}</router-link></h4>
                                <span class="text-title dark:text-white-light leading-none mt-[10px] block">{{item.position}}</span>
                                <p class="mt-[15px]">{{item.desc}}</p>
                                <div class="flex items-center gap-5 md:gap-6 mt-[15px]">
                                    <router-link to="#" class="hover:text-primary dark:hover:text-primary transition-all duration-300 text-paragraph dark:text-white">
                                        <i class="fa-brands fa-facebook-f"></i>
                                    </router-link>
                                    <router-link to="#" class="hover:text-primary dark:hover:text-primary transition-all duration-300 text-paragraph dark:text-white">
                                        <i class="fa-brands fa-twitter"></i>
                                    </router-link>
                                    <router-link to="#" class="hover:text-primary dark:hover:text-primary transition-all duration-300 text-paragraph dark:text-white">
                                        <i class="fa-brands fa-instagram"></i>
                                    </router-link>
                                    <router-link to="#" class="hover:text-primary dark:hover:text-primary transition-all duration-300 text-paragraph dark:text-white">
                                        <i class="fa-brands fa-linkedin-in"></i>
                                    </router-link>
                                </div>
                            </div>
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
    import ScrollToTop from '@/components/scroll-to-top.vue';
    import FooterOne from '@/components/footer/footer-one.vue';

    import bg from '@/assets/img/shortcode/breadcumb.jpg'
    import Aos from 'aos';
    import { teamDataTwo } from '@/data/data';

    onMounted(()=>{
        Aos.init()
    })

</script>
