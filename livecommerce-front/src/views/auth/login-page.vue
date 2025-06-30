<template>
    <div>
        <NavbarOne/>

        <div class="flex">
            <div class="w-1/2 hidden md:block lg:flex-1">
                <img class="h-full object-cover" :src="loginImg" alt="login">
            </div>
            <div class="w-full md:w-1/2 lg:max-w-lg xl:max-w-3xl lg:w-full py-16 px-[20px] sm:px-8 lg:p-16 xl:p-24 relative z-10 flex items-center overflow-hidden">
                <div class="mx-auto md:mx-0 max-w-md">
                    <h2 class="leading-none" data-aos="fade-up">환영합니다!</h2>
                    <p class="text-lg mt-[15px]" data-aos="fade-up" data-aos-delay="100">무병장수에서 건강한 삶을 위한 제품을 만나보세요</p>
                    <div class="mt-7" data-aos="fade-up" data-aos-delay="200">
                        <label class="text-base sm:text-lg font-medium leading-none mb-2.5 block dark:text-white">이메일</label>
                        <input v-model="email" @input="validateEmail" :class="['w-full h-12 md:h-14 bg-white dark:bg-transparent border', emailError ? 'border-red-500 focus:border-red-500' : 'border-bdr-clr focus:border-primary', 'p-4 outline-none duration-300']" type="email" placeholder="이메일 주소를 입력하세요">
                        <div v-if="emailError" class="text-red-500 text-sm mt-1">{{ emailError }}</div>
                    </div>
                    <div class="mt-5" data-aos="fade-up" data-aos-delay="300">
                        <label class="text-base sm:text-lg font-medium leading-none mb-2.5 block dark:text-white">비밀번호</label>
                        <input v-model="password" @input="validatePassword" :class="['w-full h-12 md:h-14 bg-white dark:bg-transparent border', passwordError ? 'border-red-500 focus:border-red-500' : 'border-bdr-clr focus:border-primary', 'p-4 outline-none duration-300 placeholder:text-xl placeholder:transform placeholder:translate-y-[10px]']" type="password" placeholder="* * * * * * * *">
                        <div v-if="passwordError" class="text-red-500 text-sm mt-1">{{ passwordError }}</div>
                    </div>
                    <div class="mt-7 flex gap-3" data-aos="fade-up" data-aos-delay="500">
                      <button @click="memberLogin" class="btn btn-theme-solid flex-[0.7] h-12 md:h-14 rounded-[8px]" data-text="로그인"><span>로그인</span></button>
                      <button @click="googleServerLogin" class="gsi-material-button flex-1 h-12 md:h-14">
                        <div class="gsi-material-button-state"></div>
                        <div class="gsi-material-button-content-wrapper">
                          <div class="gsi-material-button-icon">
                            <svg version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48" xmlns:xlink="http://www.w3.org/1999/xlink" style="display: block;">
                              <path fill="#EA4335" d="M24 9.5c3.54 0 6.71 1.22 9.21 3.6l6.85-6.85C35.9 2.38 30.47 0 24 0 14.62 0 6.51 5.38 2.56 13.22l7.98 6.19C12.43 13.72 17.74 9.5 24 9.5z"></path>
                              <path fill="#4285F4" d="M46.98 24.55c0-1.57-.15-3.09-.38-4.55H24v9.02h12.94c-.58 2.96-2.26 5.48-4.78 7.18l7.73 6c4.51-4.18 7.09-10.36 7.09-17.65z"></path>
                              <path fill="#FBBC05" d="M10.53 28.59c-.48-1.45-.76-2.99-.76-4.59s.27-3.14.76-4.59l-7.98-6.19C.92 16.46 0 20.12 0 24c0 3.88.92 7.54 2.56 10.78l7.97-6.19z"></path>
                              <path fill="#34A853" d="M24 48c6.48 0 11.93-2.13 15.89-5.81l-7.73-6c-2.15 1.45-4.92 2.3-8.16 2.3-6.26 0-11.57-4.22-13.47-9.91l-7.98 6.19C6.51 42.62 14.62 48 24 48z"></path>
                              <path fill="none" d="M0 0h48v48H0z"></path>
                            </svg>
                          </div>
                          <span class="gsi-material-button-contents ">구글 로그인</span>
                          <span style="display: none;">구글 로그인</span>
                        </div>
                      </button>
                      <button @click="kakaoServerLogin" class="flex-[1.5] h-12 md:h-14 flex items-center justify-center p-0 bg-white border border-gray-300 shadow rounded-[8px] transition hover:shadow-md min-w-0 overflow-hidden cursor-pointer">
                        <img src="@/assets/img/kakao_login_large.png" class="h-full w-auto" alt="카카오 로그인 버튼" />
                      </button>
                    </div>
                    <div class="mt-5 text-center" data-aos="fade-up" data-aos-delay="600">
                      <span class="text-base">아직 회원이 아니신가요?</span>
                      <router-link to="/register" class="text-primary font-medium ml-1 inline-block">회원가입</router-link>
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
import loginImg from '@/assets/img/bg/login.jpg'
import { ref, onMounted } from 'vue';
import Aos from 'aos';
import FooterOne from '@/components/footer/footer-one.vue';
import ScrollToTop from '@/components/scroll-to-top.vue';
import axiosInstance from "@/api/axios";
import {useAuthStore} from "@/modules/auth/stores/auth";
import router from "@/router";

