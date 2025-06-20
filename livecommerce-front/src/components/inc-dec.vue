<template>
    <div class="inc-dec flex items-center gap-2">
        <button @click="decrement" class="dec w-8 h-8 bg-[#E8E9EA] dark:bg-dark-secondary flex items-center justify-center">
            <svg class="fill-current text-title dark:text-white" width="14" height="2" viewBox="0 0 14 2" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M10.4361 0.203613H12.0736L7.81774 0.203615H13.8729V1.80309H7.81774L3.50809 1.80309H1.87053L6.18017 1.80309H0.125V0.203615H6.18017L10.4361 0.203613Z"/>
            </svg>
        </button>
<!--        <input class="w-6 h-auto outline-none bg-transparent text-base mg:text-lg leading-none text-title dark:text-white text-center" type="text" :value="count">-->
        <input v-model="count" class="w-6 h-auto outline-none bg-transparent text-base mg:text-lg leading-none text-title dark:text-white text-center" type="text"/>
        <button @click="increment" class="inc  w-8 h-8 bg-[#E8E9EA] dark:bg-dark-secondary flex items-center justify-center">
            <svg class="fill-current text-title dark:text-white" width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M6.18017 0.110352H7.81774V6.16553H13.8729V7.76501H7.81774V13.8963H6.18017V7.76501H0.125V6.16553H6.18017V0.110352Z"/>
            </svg>
        </button>
    </div>
</template>

<script setup>
    import { computed, defineProps, defineEmits } from 'vue';
    const props = defineProps({
      modelValue:{
        type: Number,
        default:1
      },
      max: {
        type: Number,
        default: Infinity // 👈 최대값으로 재고 제한
      }
    })

    const emit = defineEmits(['update:modelValue'])

    const count = computed({
      get() {
        return props.modelValue
      },
      set(val) {
        let next = val < 1 ? 1 : val
        if (isNaN(next) || next < 1) next = 1
        if (next > props.max) next = props.max
        emit('update:modelValue', next)
      }
    })

    // 4. 버튼 클릭 시 count 조작
    function increment() {
      if (count.value < props.max) {
        count.value++
      }else {
        alert(`재고가 부족합니다. 최대 ${props.max}개까지만 구매할 수 있습니다.`);
      }
    }

    function decrement() {
      if (count.value > 1) {
        count.value--
      }
    }


</script>
