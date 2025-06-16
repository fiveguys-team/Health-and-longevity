<template>
    <div>
        <NavbarOne/>

        <div class="text-center my-10">
            <button @click="handlePingTest" class="btn btn-theme-solid">
                Ping 테스트 요청 보내기
            </button>
            <p class="mt-4 text-lg text-green-600" v-if="responseMessage">{{ responseMessage }}</p>
        </div>

        <FooterThree/>

        <ScrollToTop/>

    </div>
</template>

<script setup>
    import { onMounted, ref } from 'vue';
    import axiosInstance from "@/api/axios";

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

    const responseMessage = ref('');

    const handlePingTest = async () => {
        try {
            const res = await axiosInstance.get('/test/ping');
            responseMessage.value = res.data.message;
            console.log(res.data);
        } catch (err) {
            console.error(err);
            responseMessage.value = '요청 실패';
        }
    };
</script>