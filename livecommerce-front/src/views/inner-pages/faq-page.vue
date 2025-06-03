<template>
    <div>
        <NavbarOne/>

        <div class="flex items-center gap-4 flex-wrap bg-overlay p-14 sm:p-16 before:bg-title before:bg-opacity-70" :style="{backgroundImage:'url(' + bg + ')'}">
            <div class="text-center w-full">
                <h2 class="text-white text-8 md:text-[40px] font-normal leading-none text-center">FAQs</h2>
                <ul class="flex items-center justify-center gap-[10px] text-base md:text-lg leading-none font-normal text-white mt-3 md:mt-4">
                    <li><router-link to="/">Home</router-link></li>
                    <li>/</li>
                    <li class="text-primary">FAQS</li>
                </ul>
            </div>
        </div>

        <div class="s-py-100">
            <div class="container-fluid max-w-[1720px]">
                <div class="faq-wrapper grid lg:grid-cols-2 gap-12 2xl:gap-20">

                    <div class="faq-left" data-aos="fade-up">
                        <h3 class="font-semibold leading-none mb-4 md:mb-6 text-2xl md:text-3xl">For Shipping</h3>
                        <div class="single-faq mb-4" :class="activeIndex === 1 ? 'active' : ''"  @click="onTabClick(1)">
                            <div class="faq-head p-3 sm:p-5 bg-[#F3F4F5] dark:bg-dark-secondary duration-300 flex items-center justify-between gap-5">
                                <button class="font-medium text-base sm:text-xl text-left text-title dark:text-white">How long does it take for home delivery?</button>
                                <div class="plus">
                                    <span></span>
                                    <span></span>
                                </div>
                            </div>
                            <div class="faq-body p-4 pb-0 max-w-[733px]" :class="activeIndex === 1 ? 'block' : 'hidden'">
                                <p class="text-base sm:text-lg">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Non, lobortis in in tortor lectus iaculis viverra. Adipiscing loborti nam pulvinar elementum.Tellus vulputate habitasse ut diam. Auctor sit lorem ipsum dolor sit amet elementum.</p>
                                <p class="mt-2 text-base sm:text-lg">Lorem ipsum dolor. possimus optio atque nemo magni, illo ratione nobis sed. Modi quasi fuga alias voluptatum sed veniam atque qui.</p>
                            </div>
                        </div>
                        <div class="single-faq mb-4" :class="activeIndex === 2 ? 'active' : ''" @click="onTabClick(2)">
                            <div class="faq-head p-3 sm:p-5 bg-[#F3F4F5] dark:bg-dark-secondary duration-300 flex items-center justify-between gap-5">
                                <button class="font-medium text-base sm:text-xl text-left text-title dark:text-white">Do you deliver on Weekend?</button>
                                <div class="plus">
                                    <span></span>
                                    <span></span>
                                </div>
                            </div>
                            <div class="faq-body p-4 pb-0 max-w-[733px]" :class="activeIndex === 2 ? 'block' : 'hidden'">
                                <p class="text-base sm:text-lg">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Non, lobortis in in tortor lectus iaculis viverra. Adipiscing lobortis interdum fringilla euismod odio vitae nam .</p>
                                <ul class="mt-4 flex flex-col gap-[10px] text-base sm:text-lg list-[lower-roman] pl-5">
                                    <li>Nibh purus integer elementum in tellus vulputate habitasse</li>
                                    <li>Lorem ipsum dolor sit amet, consectetur adipiscing elit. </li>
                                    <li>Generators on the Internet tend to repeat predefined good quality furniture.</li>
                                </ul>
                            </div>
                        </div>
                        <div class="single-faq mb-4" :class="activeIndex === 3 ? 'active' : ''" @click="onTabClick(3)">
                            <div class="faq-head p-3 sm:p-5 bg-[#F3F4F5] dark:bg-dark-secondary duration-300 flex items-center justify-between gap-5">
                                <button class="font-medium text-base sm:text-xl text-left text-title dark:text-white">I paid £5.95 for delivery, why did I not get it next day?</button>
                                <div class="plus">
                                    <span></span>
                                    <span></span>
                                </div>
                            </div>
                            <div class="faq-body p-4 pb-0 max-w-[733px]" :class="activeIndex === 3 ? 'block' : 'hidden'">
                                <p class="text-base sm:text-lg">Nihil quia ab aliquam facere sit officiis est sint magnam nobis eum rem animi mollitia aut repellat consequuntur minima illo consectetur, cumque, quam ut nostrum. Nobis commodi eum quidem repudiandae placeat eos voluptates harum cupiditate, sapiente nisi aliquam, quia quos, exercitationem ipsam illum! Maxime, labore. Eveniet distinctio iusto placeat facere tempore ipsum, rem deserunt quas sint delectus in minus soluta id repudiandae reiciendis exercitationem reprehenderit.</p>
                            </div>
                        </div>
                        <div class="single-faq" :class="activeIndex === 4 ? 'active' : ''" @click="onTabClick(4)">
                            <div class="faq-head p-3 sm:p-5 bg-[#F3F4F5] dark:bg-dark-secondary duration-300 flex items-center justify-between gap-5">
                                <button class="font-medium text-base sm:text-xl text-left text-title dark:text-white">Can I collect from a local store?</button>
                                <div class="plus">
                                    <span></span>
                                    <span></span>
                                </div>
                            </div>
                            <div class="faq-body p-4 pb-0 max-w-[733px]" :class="activeIndex === 4 ? 'block' : 'hidden'">
                                <ul class="flex flex-col gap-[10px] text-base sm:text-lg list-disc pl-5">
                                    <li>Life time warrenty & 24 hour service.</li>
                                    <li>Good Product Quality & Leather from abroad. </li>
                                    <li>Generators on the Internet tend to repeat predefined.</li>
                                </ul>
                            </div>
                        </div>

                        <div class="mt-12" data-aos="fade-up" data-aos-delay="200">
                            <h3 class="font-semibold leading-none mb-4 md:mb-6 text-2xl md:text-3xl">Warranty & Support</h3>
                            <div class="single-faq mb-4" :class="activeIndex2 === 1 ? 'active' : ''" @click="onTabClick2(1)">
                                <div class="faq-head p-3 sm:p-5 bg-[#F3F4F5] dark:bg-dark-secondary duration-300 flex items-center justify-between gap-5">
                                    <button class="font-medium text-base sm:text-xl text-left text-title dark:text-white">How long does it take for home delivery?</button>
                                    <div class="plus">
                                        <span></span>
                                        <span></span>
                                    </div>
                                </div>
                                <div class="faq-body p-4 pb-0 max-w-[733px]" :class="activeIndex2 === 1 ? 'block' : 'hidden'">
                                    <p class="text-base sm:text-lg">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Non, lobortis in in tortor lectus iaculis viverra. Adipiscing loborti nam pulvinar elementum.Tellus vulputate habitasse ut diam. Auctor sit lorem ipsum dolor sit amet elementum.</p>
                                    <p class="mt-2 text-base sm:text-lg">Lorem ipsum dolor. possimus optio atque nemo magni, illo ratione nobis sed. Modi quasi fuga alias voluptatum sed veniam atque qui.</p>
                                </div>
                            </div>
                            <div class="single-faq mb-4" :class="activeIndex2 === 2 ? 'active' : ''" @click="onTabClick2(2)">
                                <div class="faq-head p-3 sm:p-5 bg-[#F3F4F5] dark:bg-dark-secondary duration-300 flex items-center justify-between gap-5">
                                    <button class="font-medium text-base sm:text-xl text-left text-title dark:text-white">Do you deliver on Weekend?</button>
                                    <div class="plus">
                                        <span></span>
                                        <span></span>
                                    </div>
                                </div>
                                <div class="faq-body p-4 pb-0 max-w-[733px]" :class="activeIndex2 === 2 ? 'block' : 'hidden'">
                                    <p class="text-base sm:text-lg">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Non, lobortis in in tortor lectus iaculis viverra. Adipiscing lobortis interdum fringilla euismod odio vitae nam .</p>
                                    <ul class="mt-4 flex flex-col gap-[10px] text-base sm:text-lg list-[lower-roman] pl-5">
                                        <li>Nibh purus integer elementum in tellus vulputate habitasse</li>
                                        <li>Lorem ipsum dolor sit amet, consectetur adipiscing elit. </li>
                                        <li>Generators on the Internet tend to repeat predefined good quality furniture.</li>
                                    </ul>
                                </div>
                            </div>
                            <div class="single-faq" :class="activeIndex2 === 3 ? 'active' : ''" @click="onTabClick2(3)">
                                <div class="faq-head p-3 sm:p-5 bg-[#F3F4F5] dark:bg-dark-secondary duration-300 flex items-center justify-between gap-5">
                                    <button class="font-medium text-base sm:text-xl text-left text-title dark:text-white">I paid £5.95 for delivery, why did I not get it next day?</button>
                                    <div class="plus">
                                        <span></span>
                                        <span></span>
                                    </div>
                                </div>
                                <div class="faq-body p-4 pb-0 max-w-[733px]" :class="activeIndex2 === 3 ? 'block' : 'hidden'">
                                    <p class="text-base sm:text-lg">Nihil quia ab aliquam facere sit officiis est sint magnam nobis eum rem animi mollitia aut repellat consequuntur minima illo consectetur, cumque, quam ut nostrum. Nobis commodi eum quidem repudiandae placeat eos voluptates harum cupiditate, sapiente nisi aliquam, quia quos, exercitationem ipsam illum! Maxime, labore. Eveniet distinctio iusto placeat facere tempore ipsum, rem deserunt quas sint delectus in minus soluta id repudiandae reiciendis exercitationem reprehenderit.</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="faq-right" data-aos="fade-up" data-aos-delay="100">
                        <h3 class="font-semibold leading-none mb-4 md:mb-6 text-2xl md:text-3xl">Order & Payment</h3>
                        <div class="single-faq mb-4" :class="activeIndex3 === 1 ? 'active' : ''" @click="onTabClick3(1)">
                            <div class="faq-head p-3 sm:p-5 bg-[#F3F4F5] dark:bg-dark-secondary duration-300 flex items-center justify-between gap-5">
                                <button class="font-medium text-base sm:text-xl text-left text-title dark:text-white">How long does it take for home delivery?</button>
                                <div class="plus">
                                    <span></span>
                                    <span></span>
                                </div>
                            </div>
                            <div class="faq-body p-4 pb-0 max-w-[733px]" :class="activeIndex3 === 1 ? 'block' : 'hidden'">
                                <p class="text-base sm:text-lg">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Non, lobortis in in tortor lectus iaculis viverra. Adipiscing loborti nam pulvinar elementum.Tellus vulputate habitasse ut diam. Auctor sit lorem ipsum dolor sit amet elementum.</p>
                                <p class="mt-2 text-base sm:text-lg">Lorem ipsum dolor. possimus optio atque nemo magni, illo ratione nobis sed. Modi quasi fuga alias voluptatum sed veniam atque qui.</p>
                            </div>
                        </div>
                        <div class="single-faq mb-4" :class="activeIndex3 === 2 ? 'active' : ''" @click="onTabClick3(2)">
                            <div class="faq-head p-3 sm:p-5 bg-[#F3F4F5] dark:bg-dark-secondary duration-300 flex items-center justify-between gap-5">
                                <button class="font-medium text-base sm:text-xl text-left text-title dark:text-white">I paid £5.95 for delivery, why did I not get it next day?</button>
                                <div class="plus">
                                    <span></span>
                                    <span></span>
                                </div>
                            </div>
                            <div class="faq-body p-4 pb-0 max-w-[733px]" :class="activeIndex3 === 2 ? 'block' : 'hidden'">
                                <p class="text-base sm:text-lg">Nihil quia ab aliquam facere sit officiis est sint magnam nobis eum rem animi mollitia aut repellat consequuntur minima illo consectetur, cumque, quam ut nostrum. Nobis commodi eum quidem repudiandae placeat eos voluptates harum cupiditate, sapiente nisi aliquam, quia quos, exercitationem ipsam illum! Maxime, labore. Eveniet distinctio iusto placeat facere tempore ipsum, rem deserunt quas sint delectus in minus soluta id repudiandae reiciendis exercitationem reprehenderit.</p>
                            </div>
                        </div>
                        <div class="single-faq mb-4" :class="activeIndex3 === 3 ? 'active' : ''" @click="onTabClick3(3)">
                            <div class="faq-head p-3 sm:p-5 bg-[#F3F4F5] dark:bg-dark-secondary duration-300 flex items-center justify-between gap-5">
                                <button class="font-medium text-base sm:text-xl text-left text-title dark:text-white">Do you deliver on Weekend?</button>
                                <div class="plus">
                                    <span></span>
                                    <span></span>
                                </div>
                            </div>
                            <div class="faq-body p-4 pb-0 max-w-[733px]" :class="activeIndex3 === 3 ? 'block' : 'hidden'">
                                <ul class="flex flex-col gap-[10px] text-base sm:text-lg">
                                    <li class="flex items-start gap-[10px]">
                                        <svg class="mt-[5px] flex-none" width="14" height="13" viewBox="0 0 14 13" fill="none" xmlns="http://www.w3.org/2000/svg">
                                            <path d="M4.21793 12.5366L4.07367 12.2908C2.99163 10.4473 0.11345 6.53115 0.0844199 6.4918L0 6.37707L1.08283 5.30739L4.18138 7.47103C6.1234 4.96121 7.93253 3.2339 9.11602 2.22162C10.4234 1.10327 11.2512 0.602847 11.2857 0.582088L11.3248 0.558594H13.2327L12.9096 0.846352C8.82955 4.48036 4.40317 12.2113 4.35892 12.289L4.21793 12.5366Z" fill="#BB976D"/>
                                        </svg>
                                        <span class="flex-1">All the Lorem Ipsum generators on the Internet tend to repeat predefined on the Internet.</span>
                                    </li>
                                    <li class="flex items-start gap-[10px]">
                                        <svg class="mt-[5px] flex-none" width="14" height="13" viewBox="0 0 14 13" fill="none" xmlns="http://www.w3.org/2000/svg">
                                            <path d="M4.21793 12.5366L4.07367 12.2908C2.99163 10.4473 0.11345 6.53115 0.0844199 6.4918L0 6.37707L1.08283 5.30739L4.18138 7.47103C6.1234 4.96121 7.93253 3.2339 9.11602 2.22162C10.4234 1.10327 11.2512 0.602847 11.2857 0.582088L11.3248 0.558594H13.2327L12.9096 0.846352C8.82955 4.48036 4.40317 12.2113 4.35892 12.289L4.21793 12.5366Z" fill="#BB976D"/>
                                        </svg>
                                        <span class="flex-1">Nibh purus integer elementum in tellus vulputate habitasse</span>
                                    </li>
                                    <li class="flex items-start gap-[10px]">
                                        <svg class="mt-[5px] flex-none" width="14" height="13" viewBox="0 0 14 13" fill="none" xmlns="http://www.w3.org/2000/svg">
                                            <path d="M4.21793 12.5366L4.07367 12.2908C2.99163 10.4473 0.11345 6.53115 0.0844199 6.4918L0 6.37707L1.08283 5.30739L4.18138 7.47103C6.1234 4.96121 7.93253 3.2339 9.11602 2.22162C10.4234 1.10327 11.2512 0.602847 11.2857 0.582088L11.3248 0.558594H13.2327L12.9096 0.846352C8.82955 4.48036 4.40317 12.2113 4.35892 12.289L4.21793 12.5366Z" fill="#BB976D"/>
                                        </svg>
                                        <span class="flex-1">Lorem ipsum dolor sit amet, consectetur adipiscing elit. </span>
                                    </li>
                                    <li class="flex items-start gap-[10px]">
                                        <svg class="mt-[5px] flex-none" width="14" height="13" viewBox="0 0 14 13" fill="none" xmlns="http://www.w3.org/2000/svg">
                                            <path d="M4.21793 12.5366L4.07367 12.2908C2.99163 10.4473 0.11345 6.53115 0.0844199 6.4918L0 6.37707L1.08283 5.30739L4.18138 7.47103C6.1234 4.96121 7.93253 3.2339 9.11602 2.22162C10.4234 1.10327 11.2512 0.602847 11.2857 0.582088L11.3248 0.558594H13.2327L12.9096 0.846352C8.82955 4.48036 4.40317 12.2113 4.35892 12.289L4.21793 12.5366Z" fill="#BB976D"/>
                                        </svg>
                                        <span class="flex-1">Generators on the Internet tend to repeat predefined good quality furniture.</span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <div class="single-faq" :class="activeIndex3 === 4 ? 'active' : ''" @click="onTabClick3(4)">
                            <div class="faq-head p-3 sm:p-5 bg-[#F3F4F5] dark:bg-dark-secondary duration-300 flex items-center justify-between gap-5">
                                <button class="font-medium text-base sm:text-xl text-left text-title dark:text-white">Can I collect from a local store?</button>
                                <div class="plus">
                                    <span></span>
                                    <span></span>
                                </div>
                            </div>
                            <div class="faq-body p-4 pb-0 max-w-[733px]" :class="activeIndex3 === 4 ? 'block' : 'hidden'">
                                <ul class="flex flex-col gap-[10px] text-base sm:text-lg list-disc pl-5">
                                    <li>Life time warrenty & 24 hour service.</li>
                                    <li>Good Product Quality & Leather from abroad. </li>
                                    <li>Generators on the Internet tend to repeat predefined.</li>
                                </ul>
                            </div>
                        </div>

                        <div class="mt-12" data-aos="fade-up" data-aos-delay="200">
                            <h3 class="font-semibold leading-none mb-4 md:mb-6 text-2xl md:text-3xl">Product Return</h3>

                            <div class="single-faq mb-4" :class="activeIndex4 === 1 ? 'active' : ''" @click="onTabClick4(1)">
                                <div class="faq-head p-3 sm:p-5 bg-[#F3F4F5] dark:bg-dark-secondary duration-300 flex items-center justify-between gap-5">
                                    <button class="font-medium text-base sm:text-xl text-left text-title dark:text-white">How long does it take for home delivery?</button>
                                    <div class="plus">
                                        <span></span>
                                        <span></span>
                                    </div>
                                </div>
                                <div class="faq-body p-4 pb-0 max-w-[733px]" :class="activeIndex4 === 1 ? 'block' : 'hidden'">
                                    <p class="text-base sm:text-lg">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Non, lobortis in in tortor lectus iaculis viverra. Adipiscing loborti nam pulvinar elementum.Tellus vulputate habitasse ut diam. Auctor sit lorem ipsum dolor sit amet elementum.</p>
                                    <p class="mt-2 text-base sm:text-lg">Lorem ipsum dolor. possimus optio atque nemo magni, illo ratione nobis sed. Modi quasi fuga alias voluptatum sed veniam atque qui.</p>
                                </div>
                            </div>

                            <div class="single-faq mb-4" :class="activeIndex4 === 2 ? 'active' : ''" @click="onTabClick4(2)">
                                <div class="faq-head p-3 sm:p-5 bg-[#F3F4F5] dark:bg-dark-secondary duration-300 flex items-center justify-between gap-5">
                                    <button class="font-medium text-base sm:text-xl text-left text-title dark:text-white">Do you deliver on Weekend?</button>
                                    <div class="plus">
                                        <span></span>
                                        <span></span>
                                    </div>
                                </div>
                                <div class="faq-body p-4 pb-0 max-w-[733px]" :class="activeIndex4 === 2 ? 'block' : 'hidden'">
                                    <p class="text-base sm:text-lg">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Non, lobortis in in tortor lectus iaculis viverra. Adipiscing lobortis interdum fringilla euismod odio vitae nam .</p>
                                    <ul class="mt-4 flex flex-col gap-[10px] text-base sm:text-lg list-[lower-roman] pl-5">
                                        <li>Nibh purus integer elementum in tellus vulputate habitasse</li>
                                        <li>Lorem ipsum dolor sit amet, consectetur adipiscing elit. </li>
                                        <li>Generators on the Internet tend to repeat predefined good quality furniture.</li>
                                    </ul>
                                </div>
                            </div>

                            <div class="single-faq" :class="activeIndex4 === 3 ? 'active' : ''" @click="onTabClick4(3)">
                                <div class="faq-head p-3 sm:p-5 bg-[#F3F4F5] dark:bg-dark-secondary duration-300 flex items-center justify-between gap-5">
                                    <button class="font-medium text-base sm:text-xl text-left text-title dark:text-white">I paid £5.95 for delivery, why did I not get it next day?</button>
                                    <div class="plus">
                                        <span></span>
                                        <span></span>
                                    </div>
                                </div>
                                <div class="faq-body p-4 pb-0 max-w-[733px]" :class="activeIndex4 === 3 ? 'block' : 'hidden'">
                                    <p class="text-base sm:text-lg">Nihil quia ab aliquam facere sit officiis est sint magnam nobis eum rem animi mollitia aut repellat consequuntur minima illo consectetur, cumque, quam ut nostrum. Nobis commodi eum quidem repudiandae placeat eos voluptates harum cupiditate, sapiente nisi aliquam, quia quos, exercitationem ipsam illum! Maxime, labore. Eveniet distinctio iusto placeat facere tempore ipsum, rem deserunt quas sint delectus in minus soluta id repudiandae reiciendis exercitationem reprehenderit.</p>
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
    import { onMounted, ref } from 'vue';
    import NavbarOne from '@/components/navbar/navbar-one.vue';
    import bg from '@/assets/img/shortcode/breadcumb.jpg'
    import Aos from 'aos';
import FooterOne from '@/components/footer/footer-one.vue';
import ScrollToTop from '@/components/scroll-to-top.vue';

    onMounted(()=>{
        Aos.init()
    })

    const activeIndex = ref(0)
    const activeIndex2 = ref(0)
    const activeIndex3 = ref(0)
    const activeIndex4 = ref(0)

    const  onTabClick = (index) =>{
        if(activeIndex.value === index){
            activeIndex.value = 0
        }else{activeIndex.value = index}
    }
    const  onTabClick2 = (index) =>{
        if(activeIndex2.value === index){
            activeIndex2.value = 0
        }else{activeIndex2.value = index}
    }
    const  onTabClick3 = (index) =>{
        if(activeIndex3.value === index){
            activeIndex3.value = 0
        }else{activeIndex3.value = index}
    }
    const  onTabClick4 = (index) =>{
        if(activeIndex4.value === index){
            activeIndex4.value = 0
        }else{activeIndex4.value = index}
    }
</script>
