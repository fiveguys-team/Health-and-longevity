import { defineStore } from 'pinia'

export const useOrderStore = defineStore('order', {
    state: () => ({
        orderItem : null,
    }),
    actions: {
        setOrderItem(item) {
            this.orderItem = null
            this.orderItem = item
            sessionStorage.setItem('orderItem', JSON.stringify(item))
        },
        clearOrderItem() {
            this.orderItem = null
            sessionStorage.removeItem('orderItem')
        }
    }
})


export const useCartOrderStore = defineStore('cartOrder', {
    state: () => ({
        cartItems: []
    }),
    actions: {
        setCartItems(items) {
            this.cartItems = items
        },
        clearCartItems() {
            this.cartItems = []
        }
    }
})