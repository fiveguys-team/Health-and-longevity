<template>
  <div class="max-w-2xl mx-auto p-8 bg-white rounded-lg shadow">
    <h2 class="text-2xl font-bold mb-6">상품 등록 요청</h2>

    <!-- 인증번호 입력 -->
    <div class="flex gap-2 mb-4 items-center">
      <label class="w-32 font-medium text-right">인증번호</label>
      <input v-model="certNo" type="text" class="flex-1 border px-3 py-2" placeholder="품목제조번호" />
      <button @click="fetchProductDetail" class="px-4 py-2 bg-blue-500 text-white rounded">인증</button>
    </div>

    <p class="text-sm text-gray-500 mb-4 text-center">아래는 API로 받은 정보입니다 (수정불가)</p>

    <!-- 자동입력 필드 -->
    <div class="flex mb-3 items-center" v-for="(label, key) in fieldMap" :key="key">
      <label class="w-32 font-medium text-right">{{ label }}</label>
      <input type="text" class="flex-1 border px-3 py-2 bg-gray-100 text-gray-600" :value="productDetail[key]" readonly />
    </div>

    <p class="text-sm text-gray-500 my-4 text-center">입점업체가 입력하는 항목</p>

    <div class="flex mb-3 items-center">
      <label class="w-32 font-medium text-right">수량</label>
      <input v-model="customInput.quantity" type="text" @input="onNumberInput('quantity')" class="flex-1 border px-3 py-2" />
    </div>

    <div class="flex mb-3 items-center">
      <label class="w-32 font-medium text-right">가격</label>
      <input v-model="customInput.price" type="text" @input="onNumberInput('price')" class="flex-1 border px-3 py-2" />
    </div>

    <div class="flex mb-3 items-center">
      <label class="w-32 font-medium text-right">분류</label>
      <select v-model="customInput.category" class="flex-1 border px-3 py-2">
        <option disabled value="">선택하세요</option>
        <option>혈압</option>
        <option>눈</option>
        <option>뼈/관절/연결성분</option>
        <option>장건강</option>
        <option>영양보충</option>
      </select>
    </div>

    <div class="flex mb-6 items-center">
      <label class="w-32 font-medium text-right">상품 이미지</label>
      <input type="file" @change="onImageChange" accept="image/*" class="flex-1 border px-3 py-2" />
    </div>

    <div class="flex justify-center gap-4">
      <button class="px-6 py-2 bg-gray-300 text-black rounded">취소</button>
      <button @click="submitRequest" class="px-6 py-2 bg-green-500 text-white rounded">등록 요청</button>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import axios from '@/utils/axios'

const certNo = ref('')
const productDetail = ref({
  productName: '',
  expiryDate: '',
  approvalDate: '',
  howToTake: '',
  mainFunction: '',
  precautions: '',
  storageMethod: '',
  standard: '',
  ingredients: ''
})

const fieldMap = {
  productName: '품목명',
  expiryDate: '유통기한',
  approvalDate: '허가일자',
  howToTake: '섭취방법',
  mainFunction: '주된 기능성',
  precautions: '섭취시 주의사항',
  storageMethod: '보관방법',
  standard: '기준규격',
  ingredients: '원재료'
}

const resetProductDetail = () => ({
  productName: '',
  expiryDate: '',
  approvalDate: '',
  howToTake: '',
  mainFunction: '',
  precautions: '',
  storageMethod: '',
  standard: '',
  ingredients: ''
})

const fetchProductDetail = async () => {
  try {
    const res = await axios.get(`/product/cert/${certNo.value}`)
    const row = res.data
    if (!row || Object.keys(row).length === 0) {
      productDetail.value = resetProductDetail()
      return alert('제품 정보를 찾을 수 없습니다.')
    }

    productDetail.value = {
      productName: row.productName,
      expiryDate: row.expiryDate,
      approvalDate: row.approvalDate,
      howToTake: row.howToTake,
      mainFunction: row.mainFunction,
      precautions: row.precautions,
      storageMethod: row.storageMethod,
      standard: row.standard,
      ingredients: row.ingredients
    }

    alert('✅ 인증 성공!')
  } catch (err) {
    productDetail.value = resetProductDetail()
    console.error(err)
    alert('API 조회 실패')
  }
}

const customInput = ref({
  quantity: '',
  price: '',
  category: ''
})

const selectedImage = ref(null)

const onNumberInput = (field) => {
  customInput.value[field] = customInput.value[field].toString().replace(/[^0-9]/g, '')
}

const onImageChange = (e) => {
  selectedImage.value = e.target.files[0]
}

const mapCategoryToId = (name) => {
  const map = {
    '혈압': 1,
    '눈': 2,
    '뼈/관절/연결성분': 3,
    '장건강': 4,
    '영양보충': 5
  }
  return map[name] || 0
}

const submitRequest = async () => {
  if (
      !certNo.value ||
      !customInput.value.quantity ||
      !customInput.value.price ||
      !customInput.value.category ||
      !selectedImage.value
  ) {
    return alert('모든 항목을 입력해주세요.')
  }

  const productPayload = {
    product: {
      name: productDetail.value.productName,
      price: parseInt(customInput.value.price),
      stockCount: parseInt(customInput.value.quantity),
      categoryId: mapCategoryToId(customInput.value.category),
      vendorId: 1 // TODO: 로그인한 입점업체의 ID로 교체
    },
    productDetail: {
      certNo: certNo.value,
      productName: productDetail.value.productName,
      expiryDate: productDetail.value.expiryDate,
      approvalDate: productDetail.value.approvalDate,
      howToTake: productDetail.value.howToTake,
      mainFunction: productDetail.value.mainFunction,
      precautions: productDetail.value.precautions,
      storageMethod: productDetail.value.storageMethod,
      standard: productDetail.value.standard,
      ingredients: productDetail.value.ingredients
    }
  }

  const formData = new FormData()
  formData.append('product', new Blob([JSON.stringify(productPayload)], { type: 'application/json' }))
  formData.append('image', selectedImage.value)

  try {
    await axios.post('/product/request', formData, {
      headers: {
        'Content-Type': 'multipart/form-data'
      }
    })
    alert('등록 요청이 전송되었습니다!')
  } catch (err) {
    console.error('❌ 등록 실패:', err)
    alert('등록 요청 실패')
  }
}
</script>

