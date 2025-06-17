const path = require("path");
const { defineConfig } = require("@vue/cli-service");

module.exports = defineConfig({
  transpileDependencies: true,
  chainWebpack: (config) => {
    config.resolve.alias.set("@", path.resolve(__dirname, "src"));
  },
  devServer: {
    port: 3000,
    proxy: {
      '^/admin': {
        target: 'http://localhost:8080',
        changeOrigin: true,
      },
      '^/products': {
        target: 'http://localhost:8080',
        changeOrigin: true,
      },
      '^/product': {
        target: 'http://localhost:8080',
        changeOrigin: true,
      },
      '^/uploads': {
        target: 'http://localhost:8080',
        changeOrigin: true,
      },
      '^/vendors': {
        target: 'http://localhost:8080',
        changeOrigin: true,
      }
    }

  },
});
