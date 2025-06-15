import { defineStore } from 'pinia';

export const useAuthStore = defineStore('auth', {
    state: () => ({
        token: localStorage.getItem('token') || null,
        role: localStorage.getItem('role') || null,
        userId: localStorage.getItem('userId') || null,
        userName: localStorage.getItem('userName') || null
    }),

    actions: {
        login(token, role, userId, userName) {
            this.token = token;
            this.role = role;
            this.userId = userId;
            this.userName = userName;
            
            localStorage.setItem('token', token);
            localStorage.setItem('role', role);
            localStorage.setItem('userId', userId);
            localStorage.setItem('userName', userName);
        },

        logout() {
            this.token = null;
            this.role = null;
            this.userId = null;
            this.userName = null;
            
            localStorage.removeItem('token');
            localStorage.removeItem('role');
            localStorage.removeItem('userId');
            localStorage.removeItem('userName');
        },

        isAuthorized(requiredRoles = []) {
            return this.token && requiredRoles.includes(this.role);
        }
    }
});