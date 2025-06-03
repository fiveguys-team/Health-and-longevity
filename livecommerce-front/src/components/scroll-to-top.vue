<template>
    <div class="fixed bottom-4 right-4 z-50">
        <button v-if="scroll" @click="topFunction" class="bg-[#BB976D] text-white hover:bg-black size-10 shadow-lg transition duration-300">
        <i class="fa-solid fa-arrow-up"></i>
        </button>
    </div>
</template>

<script setup>
import { onMounted, onUnmounted, ref } from 'vue';

const scroll = ref(false);

const handleScroll = () => {
  scroll.value = window.scrollY > 50;
};

onMounted(() => {
  window.addEventListener('scroll', handleScroll);
});

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll);
});

const topFunction = () => {
  window.scrollTo({
    top: 0,
    behavior: 'smooth',
  });
};

</script>
