/**
 * liveStreaming.js
 * 라이브 스트리밍 관련 전역 상태 관리를 위한 Pinia 스토어
 *
 * 주요 기능:
 * 1. OpenVidu 세션 상태 관리
 *    - 세션 생성, 연결, 종료
 *    - 토큰 관리
 *    - 스트림 관리
 *
 * 2. 방송 정보 관리
 *    - 방송 제목, 설명
 *    - 상품 정보
 *    - 시청자 수
 *
 * 3. 디바이스 상태 관리
 *    - 카메라/마이크 상태
 *    - 디바이스 설정
 *
 * 4. 에러 처리
 *    - 연결 오류
 *    - 디바이스 접근 오류
 *    - 세션 관련 오류
 *
 * State:
 * - session: OpenVidu 세션 객체
 * - publisher: 스트림 발행자 객체
 * - subscribers: 구독자 목록
 * - streamInfo: 방송 정보
 * - deviceSettings: 디바이스 설정
 *
 * Actions:
 * - initializeSession: 세션 초기화
 * - connectToSession: 세션 연결
 * - leaveSession: 세션 종료
 * - publishStream: 스트림 발행
 * - subscribeToStream: 스트림 구독
 * - updateDeviceSettings: 디바이스 설정 업데이트
 */

import { defineStore } from 'pinia'
import axios from 'axios'
import { ref } from 'vue'

const APPLICATION_SERVER_URL = process.env.NODE_ENV === 'production' ? '' : 'http://localhost:8080/'

