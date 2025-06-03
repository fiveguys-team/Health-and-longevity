<template>
    <div>
        <div class="pt-8 sm:pt-12 relative z-10">
            <img class="absolute top-0 left-[5%] -z-10 w-[12%]" :src="thumbImg" alt="light">
            <img class="absolute bottom-0 right-0 w-1/4 -z-10" :src="shape" alt="shape">
            <div class="container">
                <div class="text-center">
                    <router-link class="cursor-pointer inline-block" to="/">
                        <img :src="logoDark" alt="" class='dark:hidden w-[120px] sm:w-[200px]'/> 
                        <img :src="logoLight" alt="" class='dark:block hidden w-[120px] sm:w-[200px]'/>
                    </router-link>
                </div>
                <div class="text-center py-16 sm:py-24 lg:py-[150px]">
                    <h1 class="text-3xl sm:text-5xl md:text-6xl lg:text-7xl leading-none" data-aos="fade-up">We are Coming Soon</h1>
                    <p class="max-w-[503px] mx-auto mt-3 sm:mt-6 text-base sm:text-lg" data-aos="fade-up" data-aos-delay="100">Our website is under construction.
                    We'll be here soon with our new awesome site.</p>
                    <div class="countdown-clock flex gap-8 md:gap-12 justify-center items-center mt-10 sm:mt-12" data-aos="fade-up" data-aos-delay="200">
                        <div class="countdown-item">
                            <div class="ci-inner font-[300] text-title dark:text-white leading-none text-4xl md:text-5xl">
                                <div class="clock-days ci-value">{{ days }}</div>
                            </div>
                            <p class="text-sm sm:text-lg md:text-xl leading-none mt-[10px]">Days</p>
                        </div>
                        <div class="hidden sm:block">
                            <svg width="25" height="41" viewBox="0 0 25 41" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <line x1="1.33261" y1="40.0015" x2="24.2798" y2="0.255847" stroke="#BB976D"/>
                            </svg>
                        </div>
                        <div class="countdown-item">
                            <div class="ci-inner font-[300] text-title dark:text-white leading-none text-4xl md:text-5xl">
                                <div class="clock-hours ci-value">{{ hours }}</div>
                            </div>
                            <p class="text-sm sm:text-lg md:text-xl leading-none mt-[10px]">Hours</p>
                        </div>
                        <div class="hidden sm:block">
                            <svg width="25" height="41" viewBox="0 0 25 41" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <line x1="1.33261" y1="40.0015" x2="24.2798" y2="0.255847" stroke="#BB976D"/>
                            </svg>
                        </div>
                        <div class="countdown-item">
                            <div class="ci-inner font-[300] text-title dark:text-white leading-none text-4xl md:text-5xl">
                                <div class="clock-minutes ci-value">{{ minutes }}</div>
                            </div>
                            <p class="text-sm sm:text-lg md:text-xl leading-none mt-[10px]">Minutes</p>
                        </div>
                        <div class="hidden sm:block">
                            <svg width="25" height="41" viewBox="0 0 25 41" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <line x1="1.33261" y1="40.0015" x2="24.2798" y2="0.255847" stroke="#BB976D"/>
                            </svg>
                        </div>
                        <div class="countdown-item">
                            <div class="ci-inner font-[300] text-title dark:text-white leading-none text-4xl md:text-5xl">
                                <div class="clock-seconds ci-value">{{ seconds }}</div>
                            </div>
                            <p class="texttext-sm sm:text-lg md:text-xl leading-none mt-[10px]">Seconds</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="coming-soon-footer py-12 sm:py-20 lg:py-28 bg-overlay relative z-20" :style="{backgroundImage:'url(' + bg + ')'}">
            <img class="absolute bottom-10 right-0 w-[25%] hidden sm:block" :src="shape2" alt="shape">
            <div class="container">
                <div class="flex items-center justify-center">
                    <div class="max-w-md">
                        <h2 class="font-bold leading-none dark:text-white" data-aos="fade-up">Subscribe to be Notified</h2>
                        <p class="mt-3 md:mt-5 dark:text-white-light" data-aos="fade-up" data-aos-delay="100">Stay updated with our latest news, tips, and exclusive offers! Subscribe to our newsletter and never miss out on what’s new. </p>
                        <div class="mt-4 lg:mt-6 sm:flex" data-aos="fade-up" data-aos-delay="200">
                            <input class="w-full h-12 md:h-14 bg-snow border dark:bg-snow dark:bg-opacity-5 border-title focus:border-primary border-opacity-10 duration-300 p-4 outline-none dark:text-white sm:flex-1 sm:border-r-0" type="text" placeholder="Enter your email address">
                            <button class="w-full h-12 bg-title text-white flex items-center justify-center text-base md:text-lg font-medium p-3 mt-3 sm:mt-0 sm:w-32 sm:h-auto sm:flex-none dark:bg-primary dark:text-title">Subscribe</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="switcher z-20 w-12 sm:w-[60px] h-12 sm:h-[60px] fixed bottom-[10px] md:bottom-5 left-[10px] md:left-5 rounded-xl flex items-center justify-center cursor-pointer">
            <SwitcherS/>
        </div>
    </div>
</template>

<script setup>
    import { ref, computed, watch,onMounted} from 'vue'

    import SwitcherS from '@/components/switcher-s.vue'

    import thumbImg from '@/assets/img/thumb/coming-soon.png'
    import bg from '@/assets/img/bg/coming-soon-bg.jpg'
    import shape from '@/assets/img/shape/coming-soon-shape.png'
    import logoDark from '@/assets/img/svg/logo.svg'
    import logoLight from '@/assets/img/svg/logo-light.svg'
    import shape2 from '@/assets/img/thumb/coming-soon-shape.png'
    import Aos from 'aos';

    onMounted(()=>{
        Aos.init()
    })



    const now = ref(new Date().getTime())


    const targetTime = ref(new Date("Sep 13 2025").getTime())

    const difference = ref(0)

    const days = computed(() => Math.floor(difference.value / (1000 * 60 * 60 * 24)))
    const hours = computed(() => 23 - new Date(now.value).getHours())
    const minutes = computed(() => 60 - new Date(now.value).getMinutes())
    const seconds = computed(() => 60 - new Date(now.value).getSeconds())

    watch(now, () => {
        difference.value = targetTime.value - now.value
    })

    function updateNow() {
        now.value = new Date().getTime()
    }

    updateNow()
    setInterval(updateNow, 1000)
</script>
