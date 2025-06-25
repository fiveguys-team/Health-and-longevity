<template>
  <div v-if="visible" class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50">
    <div class="bg-white w-full max-w-md p-6 rounded-xl shadow-xl">
      <h2 class="text-xl font-bold mb-4">{{ type }} 요청</h2>

      <textarea
          v-model="reason"
          class="w-full border rounded p-2 mb-4"
          placeholder="사유를 입력해주세요"
          rows="4"
      ></textarea>

      <input type="file" @change="onFileChange" class="mb-4" />

      <div class="flex justify-end space-x-2">
        <button @click="onCancel" class="px-4 py-2 border rounded hover:bg-gray-100">취소</button>
        <button @click="onSubmit" class="px-4 py-2 bg-primary text-white rounded">제출</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, defineEmits, defineProps } from 'vue'

const props = defineProps({
  visible: Boolean,
  type: String // '환불' 또는 '교환'
})

const emits = defineEmits(['close', 'submit'])

const reason = ref('')
const file = ref(null)

function onFileChange(event) {
  file.value = event.target.files[0]
}

function onCancel() {
  emits('close')
}

function onSubmit() {
  emits('submit', {
    reason: reason.value,
    file: file.value,
    type: props.type
  })
  reason.value = ''
  file.value = null
}
</script>
