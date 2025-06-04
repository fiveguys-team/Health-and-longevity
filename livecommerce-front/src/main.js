import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import './assets/css/style.css'

createApp(App).use(router).mount('#app')

window.Kakao.init("2b83ced7583d0f987371aa7adc03bcb3");