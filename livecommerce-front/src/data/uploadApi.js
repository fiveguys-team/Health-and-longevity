// src/modules/upload/api/uploadApi.js
import axios from 'axios'

export async function uploadFileToNcp(file, userId) {
    const formData = new FormData()
    formData.append('file', file)
    formData.append('userId', userId)

    const { data } = await axios.post('http://localhost:8080/api/upload', formData, {
        headers: { 'Content-Type': 'multipart/form-data' }
    })

    return data // 업로드된 이미지 URL
}
