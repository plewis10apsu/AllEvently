import { fileURLToPath, URL } from 'node:url';
import { defineConfig } from 'vite'
import Vue from '@vitejs/plugin-vue'
import { liveDesigner } from '@pinegrow/vite-plugin'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    liveDesigner({
      devServerUrls: {
        network: 'http://localhost:5173', // local URL
      },
    }),
    Vue(),
    //...
  ],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url)),
      '~': fileURLToPath(new URL('./src', import.meta.url)),
      '~~': fileURLToPath(new URL('./', import.meta.url)),
    },
  },
});
