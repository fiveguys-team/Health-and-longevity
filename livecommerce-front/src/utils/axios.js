// src/utils/axios.js
import axios from 'axios'

const instance = axios.create({
  baseURL: '/api', // 프록시 타겟으로 연결됨
  headers: {
    'Content-Type': 'application/json'
  }
})

export default instance
