<template>
    <div class="relative lg:px-14" data-aos="fade-up" data-aos-delay="100">
        
        <swiper
            :modules="[Autoplay,Navigation]" 
            :slides-per-view="3" 
            :space-between="0" 
            :loop="true"  
            :navigation="true" 
            :breakpoints="{
                320: { slidesPerView: 1, spaceBetween: 0 },
                576: { slidesPerView: 1, spaceBetween: 0 },
                1024: { slidesPerView: 1, spaceBetween: 0 },
            }"
         class="max-w-[1024px] mx-auto client carousel-slider-two owl-carousel block">
            <swiper-slide v-for="(item, index) in teamData" :key="index" class="text-center">
                <h6 class="dark:text-white italic font-normal w-[70%] mx-auto">Furnixar exceeded my expectations with their exceptional furniture pieces. The quality craftsmanship and attention to detail truly shine through in every product. My home has been transformed into a stylish sanctuary thanks to Furnixar! </h6>
                <div class="flex items-center justify-center gap-3 mt-6 author">
                    <div class="w-11 h-11 rounded-full overflow-hidden p-1 bg-primary">
                        <img class="rounded-full" :src="item.image" alt="testimonial">
                    </div>
                    <div class="text-left">
                        <h5 class="dark:text-white font-medium leading-none">{{item.name}}</h5>
                        <span class="block text-[14px] leading-none text-primary mt-[5px]">{{item.location}}</span>
                    </div>
                </div>
            </swiper-slide>
           
        </swiper>
    </div>
</template>

<script setup>
    import { teamData } from '@/data/data';
    import { Swiper, SwiperSlide } from 'swiper/vue';
    import { Autoplay,Navigation } from 'swiper/modules';
    import 'swiper/swiper-bundle.css';
</script>
