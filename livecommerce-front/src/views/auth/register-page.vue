<template>
    <div>
        <NavbarOne/>

        <div class="flex">
            <div class="w-1/2 hidden md:block lg:flex-1" >
                <img class="h-full object-cover" :src="register" alt="register">
            </div>
            <div class="w-full md:w-1/2 lg:max-w-lg xl:max-w-3xl lg:w-full py-16 px-[20px] sm:px-8 lg:p-16 xl:p-24 relative z-10 flex items-start">
                <div class="mx-auto md:mx-0 max-w-md">
                    <h2 class="leading-none" data-aos="fade-up">회원가입</h2>
                    <p class="text-lg mt-[15px]" data-aos="fade-up" data-aos-delay="100">무병장수에서 건강한 삶을 위한 제품을 만나보세요</p>
                    <div class="mt-7" data-aos="fade-up" data-aos-delay="200">
                        <label class="text-base sm:text-lg font-medium leading-none mb-2.5 block dark:text-white">이름</label>
                        <input v-model="name" @input="validateName" :class="['w-full h-12 md:h-14 bg-white dark:bg-transparent border', nameError ? 'border-red-500 focus:border-red-500' : 'border-bdr-clr focus:border-primary', 'p-4 outline-none duration-300']" type="text" placeholder="이름을 입력하세요">
                        <div class="min-h-[20px] mt-1">
                          <span v-if="nameError" class="text-red-500 text-sm">{{ nameError }}</span>
                        </div>
                    </div>
                    <div class="mt-5" data-aos="fade-up" data-aos-delay="300">
                        <label class="text-base sm:text-lg font-medium leading-none mb-2.5 block dark:text-white">이메일</label>
                        <input v-model="email" @input="validateEmail" :class="['w-full h-12 md:h-14 bg-white dark:bg-transparent border', emailError ? 'border-red-500 focus:border-red-500' : 'border-bdr-clr focus:border-primary', 'p-4 outline-none duration-300']" type="email" placeholder="이메일 주소를 입력하세요">
                        <div class="min-h-[20px] mt-1">
                          <span v-if="emailError" class="text-red-500 text-sm">{{ emailError }}</span>
                        </div>
                    </div>
                    <div class="mt-5" data-aos="fade-up" data-aos-delay="400">
                        <label class="text-base sm:text-lg font-medium leading-none mb-2.5 block dark:text-white">비밀번호</label>
                        <input v-model="password" @input="validatePassword" :class="['w-full h-12 md:h-14 bg-white dark:bg-transparent border', passwordError ? 'border-red-500 focus:border-red-500' : 'border-bdr-clr focus:border-primary', 'p-4 outline-none duration-300 placeholder:text-xl placeholder:transform placeholder:translate-y-[10px]']" type="password" placeholder="* * * * * * * *">
                        <div class="min-h-[20px] mt-1">
                          <span v-if="passwordError" class="text-red-500 text-sm">{{ passwordError }}</span>
                        </div>
                    </div>
                    <div data-aos="fade-up" data-aos-delay="500">
                        <button @click="memberCreate" class="btn btn-theme-solid mt-[15px]" data-text="회원가입"><span>회원가입</span></button>
                    </div>
                    <div class="mt-5 text-center" data-aos="fade-up" data-aos-delay="600" data-aos-offset="0">
                      <span class="text-base">이미 계정이 있으신가요?</span>
                      <router-link to="/login" class="text-primary font-medium ml-1 inline-block">로그인</router-link>
                    </div>
                </div>
            </div>
        </div>

        <FooterOne/>

        <ScrollToTop/>

    </div>
</template>

<script setup>
    import { onMounted, ref } from 'vue';

    import NavbarOne from '@/components/navbar/navbar-one.vue';
    import FooterOne from '@/components/footer/footer-one.vue';
    import ScrollToTop from '@/components/scroll-to-top.vue';

    import register from '@/assets/img/bg/register.jpg'
    import Aos from 'aos';
    import axiosInstance from "@/api/axios";
    import router from "@/router";

    const name = ref("")
    const email = ref("")
    const password = ref("")
    const nameError = ref("");
    const emailError = ref("");
    const passwordError = ref("");

    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    const passwordPattern = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,20}$/;
    const namePattern = /^[가-힣]{2,4}$/;

    onMounted(() => {
        Aos.init({
            offset: 0,
            once: true
        });
    })

    const validateName = () => {
      if (!name.value) {
        nameError.value = "이름을 입력하세요.";
        return false;
      } else if (!namePattern.test(name.value)) {
        nameError.value = "이름은 한글 2~4글자만 입력 가능합니다.";
        return false;
      } else {
        nameError.value = "";
        return true;
      }
    };

    const validateEmail = () => {
      if (!email.value) {
        emailError.value = "이메일을 입력하세요.";
        return false;
      } else if (!emailPattern.test(email.value)) {
        emailError.value = "올바른 이메일 주소를 입력하세요.";
        return false;
      } else {
        emailError.value = "";
        return true;
      }
    };

    const validatePassword = () => {
      if (!password.value) {
        passwordError.value = "비밀번호를 입력하세요.";
        return false;
      } else if (!passwordPattern.test(password.value)) {
        passwordError.value = "비밀번호는 영문+숫자 조합 8~20자로 입력하세요.";
        return false;
      } else {
        passwordError.value = "";
        return true;
      }
    };

    const memberCreate = async () => {
      const validName = validateName();
      const validEmail = validateEmail();
      const validPassword = validatePassword();
      if (!validName || !validEmail || !validPassword) return;
      const registerData = {
        name: name.value,
        email: email.value,
        password: password.value
      }
      await axiosInstance.post("/api/member/create", registerData)
      await router.push("/")
    }

</script>
