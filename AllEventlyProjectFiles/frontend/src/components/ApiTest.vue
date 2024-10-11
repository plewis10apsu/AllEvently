<script setup lang="ts">
import { ref, onMounted } from 'vue';
import axios from 'axios';

const message = ref('Loading...');

onMounted(async () => {
  try {
    const response = await axios.get('http://localhost:3000');  // Adjust this if necessary
    message.value = response.data;
  } catch (error) {
    console.error('Error fetching data:', error);
    message.value = 'Error loading data';
  }
});
</script>

<template>
  <div>
    <h1>API Test</h1>
    <p>{{ message }}</p>
  </div>
</template>

<style scoped>
h1 {
  color: #42b983;
}
</style>