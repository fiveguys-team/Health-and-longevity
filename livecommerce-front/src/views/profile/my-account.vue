<template>
    <div>
        <NavbarOne/>

        <div class="flex items-center gap-4 flex-wrap bg-overlay p-14 sm:p-16 before:bg-title before:bg-opacity-70" :style="{backgroundImage:'url(' + bg + ')'}">
            <div class="text-center w-full">
                <h2 class="text-white text-8 md:text-[40px] font-normal leading-none text-center">My Account</h2>
                <ul class="flex items-center justify-center gap-[10px] text-base md:text-lg leading-none font-normal text-white mt-3 md:mt-4">
                    <li><router-link to="/">Home</router-link></li>
                    <li>/</li>
                    <li class="text-primary">Account</li>
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
                        <div class="w-full max-w-[951px] bg-[#F8F8F9] dark:bg-dark-secondary p-5 sm:p-8 lg:p-[50px]">
                            <div>
                                <h3 class="font-semibold leading-none">Kathlene Roser</h3>
                                <span class="leading-none mt-3">Product Designer</span>
                            </div>
                            <p class="text-base sm:text-lg mt-5 sm:mt-8 md:mt-10 text-justify">
                                All the Lorem Ipsum generators on the Internet tend to repeat predefined on the Internet. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Non, lobortis in in tortor lectus iaculis viverra. Adipiscing lobortis interdum fringilla euismod odio vitae nam pulvinar elementum. Nibh purus integer elementum in. Tellus vulputate habitasse ut vulputate posuere habitant vel tempor varius. 
                            </p>
                            <div class="mt-5 sm:mt-8 md:mt-10 grid gap-4 sm:gap-6">
                                <router-link to="#" class="flex items-center gap-2">
                                    <i class="fa-solid fa-phone text-[#BB976D]"></i>
                                    <span class="leading-none font-medium text-base sm:text-lg">+111 - (1234 5678 99)</span>
                                </router-link>
                                <router-link to="#" class="flex items-center gap-2">
                                    <i class="fa-solid fa-envelope text-[#BB976D]"></i>
                                    <span class="leading-none font-medium text-base sm:text-lg">furnixar123@gmail.com</span>
                                </router-link>
                                <router-link to="#" class="flex items-center gap-2">
                                    <i class="fa-solid fa-location-dot text-[#BB976D]"></i>
                                    <span class="leading-none font-medium text-base sm:text-lg">23/ A Lake Side , New Arizona , USA</span>
                                </router-link>
                            </div>
                        </div>
                        <div class="w-full max-w-[951px] bg-[#F8F8F9] dark:bg-dark-secondary p-5 sm:p-8 lg:p-[50px]">
                            <div class="flex items-start flex-col lg:flex-row gap-5 sm:gap-6">
                                <div class="grid gap-5 sm:gap-6 w-full lg:w-1/2">
                                    <div>
                                        <label class="text-base md:text-lg text-title dark:text-white leading-none mb-2 sm:mb-3 block">Full Name</label>
                                        <input class="w-full h-12 md:h-14 bg-white dark:bg-dark-secondary border border-[#E3E5E6] text-title dark:text-white focus:border-primary p-4 outline-none duration-300" type="text" placeholder="Enter your full name">
                                    </div>
                                    <div>
                                        <label class="text-base md:text-lg text-title dark:text-white leading-none mb-2 sm:mb-3 block">Designation</label>
                                        <input class="w-full h-12 md:h-14 bg-white dark:bg-dark-secondary border border-[#E3E5E6] text-title dark:text-white focus:border-primary p-4 outline-none duration-300" type="text" placeholder="Enter your designation">
                                    </div>
                                    <div>
                                        <label class="text-base md:text-lg text-title dark:text-white leading-none mb-2 sm:mb-3 block">Phone No.</label>
                                        <input class="w-full h-12 md:h-14 bg-white dark:bg-dark-secondary border border-[#E3E5E6] text-title dark:text-white focus:border-primary p-4 outline-none duration-300 appearance-none" type="number" placeholder="Type your phone number">
                                    </div>
                                    <div>
                                        <label class="text-base md:text-lg text-title dark:text-white leading-none mb-2 sm:mb-3 block">Mail</label>
                                        <input class="w-full h-12 md:h-14 bg-white dark:bg-dark-secondary border border-[#E3E5E6] text-title dark:text-white focus:border-primary p-4 outline-none duration-300" type="email" placeholder="Enter your email address">
                                    </div>
                                </div>
                                <div class="grid gap-5 sm:gap-6 w-full lg:w-1/2">
                                    <div>
                                        <label class="text-base md:text-lg text-title dark:text-white leading-none mb-2 sm:mb-3 block">Location</label>
                                        <input class="w-full h-12 md:h-14 bg-white dark:bg-dark-secondary border border-[#E3E5E6] text-title dark:text-white focus:border-primary p-4 outline-none duration-300" type="text" placeholder="Enter your location">
                                    </div>
                                    <div>
                                        <label class="text-base md:text-lg text-title dark:text-white leading-none mb-2 sm:mb-3 block">Bio</label>
                                        <textarea class="w-full h-28 md:h-[168px] bg-white dark:bg-dark-secondary border border-[#E3E5E6] text-title dark:text-white focus:border-primary p-4 outline-none duration-300" name="Message" placeholder="Write your bio . . ."></textarea>
                                    </div>
                                    <div>
                                        <label class="text-base md:text-lg text-title dark:text-white leading-none mb-2 sm:mb-3 block">Web / Social Media</label>
                                        <input class="w-full h-12 md:h-14 bg-white dark:bg-dark-secondary border border-[#E3E5E6] text-title dark:text-white focus:border-primary p-4 outline-none duration-300" type="text" placeholder="www.facebook.com/johndoe">
                                    </div>
                                </div>
                            </div>
                            <div class="mt-5 sm:mt-8 md:mt-12">
                                <button class="btn btn-solid" data-text="Save Change">
                                    <span>Save Change</span>
                                </button>
                            </div>
                        </div>
                        <div class="bg-[#F8F8F9] dark:bg-dark-secondary p-5 sm:p-8 lg:p-[50px] order-history-table">
                            <ul class="order-history">
                                <li class="title flex items-center justify-between gap-5 pb-[10px] sm:pb-5 border-b border-bdr-clr dark:border-bdr-clr-drk">
                                    <span class="cart-product-title text-lg md:text-xl font-semibold leading-none text-title dark:text-white block w-[270px] sm:w-[310px] xl:w-[330px]">Product</span>
                                    <span class="text-lg md:text-xl font-semibold leading-none text-title dark:text-white w-[60px]">Price</span>
                                    <span class="text-lg md:text-xl font-semibold leading-none text-title dark:text-white w-[100px]">Status</span>
                                    <span class="text-lg md:text-xl font-semibold leading-none text-title dark:text-white w-[72px]">Remove</span>
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

                                    <span class="text-base md:text-lg leading-none text-title dark:text-white font-semibold text-left w-[60px]">$74</span>

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

                                    <div class="w-[72px] flex justify-end">
                                        <button class="w-8 h-8 flex-none bg-[#E8E9EA] dark:bg-title flex items-center justify-center duration-300 text-title dark:text-white">
                                            <svg class="fill-current " width="12" height="12" viewBox="0 0 12 12" fill="none" xmlns="http://www.w3.org/2000/svg">
                                                <path d="M0.546875 1.70822L1.70481 0.550293L5.98646 4.83195L10.2681 0.550293L11.3991 1.6813L7.11746 5.96295L11.453 10.2985L10.295 11.4564L5.95953 7.12088L1.67788 11.4025L0.546875 10.2715L4.82853 5.98988L0.546875 1.70822Z"/>
                                            </svg>
                                        </button>
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

    import Aos from 'aos';

    import { cartData } from '@/data/data';

    onMounted(()=>{
        Aos.init()
    })
</script>
