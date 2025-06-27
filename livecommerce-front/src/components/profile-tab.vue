<template>
    <ul class="divide-y dark:divide-paragraph text-title dark:text-white text-base sm:text-lg lg:text-xl flex flex-col justify-center leading-none">
        <li class="pb-3 lg:pb-6 pl-6 lg:pl-12" :class="{'active text-primary' : current === '/my-profile'}">
            <router-link class="duration-300 hover:text-primary" to="/my-profile">내정보</router-link>
        </li>
        <li class="py-3 lg:py-6 pl-6 lg:pl-12" :class="{'active text-primary' : current === '/order-history'}">
            <router-link class="duration-300 hover:text-primary" to="/order-history">주문내역</router-link>
        </li>
    </ul>
</template>

<script setup>
import { ref } from 'vue';
import { useRoute } from 'vue-router';


const router = useRoute();
const current = ref(router.path);

</script>
