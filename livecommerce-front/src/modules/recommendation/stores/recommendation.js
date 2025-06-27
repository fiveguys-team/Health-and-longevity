import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useRecommendationStore = defineStore('recommendation', () => {
  const recommendations = ref([])

  function setRecommendations(list) {
    recommendations.value = Array.isArray(list)
      ? list.slice(0, 4).map(item => ({
          id: item.productId,
          name: item.productName,
          image: item.productImage,
          price: item.price,
          stockCount: item.stockCount,
          vendor: item.vendorName || '',
          discountRate: 0,
          discountedPrice: item.price,
        }))
      : []
  }

  function clearRecommendations() {
    recommendations.value = []
  }

  return { recommendations, setRecommendations, clearRecommendations }
}) 