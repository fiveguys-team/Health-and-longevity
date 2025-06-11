import { defineStore } from 'pinia'

export const useOrderStore = defineStore('order', {
    state: () => ({
        orderItem : null,
    }),
    actions: {
        setOrderItem(item) {
            this.orderItem = item
        },
        clearOrderItem() {
            this.orderItem = null
        }
    }
})