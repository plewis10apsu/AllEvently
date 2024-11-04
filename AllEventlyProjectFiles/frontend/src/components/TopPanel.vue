<script setup lang="ts">
import { defineProps } from 'vue';

defineProps<{
  logo: string;
}>();
</script>

<template>
  <header class="top-panel">
    <div class="logo">
      <img :src="logo" alt="Logo" class="logo-img" />
    </div>
  </header>
</template>

<style scoped>
.top-panel {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 90px;
  background-color: #f0f3fa;
  color: white;
  display: flex;
  align-items: center;
  justify-content: flex-start;
  padding: 0 20px;
  z-index: 10;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.logo {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  margin: 20px 0;
}

.logo-img {
  height: 120px;
  width: auto;
  margin-top: -20px;
}
</style>