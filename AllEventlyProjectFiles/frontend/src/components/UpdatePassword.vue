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
  <div class="update-password-container">
    <div class="logo-section">
      <img :src="logo" alt="AllEvently Logo" class="logo">
    </div>

    <form @submit.prevent="handlePasswordUpdate">
      <div class="form-group">
        <label for="email-code">Emailed Code:</label>
        <input type="text" id="email-code" v-model="emailCode" required />
        <span v-if="codeError" class="error-message">The code is incorrect. Please review and try again.</span>
      </div>

      <div class="form-group">
        <label for="new-password">New Password:</label>
        <input type="password" id="new-password" v-model="newPassword" required />
        <span v-if="passwordError" class="error-message">Please enter a password.</span>
      </div>

      <div class="form-group">
        <label for="confirm-password">Confirm Password:</label>
        <input type="password" id="confirm-password" v-model="confirmPassword" required />
        <span v-if="confirmPasswordError" class="error-message">Passwords must match.</span>
      </div>

      <div class="button-group">
        <button type="submit" class="update-button">Update Password</button>
        <button type="button" class="cancel-button" @click="cancelUpdate">Cancel</button>
      </div>
    </form>

    <!-- Dialog box for success message -->
    <div v-if="showSuccessDialog" class="dialog">
      <h2>Password Updated!</h2>
      <p>Your password has been successfully updated. You can now use your new password to log in.</p>
      <button @click="handleOkButtonClick" class="btn-ok">OK</button>
    </div>
  </div>
</template>


<style scoped>
.update-password-container {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  height: 100vh;
  background-color: #1A659E;
  padding: 20px;
  text-align: center;
}

.logo-section img {
  width: 250px;
  margin-bottom: 30px;
}

/* Form container styling */
form {
  background-color: #ffffff; /* White background for form */
  border: 1px solid #ddd; /* Light border */
  padding: 20px;
  border-radius: 10px; /* Rounded corners */
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); /* Subtle shadow */
  text-align: left;
  width: 100%;
  max-width: 400px; /* Center width */
}

/* Form group styling */
.form-group {
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  font-size: 14px;
  margin-bottom: 5px;
}

.form-group input {
  width: calc(100% - 12px); /* Full width to match the form */
  padding: 10px;
  border: 1px solid #ccc;
  border-radius: 5px;
  font-size: 14px;
}

/* Error message */
.error-message {
  color: red;
  font-size: 14px;
  margin-bottom: 10px;
}

/* Button group styling */
.button-group {
  display: flex;
  justify-content: space-between;
  flex-direction: column;
}

.update-button, .cancel-button {
  background-color: #1a659e; /* Primary color */
  color: white;
  border: none;
  border-radius: 5px;
  padding: 10px 20px;
  cursor: pointer;
  font-size: 16px;
  margin-bottom: 10px; /* Spacing for buttons */
  width: 100%; /* Full width */
}

.update-button:hover, .cancel-button:hover {
  background-color: #144d75; /* Darker shade for hover */
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
  background-color: #1a659e; /* Button color */
  color: white;
  border: none;
  border-radius: 5px;
  padding: 10px 20px;
  cursor: pointer;
  width: 100%; /* Full width */
}

.btn-ok:hover {
  background-color: #144d75; /* Darker shade */
}

</style>