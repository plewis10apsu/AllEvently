<script setup lang="ts">
import logo from '@/assets/AllEventlyLogo.png';
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';
import { faArrowLeft  } from '@fortawesome/free-solid-svg-icons';
import router from "@/router";
import {ref} from "vue";

const userId = ref<string | null>(localStorage.getItem('userId') || null);


function navigateToEvents() {
  router.push({
    name: 'Events',
    params: {
      userId: userId.value,
    },
  });
}

</script>

<template>
  <header class="top-panel-with-back">
    <button class="back-button" @click="navigateToEvents">
      <FontAwesomeIcon :icon="faArrowLeft" /> Back
    </button>
    <div class="logo">
      <img :src="logo" alt="Logo" class="logo-img" />
    </div>
  </header>
</template>

<style scoped>
.top-panel-with-back {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  max-width: 100%;
  height: 90px;
  background-color: #f0f3fa;
  color: white;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 20px;
  z-index: 10;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
  overflow: visible;
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

.back-button {
  max-width: 150px;
  white-space: nowrap;
  background-color: #F7DDA8;
  border: none;
  color: #0D1821;
  padding: 10px 15px;
  font-size: 14px;
  border-radius: 20px;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 8px; /* Adds space between the icon and the text */
}

.back-button:hover {
  background-color: #FAC55A;
}
</style>