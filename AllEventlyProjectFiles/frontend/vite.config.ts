import { fileURLToPath, URL } from 'node:url';
import { defineConfig } from 'vite';
import Vue from '@vitejs/plugin-vue';
import { liveDesigner } from '@pinegrow/vite-plugin';

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    liveDesigner({
      devServerUrls: {
        network: 'http://localhost:5173', // local URL
      },
    }),
    Vue(),
  ],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url).href),
      '~': fileURLToPath(new URL('./src', import.meta.url).href),
      '~~': fileURLToPath(new URL('./', import.meta.url).href),
    },
  },
  define: {
    'process.env': {}, // Required for compatibility with some libraries
  },
  build: {
    sourcemap: true, // Generate sourcemaps for debugging
  },
  server: {
    sourcemapIgnoreList: (sourcePath) => {
      // Suppress source map warnings for dependencies
      return sourcePath.includes('node_modules');
    },
  },
});
