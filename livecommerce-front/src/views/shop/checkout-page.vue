<template>
    <div>
        <NavbarOne/>

        <div class="flex items-center gap-4 flex-wrap bg-overlay p-14 sm:p-16 before:bg-title before:bg-opacity-70" :style="{backgroundImage:'url(' + bg + ')'}">
            <div class="text-center w-full">
                <h2 class="text-white text-8 md:text-[40px] font-normal leading-none text-center">Checkout</h2>
                <ul class="flex items-center justify-center gap-[10px] text-base md:text-lg leading-none font-normal text-white mt-3 md:mt-4 flex-wrap">
                    <li><router-link to="/">Home</router-link></li>
                    <li>/</li>
                    <li class="text-primary">Checkout</li>
                </ul>
            </div>
        </div>

        <div class="s-py-100">
            <div class="container">
                <div class="max-w-[1220px] mx-auto grid lg:grid-cols-2 gap-[30px] lg:gap-[70px]">
                    <div class="bg-[#FAFAFA] dark:bg-dark-secondary p-[30px] md:p-[40px] lg:p-[50px] border border-[#17243026] border-opacity-15 rounded-xl" data-aos="fade-up">
                        
                        <p class='mb-5 w-full bg-white dark:bg-dark-secondary border border-[#E3E5E6] text-title dark:text-white focus:border-primary p-4 outline-none duration-300 whitespace-normal'>Are you missing your coupon code ? 
                        <button @click="open = !open" class='ml-1 add-coupon-code underline text-[#209A60]'> Click here to add</button>
                        </p>
                        
                        <div v-if="open" class="coupon-wrapper gap-3 md:flex mb-[30px]">
                            <input class="max-w-[220px] w-full h-12 md:h-14 bg-white dark:bg-dark-secondary border border-[#E3E5E6] text-title dark:text-white focus:border-primary p-4 outline-none duration-300" type="text" placeholder="Coupon code">
                            <router-link to="#" class="btn btn-sm-px btn-theme-solid " data-text="Apply coupon">
                                <span>Apply coupon</span>
                            </router-link>
                        </div>

                        
                        <h4 class="font-semibold leading-none text-xl md:text-2xl mb-6 md:mb-[30px]">
                            Billing Information
                        </h4>
                        <div class="grid gap-5 md:gap-6">
                            <div>
                                <label class="text-base md:text-lg text-title dark:text-white leading-none mb-2 sm:mb-3 block">Full Name</label>
                                <input class="w-full h-12 md:h-14 bg-white dark:bg-dark-secondary border border-[#E3E5E6] text-title dark:text-white focus:border-primary p-4 outline-none duration-300" type="text" placeholder="Enter your full name">
                            </div>
                            
                            <div>
                                <label class="text-base md:text-lg text-title dark:text-white leading-none mb-2 sm:mb-3 block">Email</label>
                                <input class="w-full h-12 md:h-14 bg-white dark:bg-dark-secondary border border-[#E3E5E6] text-title dark:text-white focus:border-primary p-4 outline-none duration-300" type="text" placeholder="Enter your email address">
                            </div>

                            <div>
                                <label class="text-base md:text-lg text-title dark:text-white leading-none mb-2 sm:mb-3 block">Phone No.</label>
                                <input class="w-full h-12 md:h-14 bg-white dark:bg-dark-secondary border border-[#E3E5E6] text-title dark:text-white focus:border-primary p-4 outline-none duration-300" type="number" placeholder="Type your phone number">
                            </div>
                        </div>

                        <div class="grid md:grid-cols-2 gap-5 md:gap-6">
                            <div class="mt-5">
                                <label class="text-base md:text-lg text-title dark:text-white leading-none mb-2 sm:mb-3 block">Town / City</label>
                                <select class="nice-select select-active p-4 !bg-white dark:!bg-dark-secondary">
                                    <option value={1}>Sylht</option>
                                    <option value={2}>Dhaka</option>
                                    <option value={2}>Chittagong</option>
                                    <option value={2}>Rajshahi</option>
                                    <option value={2}>Bogura</option>
                                </select>
                            </div>

                            <div class="mt-5">
                                <label class="text-base md:text-lg text-title dark:text-white leading-none mb-2 sm:mb-3 block">Zip Code</label>
                                <input class="w-full h-12 md:h-14 bg-white dark:bg-dark-secondary border border-[#E3E5E6] text-title dark:text-white focus:border-primary p-4 outline-none duration-300" type="text" placeholder="1217">
                            </div>

                            <div>
                                <label class="text-base md:text-lg text-title dark:text-white leading-none mb-2 sm:mb-3 block">Address Line 1</label>
                                <input class="w-full h-12 md:h-14 bg-white dark:bg-dark-secondary border border-[#E3E5E6] text-title dark:text-white focus:border-primary p-4 outline-none duration-300" type="number" placeholder="Your full address">
                            </div>

                            <div>
                                <label class="text-base md:text-lg text-title dark:text-white leading-none mb-2 sm:mb-3 block">
                                    Address Line 2
                                </label>
                                <input class="w-full h-12 md:h-14 bg-white dark:bg-dark-secondary border border-[#E3E5E6] text-title dark:text-white focus:border-primary p-4 outline-none duration-300" type="number" placeholder="Your full address">
                            </div>
                        </div>
                        <div class="mt-5">
                            <label class="text-base md:text-lg text-title dark:text-white leading-none mb-2 sm:mb-3 block">
                                Additional Text
                            </label>
                            <textarea class="w-full h-[120px] bg-white dark:bg-dark-secondary border border-[#E3E5E6] text-title dark:text-white focus:border-primary p-4 outline-none duration-300" name="Message" placeholder="Type your message"></textarea>
                        </div>
                    </div>

                    <div data-aos="fade-up" data-aos-delay={200}>
                        <div class="bg-[#FAFAFA] dark:bg-dark-secondary pt-[30px] md:pt-[40px] lg:pt-[50px] px-[30px] md:px-[40px] lg:px-[50px] pb-[30px] border border-[#17243026] border-opacity-15 rounded-xl">   
                            <h4 class="font-semibold leading-none text-xl md:text-2xl mb-6 md:mb-10">
                                Product Information
                            </h4>
                            <div class="grid gap-5 mg:gap-6">
                                <div class="flex items-center justify-between gap-5">
                                    <div class="flex items-center gap-3 md:gap-4 lg:gap-6 cart-product flex-wrap">
                                        <div class="w-16 sm:w-[70px] flex-none">
                                            <img :src="cart1" alt="product">
                                        </div>
                                        <div class="flex-1">
                                            <h6 class="leading-none font-medium">Chair</h6>
                                            <h5 class="font-semibold leading-none mt-2">
                                                <router-link to="#">Modern Sofa Set</router-link>
                                            </h5>
                                        </div>
                                    </div>
                                
                                    <h6 class="leading-none">$74</h6>
                                </div>
                                <div class="flex items-center justify-between gap-5">
                                    <div class="flex items-center gap-3 md:gap-4 lg:gap-6 cart-product flex-wrap">
                                        <div class="w-16 sm:w-[70px] flex-none">
                                            <img :src="cart2" alt="product">
                                        </div>
                                        <div class="flex-1">
                                            <h6 class="leading-none font-medium">Interior</h6>
                                            <h5 class="font-semibold leading-none mt-2">
                                                <router-link to="#">Chair with Vase</router-link>
                                            </h5>
                                        </div>
                                    </div>
                                    
                                    <h6 class="leading-none">$124</h6>
                                </div>
                                <div class="flex items-center justify-between gap-5">
                                    <div class="flex items-center gap-3 md:gap-4 lg:gap-6 cart-product flex-wrap">
                                        <div class="w-16 sm:w-[70px] flex-none">
                                            <img :src="cart3" alt="product">
                                        </div>
                                        <div class="flex-1">
                                            <h6 class="leading-none font-medium">Light / Lamp</h6>
                                            <h5 class="font-semibold leading-none mt-2">
                                                <router-link to="#">Hanging Lamp</router-link>
                                            </h5>
                                        </div>
                                    </div>
                                    <h6 class="leading-none">$241</h6>
                                </div>
                            </div>
                            <div class="mt-6 pt-6 border-t border-bdr-clr dark:border-bdr-clr-drk text-right flex justify-end flex-col w-full ml-auto mr-0">
                                <div class="flex justify-between flex-wrap text-base sm:text-lg text-title dark:text-white font-medium">
                                    <span>Sub Total:</span>
                                    <span>$870</span>
                                </div>
                                <div class="flex justify-between flex-wrap text-base sm:text-lg text-title dark:text-white font-medium mt-3">
                                    <span>Coupon Discount:</span>
                                    <span>-$20</span>
                                </div>
                                <div class="flex justify-between flex-wrap text-base sm:text-lg text-title dark:text-white font-medium mt-3">
                                    <span>VAT:</span>
                                    <span> $5</span>
                                </div>
                                
                            </div>
                            <div class="mt-6 pt-6 border-t border-bdr-clr dark:border-bdr-clr-drk">
                                <div class="flex justify-between flex-wrap text-base sm:text-lg text-title dark:text-white font-medium mt-3">
                                    <div>
                                        <label class="flex items-center gap-[10px] categoryies-iteem">
                                            <input class="appearance-none hidden" type="radio" name="item-type">
                                            <span class="w-4 h-4 rounded-full border border-title dark:border-white flex items-center justify-center duration-300">
                                                <svg class="duration-300 opacity-0" width="8" height="8" viewBox="0 0 10 10" fill="none" xmlns="http://www.w3.org/2000/svg">
                                                    <rect width="10" height="10" rx="5" fill="#BB976D"/>
                                                </svg>
                                            </span>
                                            <span class="sm:text-lg text-title dark:text-white block sm:leading-none transform translate-y-[3px] select-none">Free Shipping:</span>
                                        </label>
                                    </div>
                                    <span> $0</span>
                                </div>
                                <div class="flex justify-between flex-wrap text-base sm:text-lg text-title dark:text-white font-medium mt-3">
                                    <div>
                                        <label class="flex items-center gap-[10px] categoryies-iteem">
                                            <input class="appearance-none hidden" type="radio" name="item-type">
                                            <span class="w-4 h-4 rounded-full border border-title dark:border-white flex items-center justify-center duration-300">
                                                <svg class="duration-300 opacity-0" width="8" height="8" viewBox="0 0 10 10" fill="none" xmlns="http://www.w3.org/2000/svg">
                                                    <rect width="10" height="10" rx="5" fill="#BB976D"/>
                                                </svg>
                                            </span>
                                            <span class="sm:text-lg text-title dark:text-white block sm:leading-none transform translate-y-[3px] select-none">Fast Shipping:</span>
                                        </label>
                                    </div>
                                    <span>$10</span>
                                </div>
                                <div class="flex justify-between flex-wrap text-base sm:text-lg text-title dark:text-white font-medium mt-3">
                                    <div>
                                        <label class="flex items-center gap-[10px] categoryies-iteem">
                                            <input class="appearance-none hidden" type="radio" name="item-type">
                                            <span class="w-4 h-4 rounded-full border border-title dark:border-white flex items-center justify-center duration-300">
                                                <svg class="duration-300 opacity-0" width="8" height="8" viewBox="0 0 10 10" fill="none" xmlns="http://www.w3.org/2000/svg">
                                                    <rect width="10" height="10" rx="5" fill="#BB976D"/>
                                                </svg>
                                            </span>
                                            <span class="sm:text-lg text-title dark:text-white block sm:leading-none transform translate-y-[3px] select-none"> Local Pickup:</span>
                                        </label>
                                    </div>
                                    <span>$15</span>
                                </div>
                            </div>
                            <div class="mt-6 pt-6 border-t border-bdr-clr dark:border-bdr-clr-drk">
                                <div class="flex justify-between flex-wrap font-semibold leading-none text-2xl md:text-3xl">
                                    <span>Total:</span>
                                    <span>&nbsp;$850</span>
                                </div>
                            </div>
                        </div> 
                        <div class="mt-7 md:mt-12">
                            <h4 class="font-semibold leading-none text-xl md:text-2xl mb-6 md:mb-10">Payment Method</h4>
                            <div class="flex gap-5 sm:gap-8 md:gap-12 flex-wrap">
                                <div>
                                    <label class="flex items-center gap-[10px] categoryies-iteem">
                                        <input class="appearance-none hidden" type="radio" name="item-type">
                                        <span class="w-4 h-4 rounded-full border border-title dark:border-white flex items-center justify-center duration-300">
                                            <svg class="duration-300 opacity-0" width="8" height="8" viewBox="0 0 10 10" fill="none" xmlns="http://www.w3.org/2000/svg">
                                                <rect width="10" height="10" rx="5" fill="#BB976D"/>
                                            </svg>
                                        </span>
                                        <span class="sm:text-lg text-title dark:text-white block sm:leading-none transform translate-y-[3px] select-none">Cash On Delivery</span>
                                    </label>
                                    <p class="ml-6 text-[15px] leading-none mt-2">Time ( 07 - 10 ) Days</p>
                                </div>
                                <div>
                                    <label class="flex items-center gap-[10px] categoryies-iteem">
                                        <input class="appearance-none hidden" type="radio" name="item-type">
                                        <span class="w-4 h-4 rounded-full border border-title dark:border-white flex items-center justify-center duration-300">
                                            <svg class="duration-300 opacity-0" width="8" height="8" viewBox="0 0 10 10" fill="none" xmlns="http://www.w3.org/2000/svg">
                                                <rect width="10" height="10" rx="5" fill="#BB976D"/>
                                            </svg>
                                        </span>
                                        <span class="sm:text-lg text-title dark:text-white block sm:leading-none transform translate-y-[3px] select-none">Debit / Credit Card</span>
                                    </label>
                                    <p class="ml-6 text-[15px] leading-none mt-2">Time ( 07 - 10 ) Days</p>
                                </div>
                            </div>
                            <div class="mt-6 sm:mt-8 md:mt-10">
                                <label class="flex items-center gap-2 iam-agree">
                                    <input class="appearance-none hidden" type="checkbox" name="categories">
                                    <span class="w-6 h-6 rounded-[5px] border-2 border-title dark:border-white flex items-center justify-center duration-300">
                                        <svg  class="duration-300 opacity-0 text-title dark:text-white fill-current" width="15" height="12" viewBox="0 0 20 15" fill="none" xmlns="http://www.w3.org/2000/svg">
                                            <path d="M18.3819 0.742676L6.10461 11.8998L2.25731 8.06381L0.763672 9.55745L6.20645 15.0002L20 2.32686L18.3819 0.742676Z"/>
                                        </svg>
                                    </span>
                                    <span class="text-base sm:text-lg text-title dark:text-white leading-none sm:leading-none select-none inline-block transform translate-y-[3px]">I Agree all terms & Conditions</span> 
                                </label>
                            </div>
                            <div class="mt-4 md:mt-6 flex flex-wrap gap-3">
                                <router-link to="#" class="btn btn-outline" data-text="Back to Cart"><span>Back to Cart</span></router-link>
                                <router-link to="#" class="btn btn-theme-solid" data-text="Place to Order"><span>Place to Order</span></router-link>
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
    import NavbarOne from '@/components/navbar/navbar-one.vue';
    import FooterOne from '@/components/footer/footer-one.vue';
    import ScrollToTop from '@/components/scroll-to-top.vue';

    import bg from '@/assets/img/shortcode/breadcumb.jpg'
    import cart1 from '@/assets/img/gallery/cart/cart-01.jpg'
    import cart2 from '@/assets/img/gallery/cart/cart-02.jpg'
    import cart3 from '@/assets/img/gallery/cart/cart-03.jpg'

    import { onMounted, ref } from 'vue';
    import Aos from 'aos';

    const open = ref(false)

    onMounted(()=>{
        Aos.init()
    })
</script>
