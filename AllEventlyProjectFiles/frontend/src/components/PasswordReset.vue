<script setup lang="ts">
import { ref } from 'vue';
import logo from '@/assets/AllEventlyLogo.png';
import router from "@/router";

const email = ref('');
const isEmailValid = ref(true);
const showSuccessDialog = ref(false);
const showError = ref(false);

const validateEmail = () => {
  const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
  isEmailValid.value = emailPattern.test(email.value);
};

const handleResetPassword = () => {
  validateEmail();
  if (!isEmailValid.value || !email.value) {
    showError.value = true;
  } else {
    showError.value = false;
    showSuccessDialog.value = true;
    // Logic to send the password reset request would go here
  }
};

const handleOkButtonClick = () => {
  showSuccessDialog.value = false; //
  router.push({ name: 'UpdatePassword' });
};

</script>

<template>
  <section class="reset-password-page">
    <img :src="logo" alt="AllEvently Logo" class="logo" />
    <div class="reset-form-container">
      <h1>Password Reset</h1>
      <div class="input-block">
        <label for="reset-email">Email:</label>
        <input id="reset-email" v-model="email" type="email" />
        <span v-if="showError" class="error-message">Please enter a valid email address.</span>
      </div>
      <button @click="handleResetPassword" class="btn-reset">Reset Password</button>
      <a href="/" class="cancel-link">Cancel</a>
    </div>

    <div v-if="showSuccessDialog" class="dialog">
      <h2>Reset Password Code Sent!</h2>
      <p>If the email address is valid, a code to reset the password has been sent.</p>
      <button @click="handleOkButtonClick" class="btn-ok">OK</button>
    </div>
  </section>
</template>


<style scoped>
@import '@/styles/common.css';

.reset-password-page {
  font-family: Roboto, -apple-system, 'Helvetica Neue', 'Segoe UI', Arial, sans-serif;
  margin: 0;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100vh;
  background-color: #1A659E;
  overflow: visible;
}

.reset-form-container h1 {
  font-weight: bold;
  font-size: 14px;
  margin-bottom: 10px;
  color: #333;
}

/* Container for the form */
.reset-form-container {
  background-color: #ffffff;
  border: 1px solid #ddd;
  padding: 20px;
  border-radius: 10px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  text-align: center;
  width: 100%;
  max-width: 300px;
}

/* Input block styling */
.input-block {
  margin-bottom: 15px;
}

.input-block label {
  display: block;
  font-size: 14px;
  margin-bottom: 5px;
}

.input-block input {
  width: 100%;
  box-sizing: border-box;
  padding: 10px;
  font-size: 16px;
  line-height: 1.5;
  border: 1px solid #cddbef;
  border-radius: 4px;
  background-color: #eef9fe;
  color: #0d1821;
}

/* Error message */
.error-message {
  color: red;
  font-size: 14px;
  margin-bottom: 10px;
}

/* Button styling */
.btn-reset {
  margin-top: 0 !important;
  margin-bottom: 5px !important;
  color: #fbfdff;
  background: #db5650;
  border-radius: 25px;
  line-height: 40px;
  font-size: 18px;
  text-align: center;
  width: 100%;
  box-shadow: none;
  transition: all 0.3s ease-out;
}

.btn-reset:hover {
  background-color: #144d75;
}

/* Cancel link */
.cancel-link {
  display: block;
  text-align: center;
  color: #1a659e;
  text-decoration: none;
  font-size: 14px;
}

.cancel-link:hover {
  text-decoration: underline;
}

/* Success dialog styling */
.dialog {
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  background-color: #ffffff;
  padding: 20px;
  border-radius: 10px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
  text-align: center;
  max-width: 300px;
  width: 100%;
}

.dialog h2 {
  font-size: 18px;
  margin-bottom: 10px;
}

.dialog p {
  font-size: 14px;
  margin-bottom: 20px;
}

.btn-ok {
  background-color: #1a659e;
  color: white;
  border: none;
  border-radius: 5px;
  padding: 10px 20px;
  cursor: pointer;
  width: 100%;
}

.btn-ok:hover {
  background-color: #144d75;
}
</style>

