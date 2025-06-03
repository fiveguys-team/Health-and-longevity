<template>
    <div>
        <NavbarOne/>

        <div>
         구현 해야될 부분
        </div> 

        <FooterThree/>

        <ScrollToTop/>

    </div>
</template>

<script setup>
    import { onMounted } from 'vue';


    import NavbarOne from '@/components/navbar/navbar-one.vue';
    // import FooterOne from '@/components/footer/footer-one.vue';
    import FooterThree from '@/components/footer/footer-three.vue';
    import ScrollToTop from '@/components/scroll-to-top.vue';


    import 'swiper/swiper-bundle.css';

   
    import Aos from 'aos';
    import 'aos/dist/aos.css';

    onMounted(() => {
        Aos.init()
    });


</script>