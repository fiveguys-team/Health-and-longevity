// vue.config.js
const path = require("path");
const { defineConfig } = require("@vue/cli-service");

module.exports = defineConfig({
  transpileDependencies: true,
  chainWebpack: (config) => {
    config.resolve.alias.set("@", path.resolve(__dirname, "src"));
  },
  devServer: {
    port: 3000, // Vue 개발 서버 포트
    proxy: {
      '/product': {
        target: 'http://localhost:8080', // Spring 서버 주소
        changeOrigin: true,
      }
    }
  },
});
