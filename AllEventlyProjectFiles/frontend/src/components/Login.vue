<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router';
import GoogleSSO from './GoogleSSO.vue';

const firstName = ref('')
const lastName = ref('')
const email = ref('')
const password = ref('')
const router = useRouter();
const switchToSignup = ref(false) // Logic to switch between forms

const toggleForm = (formType: 'login' | 'signup') => {
  switchToSignup.value = formType === 'signup'
}

const handleLogin = () => {
  router.push('/events');   // Redirect to the Events page
};

</script>

<template>
  <section class="forms-section">
    <img src="../../AllEventlyLogo(2).png" alt="AllEvently Logo" class="logo">
    <div class="forms">
      <div :class="['form-wrapper', { 'is-active': !switchToSignup }]">
        <button @click="toggleForm('login')" type="button" class="switcher switcher-login">
          Login<span class="underline"></span>
        </button>
        <form class="form form-login">
          <fieldset>
            <legend>Please, enter your email and password for login.</legend>

            <!-- Email Field (Login) -->
            <div class="input-block">
              <label for="login-email">E-mail</label>
              <input id="login-email" type="email" required>
            </div>

            <!-- Password Field (Login) -->
            <div class="input-block">
              <label for="login-password">Password</label>
              <input id="login-password" type="password" required>
            </div>

          </fieldset>
          <button @click="handleLogin" type="submit" class="btn-login">Login</button>

          <!-- Reset Password Link -->
          <a href="/reset-password" class="reset-password-link">Reset Password</a>

          <!-- Separator -->
          <div class="separator" :class="{ 'hidden': switchToSignup }">
            <span>OR</span>
          </div>

          <!-- Google Login Button -->
          <div class="google-signup-container" :class="{ 'hidden': switchToSignup }">
          <GoogleSSO buttonText="Login with Google" />
          </div>

        </form>
      </div>

      <div :class="['form-wrapper', { 'is-active': switchToSignup }]">
        <button @click="toggleForm('signup')" type="button" class="switcher switcher-signup">
          Sign Up<span class="underline"></span>
        </button>

        <form class="form form-signup">
          <fieldset>
            <legend>Please, enter your details for sign up.</legend>

            <!-- First Name Field -->
            <div class="input-block">
              <label for="signup-first-name">First Name</label>
              <input id="signup-first-name" v-model="firstName" type="text" required>
            </div>

            <!-- Last Name Field -->
            <div class="input-block">
              <label for="signup-last-name">Last Name</label>
              <input id="signup-last-name" v-model="lastName" type="text" required>
            </div>

            <!-- Email Field -->
            <div class="input-block">
              <label for="signup-email">E-mail</label>
              <input id="signup-email" v-model="email" type="email" required>
            </div>

            <!-- Password Field -->
            <div class="input-block">
              <label for="signup-password">Password</label>
              <input id="signup-password" v-model="password" type="password" required>
            </div>

          </fieldset>

          <button type="submit" class="btn-signup">Sign Up</button>

          <!-- Separator -->
          <div class="separator" :class="{ 'hidden': !switchToSignup }">
            <span>OR</span>
          </div>

          <!-- Google Sign Up Button -->
          <div class="google-signup-container" :class="{ 'hidden': !switchToSignup }">
          <GoogleSSO buttonText="Sign Up with Google" />
          </div>

        </form>
      </div>
    </div>
  </section>
</template>

<style>
body {
  margin: 0;
  font-family: Roboto, -apple-system, 'Helvetica Neue', 'Segoe UI', Arial, sans-serif;
  background: #2c3e50;
}

.separator {
  display: flex;
  align-items: center;
  text-align: center;
  margin: 20px 0;
}

.separator::before,
.separator::after {
  content: '';
  flex: 1;
  border-bottom: 1px solid #ccc;
}

.separator:not(:empty)::before {
  margin-right: 10px;
}

.separator:not(:empty)::after {
  margin-left: 10px;
}

.separator span {
  font-weight: bold;
  color: #666;
}

.google-signup-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  margin-top: 20px;
}

</style>

<style scoped>
*,
*::before,
*::after {
  box-sizing: border-box;
}

.logo {
  width: 200px;
  margin-bottom: 20px; /* Space below the logo */
}

.hidden {
  display: none !important;
}

.forms-section {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}


.forms {
  display: flex;
  align-items: flex-start;
  margin-top: 30px;
}

.form-wrapper {
  animation: hideLayer .3s ease-out forwards;
}

.form-wrapper.is-active {
  animation: showLayer .3s ease-in forwards;
}

@keyframes showLayer {
  50% {
    z-index: 1;
  }
  100% {
    z-index: 1;
  }
}

@keyframes hideLayer {
  0% {
    z-index: 1;
  }
  49.999% {
    z-index: 1;
  }
}

