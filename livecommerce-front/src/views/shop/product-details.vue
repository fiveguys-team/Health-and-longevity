<template>
    <div>
        <NavbarOne/>

        <div class="bg-[#F8F5F0] dark:bg-dark-secondary py-5 md:py-[30px]">
            <div class="container-fluid">
                <ul class="flex items-center gap-[10px] text-base md:text-lg leading-none font-normal text-title dark:text-white max-w-[1720px] mx-auto flex-wrap">
                    <li><router-link to="/">Home</router-link></li>
                    <li>/</li>
                    <li><router-link to="/shop-v1">Shop</router-link></li>
                    <li>/</li>
                    <li class="text-primary">{{data && data.name ? data.name : 'Classic Relaxable Chair'}}</li>
                </ul>
            </div>
        </div>

        <div class="s-py-50" data-aos="fade-up">
            <div class="container-fluid">
                <div class="max-w-[1720px] mx-auto flex justify-between gap-10 flex-col lg:flex-row">
                    <div class="w-full lg:w-[58%]">
                        <div class="relative product-dtls-wrapper">
                            <button class="absolute top-5 left-0 p-2 bg-[#E13939] text-lg leading-none text-white font-medium z-50">-10%</button>
                            <div class="product-dtls-slider ">
                                <div><img :src="data && data.image ? data.image : product1" alt="product" class="w-full" :class="activeImage === 1 ? '' : 'hidden' "></div>
                                <div><img :src="product2" alt="product" :class="activeImage === 2 ? '' : 'hidden' "></div>
                                <div><img :src="product3" alt="product" :class="activeImage === 3 ? '' : 'hidden' "></div>
                                <div><img :src="product4" alt="product" :class="activeImage === 4 ? '' : 'hidden' "></div>
                            </div>
                            <div class="product-dtls-nav">
                                <div><img :src="data && data.image ? data.image : product1" @click="activeImage = 1" alt="product" class="mb-2"></div>
                                <div><img :src="product2" @click="activeImage = 2" alt="product" class="mb-2"></div>
                                <div><img :src="product3" @click="activeImage = 3" alt="product" class="mb-2"></div>
                                <div><img :src="product4" @click="activeImage = 4" alt="product" class="mb-2"></div>
                            </div>
                        </div>
                    </div>
                    <div class="lg:max-w-[635px] w-full">
                        <div class="pb-4 sm:pb-6 border-b border-bdr-clr dark:border-bdr-clr-drk">
                            <h2 class="font-semibold leading-none">{{data && data.name ? data.name : 'Classic Relaxable Chair'}}</h2>
                            <div class="flex gap-4 items-center mt-[15px]">
                                <span class="text-lg sm:text-xl leading-none pb-[5px] text-title line-through pl-2 inline-block dark:text-white">$140.99</span>
                                <span class="text-2xl sm:text-3xl text-primary leading-none block">$85.00</span>
                            </div>

                            <div class="mt-5 md:mt-7 flex items-center gap-4 flex-wrap">
                                <h4 class="text-xl md:text-[22px] font-semibold !leading-none">Hurry Up!</h4>
                                <div class="overflow-auto">
                                    <div class="py-2 px-3 bg-[#FAF2F2] rounded-[51px] flex items-end gap-[6px] w-[360px]">
                                        <svg class="w-[15px]" height="20" viewBox="0 0 15 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                                            <path d="M12.6923 7.59087C12.6383 7.52329 12.573 7.53657 12.5387 7.55036C12.51 7.562 12.4442 7.59919 12.4533 7.69239C12.4642 7.80431 12.4704 7.91841 12.4715 8.03157C12.4764 8.50102 12.2881 8.96094 11.9549 9.2934C11.6238 9.62371 11.1884 9.80168 10.7247 9.79652C10.0913 9.78844 9.56601 9.45809 9.20551 8.84118C8.90742 8.33106 9.03844 7.67313 9.17715 6.97654C9.25832 6.5688 9.34227 6.14716 9.34227 5.74588C9.34227 2.62132 7.24173 0.818669 5.98962 0.0222265C5.96373 0.00578123 5.93908 0 5.91724 0C5.88173 0 5.85361 0.0153124 5.83974 0.0246874C5.81287 0.0428905 5.76986 0.0843747 5.78369 0.157812C6.26228 2.69929 4.83478 4.22783 3.32346 5.84611C1.76566 7.51419 0 9.40485 0 12.8147C0 16.7767 3.22331 20 7.18532 20C10.4475 20 13.3237 17.7256 14.1796 14.4692C14.7633 12.2487 14.1517 9.42031 12.6923 7.59087ZM7.36458 18.4663C6.37247 18.5115 5.42896 18.1557 4.7083 17.4667C3.99537 16.7849 3.58647 15.8336 3.58647 14.8565C3.58647 13.0228 4.28756 11.6768 6.17326 9.88973C6.20412 9.86047 6.23572 9.85121 6.26326 9.85121C6.28822 9.85121 6.30986 9.85883 6.32474 9.86598C6.35611 9.88109 6.40767 9.91852 6.40072 9.99945C6.33329 10.784 6.33447 11.4352 6.40415 11.9351C6.58228 13.2118 7.51692 14.0697 8.73 14.0697C9.32477 14.0697 9.89129 13.8458 10.3252 13.4394C10.3756 13.3922 10.4318 13.3982 10.4534 13.4028C10.4819 13.409 10.5202 13.4265 10.5402 13.4748C10.7202 13.9092 10.8121 14.3703 10.8135 14.8453C10.8193 16.7564 9.27207 18.3808 7.36458 18.4663Z" fill="#E13939"/>
                                        </svg>                                
                                        <h6 class="text-lg font-medium leading-none !text-[#E13939] whitespace-nowrap">Sale Ends :</h6>
                                        <div class="countdown-clock flex gap-[10px] items-center">
                                            <div class="countdown-item flex">
                                                <div class="ci-inner text-lg font-medium leading-none text-[#E13939]">
                                                    <div class="clock-days ci-value">{{ days }}</div>
                                                </div>
                                                <p class="text-lg font-medium leading-none text-[#E13939]">D</p>
                                            </div>
                                            <p class="text-lg font-medium leading-none text-[#E13939]">:</p>
                                            <div class="countdown-item flex">
                                                <div class="ci-inner text-lg font-medium leading-none text-[#E13939]">
                                                    <div class="clock-hours ci-value">{{ hours }}</div>
                                                </div>
                                                <p class="text-lg font-medium leading-none text-[#E13939]">H</p>
                                            </div>
                                            <p class="text-lg font-medium leading-none text-[#E13939]">:</p>
                                            <div class="countdown-item flex">
                                                <div class="ci-inner text-lg font-medium leading-none text-[#E13939]">
                                                    <div class="clock-minutes ci-value">{{ minutes }}</div>
                                                </div>
                                                <p class="text-lg font-medium leading-none text-[#E13939]">M</p>
                                            </div>
                                            <p class="text-lg font-medium leading-none text-[#E13939]">:</p>
                                            <div class="countdown-item flex">
                                                <div class="ci-inner text-lg font-medium leading-none text-[#E13939]">
                                                    <div class="clock-seconds ci-value">{{ seconds }}</div>
                                                </div>
                                                <p class="text-lg font-medium leading-none text-[#E13939]">S</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <p class="sm:text-lg mt-5 md:mt-7">
                                Experience the epitome of relaxation with our Classic Relaxable Chair. Crafted with plush cushioning and ergonomic design, it offers unparalleled comfort for lounging or reading. Its timeless style seamlessly blends with any decor, while the sturdy construction ensures durability for years to come.
                            </p>
                        </div>
                        <div class="py-4 sm:py-6 border-b border-bdr-clr dark:border-bdr-clr-drk" data-aos="fade-up" data-aos-delay="200">

                            <IncDec/>

                            <div class="flex gap-4 mt-4 sm:mt-6">
                                <router-link to="/cart" class="btn btn-solid" data-text="Add to Cart">
                                    <span>Add to Cart</span>
                                </router-link>
                                <router-link to="#" class="btn btn-outline" data-text="Add to Wishlist">
                                    <span>Add to Wishlist</span>
                                </router-link>
                            </div>
                        </div>
                        <div class="py-4 sm:py-6 border-b border-bdr-clr dark:border-bdr-clr-drk" data-aos="fade-up" data-aos-delay="300">
                            <div class="flex gap-x-12 gap-y-3 flex-wrap">
                                <h6 class="leading-none font-medium">SKU : CH_0015</h6>
                                <h6 class="leading-none font-medium">Category : Chair</h6>
                            </div>
                            <div class="flex gap-x-12 lg:gap-x-24 gap-y-3 flex-wrap mt-5 sm:mt-10">
                                <div class="flex gap-[10px] items-center">
                                    <h6 class="leading-none font-medium">Size :</h6>
                                    <div class="flex gap-[10px]">
                                        <label class="product-size">
                                            <input class="appearance-none hidden" type="radio" name="size" checked>
                                            <span class="w-6 h-6 flex items-center justify-center pt-[2px] text-sm leading-none bg-[#E8E9EA] dark:bg-dark-secondary text-title dark:text-white duration-300">S</span>
                                        </label>
                                        <label class="product-size">
                                            <input class="appearance-none hidden" type="radio" name="size" >
                                            <span class="w-6 h-6 flex items-center justify-center pt-[2px] text-sm leading-none bg-[#E8E9EA] dark:bg-dark-secondary text-title dark:text-white duration-300">M</span>
                                        </label>
                                        <label class="product-size">
                                            <input class="appearance-none hidden" type="radio" name="size">
                                            <span class="w-6 h-6 flex items-center justify-center pt-[2px] text-sm leading-none bg-[#E8E9EA] dark:bg-dark-secondary text-title dark:text-white duration-300">L</span>
                                        </label>
                                        <label class="product-size">
                                            <input class="appearance-none hidden" type="radio" name="size">
                                            <span class="w-6 h-6 flex items-center justify-center pt-[2px] text-sm leading-none bg-[#E8E9EA] dark:bg-dark-secondary text-title dark:text-white duration-300">XL</span>
                                        </label>
                                    </div>
                                </div>
                                <div class="flex gap-[10px] items-center">
                                    <h6 class="leading-none font-medium">Color :</h6>
                                    <div class="flex gap-[10px] items-center">
                                        <label class="product-color">
                                            <input class="appearance-none hidden" type="radio" name="color" >
                                            <span class="border border-[#D68553] flex rounded-full border-opacity-0 duration-300 p-1">
                                                <span class="w-4 h-4 rounded-full bg-[#D68553] flex"></span>
                                            </span>
                                        </label>
                                        <label class="product-color">
                                            <input class="appearance-none hidden" type="radio" name="color" checked>
                                            <span class="border border-[#61646E] flex rounded-full border-opacity-0 duration-300 p-1">
                                                <span class="w-4 h-4 rounded-full bg-[#61646E] flex"></span>
                                            </span>
                                        </label>
                                        <label class="product-color">
                                            <input class="appearance-none hidden" type="radio" name="color">
                                            <span class="border border-[#E9E3DC] flex rounded-full border-opacity-0 duration-300 p-1">
                                                <span class="w-4 h-4 rounded-full bg-[#E9E3DC] flex"></span>
                                            </span>
                                        </label>
                                        <label class="product-color">
                                            <input class="appearance-none hidden" type="radio" name="color">
                                            <span class="border border-[#9A9088] flex rounded-full border-opacity-0 duration-300 p-1">
                                                <span class="w-4 h-4 rounded-full bg-[#9A9088] flex"></span>
                                            </span>
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="py-4 sm:py-6 border-b border-bdr-clr dark:border-bdr-clr-drk" data-aos="fade-up" data-aos-delay="400">
                            <h4 class="font-medium leading-none">Tags :</h4>
                            <div class="flex flex-wrap gap-[10px] md:gap-[15px] mt-5 md:mt-6">
                                <router-link class="btn btn-theme-outline btn-xs" to="#" data-text="Chair"><span>Chair</span></router-link>
                                <router-link class="btn btn-theme-outline btn-xs" to="#" data-text="Art & Paint"><span>Art & Paint</span></router-link>
                                <router-link class="btn btn-theme-outline btn-xs" to="#" data-text="Mirror"><span>Mirror</span></router-link>
                                <router-link class="btn btn-theme-outline btn-xs" to="#" data-text="Table"><span>Table</span></router-link>
                                <router-link class="btn btn-theme-outline btn-xs" to="#" data-text="Lamp"><span>Lamp</span></router-link>
                            </div>
                        </div>
                        <div class="pt-4 sm:pt-6" data-aos="fade-up" data-aos-delay="500">
                            <div class="flex items-center gap-6">
                                <h6 class="font-normal">Share : </h6>
                                <div class="flex gap-6">
                                    <router-link to="#" class="text-paragraph duration-300 dark:text-white hover:text-primary dark:hover:text-primary">
                                        <i class="fa-brands fa-facebook-f"></i>
                                    </router-link>
                                    <router-link to="#" class="text-paragraph duration-300 dark:text-white hover:text-primary dark:hover:text-primary">
                                        <i class="fa-brands fa-twitter"></i>
                                    </router-link>
                                    <router-link to="#" class="text-paragraph duration-300 dark:text-white hover:text-primary dark:hover:text-primary">
                                        <i class="fa-brands fa-instagram"></i>
                                    </router-link>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="s-py-50">
            <DetailTab/>
        </div>


        <FooterOne/>

        <ScrollToTop/>

    </div>
</template>

<script setup>
    import { ref, computed, watch,onMounted } from 'vue';
    import { useRoute } from 'vue-router';

    import NavbarOne from '@/components/navbar/navbar-one.vue';
    import IncDec from '@/components/inc-dec.vue';
    import DetailTab from '@/components/product/detail-tab.vue';
    import FooterOne from '@/components/footer/footer-one.vue';
    import ScrollToTop from '@/components/scroll-to-top.vue';

    import product1 from '@/assets/img/gallery/product-detls/product-01.jpg'
    import product2 from '@/assets/img/gallery/product-detls/product-02.jpg'
    import product3 from '@/assets/img/gallery/product-detls/product-03.jpg'
    import product4 from '@/assets/img/gallery/product-detls/product-04.jpg'

    import Aos from 'aos';
    import { productList } from '@/data/data';

    onMounted(()=>{
        Aos.init()
    })

    const activeImage = ref(1)

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

    const route = useRoute()

    // const data = productList.find((item)=>item.id === parseInt(route.params.id))
    const data = ref(null)

    onMounted(() => {
      const productId = parseInt(route.params.id)
      data.value = productList.find(item => item.id === productId)
    })
</script>
