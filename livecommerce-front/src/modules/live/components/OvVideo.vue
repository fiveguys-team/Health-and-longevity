<!--
  OvVideo.vue
  OpenVidu 비디오 스트림을 표시하는 재사용 가능한 컴포넌트
  OpenVidu 스트림 객체를 받아 비디오 엘리먼트에 연결
  비디오 스트림의 실시간 렌더링
-->

<script setup>
import { onMounted, ref } from 'vue';
import { defineProps } from 'vue';

// props 타입 정의
// streamManager: OpenVidu의 스트림을 관리하는 객체
const props = defineProps({
  streamManager: {
    type: Object,
    required: true // streamManager는 필수 prop으로 지정
  }
});

const videoRef = ref(null);

// 컴포넌트가 DOM에 마운트된 후 실행되는 로직
onMounted(() => {
  if (props.streamManager && videoRef.value) {
    props.streamManager.addVideoElement(videoRef.value);
  }
});
</script>

<!--비디오 스트림 준비 시 자동 재생-->
<template>
  <video ref="videoRef" autoplay />
</template>

<style scoped>
video {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
</style>

