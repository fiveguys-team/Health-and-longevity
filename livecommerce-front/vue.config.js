// vue.config.js
const path = require("path");
const { defineConfig } = require("@vue/cli-service");

module.exports = defineConfig({
  transpileDependencies: true,
  chainWebpack: (config) => {
    config.resolve.alias.set("@", path.resolve(__dirname, "src"));
  },
  devServer: {
    port: 3000, // 원하는 포트 번호로 변경 (예: 3000, 5000, 8081 등)
  },
});
