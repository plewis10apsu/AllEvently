<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router';

const email = ref('')
const password = ref('')
const router = useRouter();

const handleLogin = () => {
  // Add your authentication logic here, then redirect on success
  router.push('/events');   // Redirect to the Events page
};
</script>

<template>
  <div>
    <!-- Login Form -->
    <input type="email" placeholder="Email" />
    <input type="password" placeholder="Password" />
    <button @click="handleLogin">Login</button>
  </div>
</template>

<style scoped>
.login-container {
  width: 300px;
  margin: 100px auto;
  padding: 20px;
  border: 1px solid #ccc;
  border-radius: 10px;
}

.input-group {
  margin-bottom: 15px;
}

label {
  display: block;
  margin-bottom: 5px;
}

input {
  width: 100%;
  padding: 8px;
  margin-top: 5px;
  box-sizing: border-box;
}

button {
  width: 100%;
  padding: 10px;
  background-color: #42b983;
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
}

button:hover {
  background-color: #359970;
}
</style>