const email = ref("")
const password = ref("")
const emailError = ref("");
const passwordError = ref("");

onMounted(() => {
    Aos.init()
})

const googleServerLogin = () => {
    window.location.href = "http://localhost:8080/oauth2/authorization/google"
}

const kakaoServerLogin = () => {
    window.location.href = "http://localhost:8080/oauth2/authorization/kakao"
}

const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const passwordPattern = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,20}$/;

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

const memberLogin = async () => {
  const validEmail = validateEmail();
  const validPassword = validatePassword();
  if (!validEmail || !validPassword) return;
  try {
    const loginData = {
      email: email.value,
      password: password.value
    };

    await axiosInstance.post("/api/member/doLogin", loginData);

    // 로그인 성공 후 사용자 정보 초기화 요청 (쿠키 기반)
    const authStore = useAuthStore()
    await authStore.initFromServer()
    await router.push("/");
  } catch (err) {
    console.error(err);
    alert("로그인에 실패했습니다.");
  }
};

</script>

<style scoped>
.gsi-material-button {
  position: relative;
  display: inline-block;
  box-sizing: border-box;
  border: none;
  border-radius: 8px;
  color: #1f1f1f;
  cursor: pointer;
  font-family: "Roboto", sans-serif;
  font-size: 14px;
  font-weight: 500;
  height: auto;
  letter-spacing: 0.25px;
  outline: none;
  overflow: hidden;
  padding: 0 12px;
  position: relative;
  text-align: center;
  transition: box-shadow 0.218s, border-color 0.218s, background-color 0.218s;
  vertical-align: middle;
  white-space: nowrap;
  width: auto;
  max-width: 400px;
  min-width: min-content;
  background-color: #fff;
  border: 1px solid #dadce0;
  box-shadow: 0 1px 3px 0 rgba(60, 64, 67, 0.302), 0 1px 2px 0 rgba(60, 64, 67, 0.149);
}

.gsi-material-button:hover {
  box-shadow: 0 1px 3px 0 rgba(60, 64, 67, 0.302), 0 4px 8px 3px rgba(60, 64, 67, 0.149);
}

.gsi-material-button:active {
  box-shadow: 0 4px 4px 0 rgba(60, 64, 67, 0.302), 0 8px 12px 6px rgba(60, 64, 67, 0.149);
}

.gsi-material-button-state {
  bottom: 0;
  left: 0;
  position: absolute;
  right: 0;
  top: 0;
}

.gsi-material-button-content-wrapper {
  align-items: center;
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  height: 100%;
  position: relative;
  width: 100%;
}

.gsi-material-button-icon {
  height: 20px;
  margin-right: 12px;
  min-width: 20px;
  width: 20px;
}

.gsi-material-button-contents {
  flex-grow: 1;
  font-family: "Roboto", sans-serif;
  font-weight: 500;
  overflow: hidden;
  text-overflow: ellipsis;
  vertical-align: top;
}
</style>