export const useLiveStreamingStore = defineStore('liveStreaming', () => {
  // 현재 진행 중인 모든 라이브 방송 목록
  const activeStreams = ref([])
  // 현재 선택된 스트림
  const currentStream = ref(null)
  // 에러 상태
  const error = ref(null)
  // 로딩 상태
  const isLoading = ref(false)

  // 라이브 방송 목록 조회
  const fetchLiveStreams = async () => {
    try {
      isLoading.value = true
      error.value = null
      console.log('방송 목록 조회 시작')

      // 실제 API 호출이 실패하면 임시 데이터 사용
      try {
        const response = await axios.get(`${APPLICATION_SERVER_URL}api/streams`)
        activeStreams.value = response.data
        console.log('방송 목록 조회 성공:', activeStreams.value)
        return response.data
      } catch (apiError) {
        console.warn('API 호출 실패, 임시 데이터 사용:', apiError)
        // API 호출 실패 시 현재 activeStreams 반환
        return activeStreams.value
      }
    } catch (error) {
      console.error('방송 목록 조회 실패:', error)
      error.value = '방송 목록을 불러오는데 실패했습니다.'
      return []
    } finally {
      isLoading.value = false
    }
  }

  // 새로운 라이브 방송 생성
  // const createStream = async (streamData) => {
  //   try {
  //     isLoading.value = true
  //     const response = await axios.post(
  //       `${APPLICATION_SERVER_URL}api/streams`,
  //       streamData,
  //       {
  //         headers: {
  //           'Content-Type': 'application/json'
  //         }
  //       }
  //     )

  //     // 생성된 방송을 목록에 추가
  //     activeStreams.value.push(response.data)
  //     return response.data
  //   } catch (error) {
  //     console.error('방송 생성 실패:', error)
  //     error.value = error
  //     throw error
  //   } finally {
  //     isLoading.value = false
  //   }
  // }

  // // 새로운 스트림 시작
  // const startStream = async (streamData) => {
  //   try {
  //     isLoading.value = true
  //     error.value = null
  //     console.log('스트림 시작 요청:', streamData)

  //     // 실제 API 호출이 실패하면 임시 데이터 생성
  //     try {
  //       const response = await axios.post(
  //         `${APPLICATION_SERVER_URL}api/streams/start`,
  //         streamData,
  //         {
  //           headers: {
  //             'Content-Type': 'application/json'
  //           }
  //         }
  //       )
  //       console.log('스트림 시작 API 응답:', response.data)
  //       const newStream = response.data
  //       activeStreams.value = [...activeStreams.value, newStream]
  //       currentStream.value = newStream
  //       return newStream
  //     } catch (apiError) {
  //       console.warn('API 호출 실패, 임시 데이터 생성:', apiError)
  //       // 임시 스트림 데이터 생성
  //       const newStream = {
  //         id: Date.now().toString(),
  //         sessionId: streamData.sessionId,
  //         title: streamData.title,
  //         hostName: '호스트',
  //         productInfo: streamData.productInfo,
  //         viewerCount: 0,
  //         startedAt: new Date().toISOString(),
  //         thumbnailUrl: '/default-thumbnail.jpg'
  //       }
  //       activeStreams.value = [...activeStreams.value, newStream]
  //       currentStream.value = newStream
  //       console.log('임시 스트림 생성됨:', newStream)
  //       return newStream
  //     }
  //   } catch (error) {
  //     console.error('스트림 시작 실패:', error)
  //     error.value = error
  //     throw error
  //   } finally {
  //     isLoading.value = false
  //   }
  // }

  // 스트림 종료
  // const endStream = async (streamId) => {
  //   try {
  //     isLoading.value = true
  //     error.value = null
  //     console.log('스트림 종료 요청:', streamId)

  //     try {
  //       await axios.post(
  //         `${APPLICATION_SERVER_URL}api/streams/${streamId}/end`
  //       )
  //     } catch (apiError) {
  //       console.warn('API 호출 실패, 로컬에서만 종료:', apiError)
  //     }

  //     // 스트림 목록에서 제거
  //     activeStreams.value = activeStreams.value.filter(s => s.id !== streamId)

  //     if (currentStream.value?.id === streamId) {
  //       currentStream.value = null
  //     }

  //     console.log('스트림 종료 완료')
  //   } catch (error) {
  //     console.error('스트림 종료 실패:', error)
  //     error.value = error
  //     throw error
  //   } finally {
  //     isLoading.value = false
  //   }
  // }

  // 방송 참여
  // const joinStream = async (streamId) => {
  //   try {
  //     isLoading.value = true
  //     error.value = null
  //     console.log('방송 참여 요청:', streamId)

  //     try {
  //       const response = await axios.post(
  //         `${APPLICATION_SERVER_URL}api/streams/${streamId}/join`
  //       )
  //       currentStream.value = response.data
  //       return response.data
  //     } catch (apiError) {
  //       console.warn('API 호출 실패, 로컬 데이터 사용:', apiError)
  //       const stream = activeStreams.value.find(s => s.id === streamId)
  //       if (stream) {
  //         currentStream.value = stream
  //         return stream
  //       }
  //       throw new Error('방송을 찾을 수 없습니다.')
  //     }
  //   } catch (error) {
  //     console.error('방송 참여 실패:', error)
  //     error.value = '방송 참여에 실패했습니다.'
  //     throw error
  //   } finally {
  //     isLoading.value = false
  //   }
  // }

  // 방송 나가기
  // const leaveStream = async (streamId) => {
  //   try {
  //     isLoading.value = true
  //     error.value = null
  //     console.log('방송 나가기 요청:', streamId)

  //     try {
  //       await axios.post(
  //         `${APPLICATION_SERVER_URL}api/streams/${streamId}/leave`
  //       )
  //     } catch (apiError) {
  //       console.warn('API 호출 실패:', apiError)
  //     }

  //     currentStream.value = null
  //   } catch (error) {
  //     console.error('방송 나가기 실패:', error)
  //     error.value = '방송 나가기에 실패했습니다.'
  //   } finally {
  //     isLoading.value = false
  //   }
  // }

  // 채팅 메시지 추가
  const addChatMessage = (message) => {
    // Implementation needed
  }

  // 좋아요 증가
  const increaseLike = async (streamId) => {
    try {
      await axios.post(
          `${APPLICATION_SERVER_URL}api/streams/${streamId}/like`
      )
      // Implementation needed
    } catch (error) {
      console.error('좋아요 실패:', error)
    }
  }

  // 시청자 수 업데이트
  const updateViewerCount = (streamId, count) => {
    const stream = activeStreams.value.find(s => s.id === streamId)
    if (stream) {
      stream.viewerCount = count
      console.log('시청자 수 업데이트:', streamId, count)
    }
  }

  // 에러 초기화
  const clearError = () => {
    error.value = null
  }

  return {
    activeStreams,
    currentStream,
    error,
    isLoading,
    fetchLiveStreams,
    createStream,
    startStream,
    endStream,
    joinStream,
    leaveStream,
    addChatMessage,
    increaseLike,
    updateViewerCount,
    clearError
  }
})