<!--
  UserVideo.vue
  소비자 화면에서 입점업체의 스트림을 표시하는 컴포넌트
  OpenVidu 스트림 구독 및 표시
-->

<script setup>
import { computed } from 'vue';
import { defineProps } from 'vue';

// 자식 컴포넌트인 OvVideo import
import OvVideo from '@/modules/live/components/OvVideo.vue';

const props = defineProps({
  streamManager: {
    type: Object,
    required: true
  }
});

/**
 * streamManager의 connection 데이터를 파싱하여 반환하는 함수
 * @returns {Object} 파싱된 연결 데이터 (clientData 등 포함)
 */
const getConnectionData = () => {
  // connection: 스트림 연결 정보를 담고 있는 객체
  const { connection } = props.streamManager.stream;
  // connection.data는 JSON 문자열 형태로 저장된 사용자 정보
  //-> 입점업체, 소비자에 따라 데이터 달라진다.
  return JSON.parse(connection.data);
};

/**
 * streamManager의 연결 데이터에서 clientData를 추출하여 반환
 * @type {ComputedRef<any>}
 */
const clientData = computed(() => {
  // { } : 구조 분해 할당 -> getConnectionData() 가 반환하는 객체에서
  // clientData 프로퍼티만 꺼내서 변수에 바로 할당하는 문법
  const { clientData } = getConnectionData();
  return clientData;
});
</script>

<!--
  사용자의 비디오 스트림을 표시
  streamManager가 존재할 때만 렌더링
  clientData를 통해 사용자 정보 표시
-->
<template>
  <div v-if="streamManager">
    <!-- 
      OvVideo 컴포넌트에 streamManager 전달
      stream-manager prop을 통해 비디오 스트림 데이터 전달
      실제 비디오 렌더링은 OvVideo 컴포넌트에서 처리
    -->
    <ov-Video :stream-manager="streamManager" />
    <!-- 사용자 정보 표시 영역 -->
    <div>
      <div>변경예정</div>
      <p>{{ clientData }}</p>
    </div>
  </div>
</template>

<style scoped>
/* Add your styles here */
</style>

