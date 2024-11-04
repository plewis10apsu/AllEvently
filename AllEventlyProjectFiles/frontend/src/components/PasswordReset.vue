<script setup lang="ts">
import { ref } from 'vue';
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
    <img src="@/assets/AllEventlyLogo.png" alt="AllEvently Logo" class="logo" />
    <div class="reset-form-container">
      <h1>Password Reset</h1>
      <p v-if="showError" class="error-message">Please enter a valid email address.</p>
      <div class="input-block">
        <label for="reset-email">Email:</label>
        <input id="reset-email" v-model="email" type="email" />
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

.logo {
  position: absolute;
  top: 10px;
  left: 50%;
  transform: translateX(-50%);
  transition: top 0.3s ease;
  width: 200px;
  margin-bottom: 10px;
}

 .reset-password-page {
   display: flex;
   flex-direction: column;
   justify-content: center;
   align-items: center;
   height: 100vh;
   background-color: #1A659E; /* Background color for the page */
   padding: 20px;
 }

/* Logo styling */
.logo {
  width: 250px; /* Adjusted size for the logo */
  margin-bottom: 30px;
}

/* Container for the form */
.reset-form-container {
  background-color: #ffffff; /* White background for form */
  border: 1px solid #ddd; /* Light border */
  padding: 20px;
  border-radius: 10px; /* Rounded corners */
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); /* Subtle shadow */
  text-align: left;
  width: 100%;
  max-width: 400px; /* Center width */
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
  width: calc(100% - 12px); /* Match the form size */
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

/* Button styling */
.btn-reset {
  background-color: #1a659e; /* Primary color */
  color: white;
  border: none;
  border-radius: 5px;
  padding: 10px 20px;
  cursor: pointer;
  font-size: 16px;
  width: 100%; /* Full width */
  margin-bottom: 10px; /* Spacing between button and cancel */
}

.btn-reset:hover {
  background-color: #144d75; /* Darker shade on hover */
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