.switcher {
  position: relative;
  cursor: pointer;
  display: block;
  margin-right: auto;
  margin-left: auto;
  padding: 0;
  text-transform: uppercase;
  font-family: inherit;
  font-size: 16px;
  letter-spacing: .5px;
  color: #999;
  background-color: transparent;
  border: none;
  outline: none;
  transform: translateX(0);
  transition: all .3s ease-out;
}

.form-wrapper.is-active .switcher-login {
  color: #fff;
  transform: translateX(90px);
}

.form-wrapper.is-active .switcher-signup {
  color: #fff;
  transform: translateX(-90px);
}

.underline {
  position: absolute;
  bottom: -5px;
  left: 0;
  overflow: hidden;
  pointer-events: none;
  width: 100%;
  height: 2px;
}

.underline::before {
  content: '';
  position: absolute;
  top: 0;
  left: inherit;
  display: block;
  width: inherit;
  height: inherit;
  background-color: currentColor;
  transition: transform .2s ease-out;
}

.switcher-login .underline::before {
  transform: translateX(101%);
}

.switcher-signup .underline::before {
  transform: translateX(-101%);
}

.form-wrapper.is-active .underline::before {
  transform: translateX(0);
}

.form {
  overflow: hidden;
  min-width: 260px;
  margin-top: 50px;
  padding: 30px 25px;
  border-radius: 5px;
  transform-origin: top;
}

.form-login {
  animation: hideLogin .3s ease-out forwards;
}

.form-wrapper.is-active .form-login {
  animation: showLogin .3s ease-in forwards;
}

@keyframes showLogin {
  0% {
    background: #d7e7f1;
    transform: translate(40%, 10px);
  }
  50% {
    transform: translate(0, 0);
  }
  100% {
    background-color: #fff;
    transform: translate(35%, -20px);
  }
}

@keyframes hideLogin {
  0% {
    background-color: #fff;
    transform: translate(35%, -20px);
  }
  50% {
    transform: translate(0, 0);
  }
  100% {
    background: #d7e7f1;
    transform: translate(40%, 10px);
  }
}

.form-signup {
  animation: hideSignup .3s ease-out forwards;
}

.form-wrapper.is-active .form-signup {
  animation: showSignup .3s ease-in forwards;
}

@keyframes showSignup {
  0% {
    background: #d7e7f1;
    transform: translate(-40%, 10px) scaleY(.8);
  }
  50% {
    transform: translate(0, 0) scaleY(.8);
  }
  100% {
    background-color: #fff;
    transform: translate(-35%, -20px) scaleY(1);
  }
}

@keyframes hideSignup {
  0% {
    background-color: #fff;
    transform: translate(-35%, -20px) scaleY(1);
  }
  50% {
    transform: translate(0, 0) scaleY(.8);
  }
  100% {
    background: #d7e7f1;
    transform: translate(-40%, 10px) scaleY(.8);
  }
}

.form fieldset {
  position: relative;
  opacity: 0;
  margin: 0;
  padding: 0;
  border: 0;
  transition: all .3s ease-out;
}

.form-login fieldset {
  transform: translateX(-50%);
}

.form-signup fieldset {
  transform: translateX(50%);
}

.form-wrapper.is-active fieldset {
  opacity: 1;
  transform: translateX(0);
  transition: opacity .4s ease-in, transform .35s ease-in;
}

.form legend {
  position: absolute;
  overflow: hidden;
  width: 1px;
  height: 1px;
  clip: rect(0 0 0 0);
}

.input-block {
  margin-bottom: 20px;
}

.input-block label {
  font-size: 14px;
  color: #a1b4b4;
}

.input-block input {
  display: block;
  width: 100%;
  margin-top: 8px;
  padding-right: 15px;
  padding-left: 15px;
  font-size: 16px;
  line-height: 40px;
  color: #3b4465;
  background: #eef9fe;
  border: 1px solid #cddbef;
  border-radius: 2px;
}

.form [type='submit'] {
  opacity: 0;
  display: block;
  min-width: 120px;
  margin: 30px auto 10px;
  font-size: 18px;
  line-height: 40px;
  border-radius: 25px;
  border: none;
  transition: all .3s ease-out;
}

.form-wrapper.is-active .form [type='submit'] {
  opacity: 1;
  transform: translateX(0);
  transition: all .4s ease-in;
}

.reset-password-link {
  display: block;
  text-align: center;
  margin-top: 10px;
  color: #007bff;
  text-decoration: none;
  font-size: 14px;
}

.reset-password-link:hover {
  text-decoration: underline;
}


.btn-login {
  color: #fbfdff;
  background: #a7e245;
  transform: translateX(-30%);
}

.btn-signup {
  color: #a7e245;
  background: #fbfdff;
  box-shadow: inset 0 0 0 2px #a7e245;
  transform: translateX(30%);
}
</style>
