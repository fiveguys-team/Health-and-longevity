import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import './assets/css/style.css'
import {createPinia} from "pinia";

const app = createApp(App)

// 1. Pinia 플러그인 등록
app.use(createPinia())
// 2. Router 등록
app.use(router)
// 3. Mount
app.mount('#app')


window.Kakao.init("2b83ced7583d0f987371aa7adc03bcb3");