<script setup lang="ts">
import { ref } from 'vue';
import logo from '@/assets/AllEventlyLogo.png';
import router from "@/router";

// Reactive data
const emailCode = ref('');
const newPassword = ref('');
const confirmPassword = ref('');
const codeError = ref(false);
const passwordError = ref(false);
const confirmPasswordError = ref(false);
const showSuccessDialog = ref(false);

// Methods
function validateForm() {
  // Reset error flags
  codeError.value = false;
  passwordError.value = false;
  confirmPasswordError.value = false;

  let isValid = true;

  // Check if the email code is valid (basic check, can be extended)
  if (!emailCode.value) {
    codeError.value = true;
    isValid = false;
  }

  // Check if passwords are entered
  if (!newPassword.value) {
    passwordError.value = true;
    isValid = false;
  }

  // Check if passwords match
  if (newPassword.value !== confirmPassword.value) {
    confirmPasswordError.value = true;
    isValid = false;
  }

  return isValid;
}

function handlePasswordUpdate() {
  if (validateForm()) {
    // Proceed with API call or logic to update password
    showSuccessDialog.value = true;
  }
}

function cancelUpdate() {
  // Reset form and redirect to Login page
  emailCode.value = '';
  newPassword.value = '';
  confirmPassword.value = '';
  router.push({ name: 'Login' });
}

function handleOkButtonClick() {
  router.push({ name: 'Login' });
}
</script>

<template>
  <section class="update-password-page">
    <img :src="logo" alt="AllEvently Logo" class="logo" />
    <div class="form-container">
      <h1>Update Password</h1>
      <div class="input-block">
        <label for="email-code">Emailed Code:</label>
        <input id="email-code" v-model="emailCode" type="text" />
        <span v-if="codeError" class="error-message">The code is incorrect. Please review and try again.</span>
      </div>
      <div class="input-block">
        <label for="new-password">New Password:</label>
        <input id="new-password" v-model="newPassword" type="password" />
        <span v-if="passwordError" class="error-message">Please enter a password.</span>
      </div>
      <div class="input-block">
        <label for="confirm-password">Confirm Password:</label>
        <input id="confirm-password" v-model="confirmPassword" type="password" />
        <span v-if="confirmPasswordError" class="error-message">Passwords must match.</span>
      </div>
      <button @click="handlePasswordUpdate" class="btn-update">Update Password</button>
      <a @click.prevent="cancelUpdate" href="#" class="cancel-link">Cancel</a>
    </div>

    <div v-if="showSuccessDialog" class="dialog">
      <h2>Password Updated!</h2>
      <p>Your password has been successfully updated. You can now use your new password to log in.</p>
      <button @click="handleOkButtonClick" class="btn-ok">OK</button>
    </div>
  </section>
</template>

<style scoped>

.update-password-page {
  font-family: Roboto, -apple-system, 'Helvetica Neue', 'Segoe UI', Arial, sans-serif;
  margin: 0;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100vh;
  background-color: #1A659E;
}

.logo {
  position: absolute;
  top: 0;
  left: 50%;
  transform: translateX(-50%);
  transition: top 0.3s ease;
  width: 250px;
  margin-bottom: 10px;
}

.form-container {
  background-color: #ffffff;
  border: 1px solid #ddd;
  padding: 20px;
  border-radius: 10px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  text-align: center;
  width: 100%;
  max-width: 300px;
}

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

.btn-update {
  color: #fbfdff;
  background: #db5650;
  border-radius: 25px;
  line-height: 40px;
  font-size: 18px;
  text-align: center;
  width: 100%;
  margin-bottom: 10px;
}

.btn-update:hover {
  background-color: #144d75;
}

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
