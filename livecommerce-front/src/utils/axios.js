// src/utils/axios.js
import axios from 'axios'

const instance = axios.create({
  // baseURL: '', ← 아예 생략하거나 빈 문자열로 둬야 프록시가 잘 작동함
  headers: {
    'Content-Type': 'application/json'
  }
})

export default instance
