<template>
    <label class="switcher cursor-pointer order-first sm:order-last" @change="changeMode('mode', $event)">
        <input class="hidden" type="checkbox">
        <img class="moon w-[22px] sm:w-7 block dark:hidden" :src="moon" alt="moon">
        <img class="sun w-[22px] sm:w-7 hidden dark:block" :src="sun" alt="sun">
    </label>
</template>

<script setup>
    import moon from '@/assets/img/icon/simple-sun.svg'
    import sun from '@/assets/img/icon/simple-light.svg'

    function changeMode(mode) {
        switch (mode) {
        case 'mode':
            if (document.documentElement.className.includes("dark")) {
                document.documentElement.className = 'light'
            } else {
                document.documentElement.className = 'dark'
            }
            break;
    }
    }

</script>