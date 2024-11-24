<script setup lang="ts">
import {ref} from 'vue'
import {useRouter} from 'vue-router';
import GoogleSSO from './GoogleSSO.vue';
import logo from '@/assets/AllEventlyLogo.png';
import visibleIcon from '@/assets/Visible_Icon.png';
import invisibleIcon from '@/assets/Invisible_Icon.png';

const firstName = ref('');
const lastName = ref('');
const email = ref('');
const isEmailValid = ref(true);
const password = ref('');
const showPassword = ref(false);
const currentIcon = ref(visibleIcon);

const errorMessageFirstName = ref('');
const errorMessageLastName = ref('');
const errorMessageEmail = ref('');
const errorMessagePassword = ref('');

const validateEmail = () => {
  const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
  isEmailValid.value = emailPattern.test(email.value);
};
//experimental signup function. Please work 🙏🏻
const handleSignup = async () => {
  errorMessageFirstName.value = '';
  errorMessageLastName.value = '';
  errorMessageEmail.value = '';
  errorMessagePassword.value = '';

  if (!firstName.value) {
    errorMessageFirstName.value = 'Please enter your first name.';
  }
  if (!lastName.value) {
    errorMessageLastName.value = 'Please enter your last name.';
  }
  if (!email.value) {
    errorMessageEmail.value = 'Please enter an email address.';
  } else {
    validateEmail(); // Validate email format
    if (!isEmailValid.value) {
      errorMessageEmail.value = 'Please enter a valid email address.';
    }
  }
  if (!password.value) {
    errorMessagePassword.value = 'Please enter your password.';
  }

  if (firstName.value && lastName.value && email.value && isEmailValid.value && password.value) {
    // Place your signup logic here
    //console.log("Sign up successful!");
    try {
      console.log("Before calling endpoint");
      const response = await fetch('https://all-evently-backend.vercel.app/api/signup', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          email: email.value,
          password: password.value,
          firstName: firstName.value,
          lastName: lastName.value
        }),
      });
      console.log("After endpoint");

      if (response.ok) {
        const data = await response.json();
        alert(data.message);
      } else {
        /*
        const error = await response.json();
        console.log("Caught in response.ok error...");
        alert(error.message);
        */
        response.json().then(data => {
          console.error('Error response from server:', data);
          alert(data.message + (data.error ? `: ${data.error}` : ''));
        });


      }
    } catch (err) {
      console.log("Error during signup: ", err);
      alert('Something went wrong. Please try again.');
    }
  }
};

const router = useRouter();
const switchToSignup = ref(false)


const togglePasswordVisibility = () => {
  showPassword.value = !showPassword.value;
  currentIcon.value = showPassword.value ? invisibleIcon : visibleIcon;
};

const toggleForm = (formType: 'login' | 'signup') => {
  switchToSignup.value = formType === 'signup'
}

const handleLogin = () => {
  router.push('/events');   // Redirect to the Events page
};

const handleResetPasswordLink = () => {
  router.push('/password-reset'); // Redirect to the Password Reset page
};

</script>

<template>
  <section class="login-page">
    <section class="forms-section">

      <div class="forms">
        <img :src="logo" alt="AllEvently Logo" class="logo">
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
                <input id="login-email" v-model="email" type="email">
                <span v-if="errorMessageEmail" class="error-message">{{ errorMessageEmail }}</span>
              </div>


              <!-- Password Field (Login) -->
              <div class="input-block">
                <label for="password">Password</label>
                <div class="password-input-wrapper">
                  <input id="password" :type="showPassword ? 'text' : 'password'" v-model="password"
                  />
                  <!-- Icon for toggling password visibility (Login) -->
                  <img
                      :src="currentIcon"
                      alt="Toggle Password Visibility"
                      class="toggle-password"
                      @click="togglePasswordVisibility"
                  />
                </div>
                <span v-if="errorMessagePassword" class="error-message">{{ errorMessagePassword }}</span>
              </div>


            </fieldset>
            <button @click="handleLogin" type="submit" class="btn-login">Login</button>

            <!-- Reset Password Link (Login) -->
            <a @click.prevent="handleResetPasswordLink" class="reset-password-link">Reset Password</a>

            <!-- Separator -->
            <div class="separator" :class="{ 'hidden': switchToSignup }">
              <span>OR</span>
            </div>

            <!-- Google Login Button (Login) -->
            <div class="google-signup-container" :class="{ 'hidden': switchToSignup }">
              <GoogleSSO buttonText="Login with Google"/>
            </div>

          </form>
        </div>

        <div :class="['form-wrapper', { 'is-active': switchToSignup }]">
          <button @click="toggleForm('signup')" type="button" class="switcher switcher-signup">
            Sign Up<span class="underline"></span>
          </button>

          <form @submit.prevent="handleSignup" class="form form-signup" novalidate>
            <fieldset>
              <legend>Please, enter your details for sign up.</legend>

              <!-- First Name Field (Sign Up) -->
              <div class="input-block">
                <label for="signup-first-name">First Name</label>
                <input id="signup-first-name" v-model="firstName" type="text">
                <span v-if="errorMessageFirstName" class="error-message">{{ errorMessageFirstName }}</span>
              </div>

              <!-- Last Name Field (Sign Up) -->
              <div class="input-block">
                <label for="signup-last-name">Last Name</label>
                <input id="signup-last-name" v-model="lastName" type="text">
                <span v-if="errorMessageLastName" class="error-message">{{ errorMessageLastName }}</span>
              </div>

              <!-- Email Field (Sign Up) -->
              <div class="input-block">
                <label for="signup-email">Email</label>
                <input id="signup-email" v-model="email" type="email">
                <span v-if="errorMessageEmail" class="error-message">{{ errorMessageEmail }}</span>
              </div>


              <!-- Password Field (Sign Up) -->
              <div class="input-block">
                <label for="signup-password">Password</label>
                <div class="password-input-wrapper">
                  <input id="signup-password" :type="showPassword ? 'text' : 'password'" v-model="password"
                  />

                  <!-- Eye icon for toggling visibility (Sign Up) -->
                  <img
                      :src="currentIcon"
                      alt="Toggle Password Visibility"
                      class="toggle-password"
                      @click="togglePasswordVisibility"
                  />
                </div>
                <span v-if="errorMessagePassword" class="error-message">{{ errorMessagePassword }}</span>
              </div>


            </fieldset>

            <button type="submit" class="btn-signup">Sign Up</button>

            <!-- Separator (Sign Up) -->
            <div class="separator" :class="{ 'hidden': !switchToSignup }">
              <span>OR</span>
            </div>

            <!-- Google Sign Up Button (Sign Up) -->
            <div class="google-signup-container" :class="{ 'hidden': !switchToSignup }">
              <GoogleSSO buttonText="Sign Up with Google"/>
            </div>

          </form>
        </div>
      </div>
    </section>
  </section>
</template>

<style>
html, body {
  margin: 0;
  padding: 0;
  width: 100%;
  height: 100%;
  overflow-x: hidden;
  overflow-y: hidden;
}
</style>

<style scoped>
@import '@/styles/common.css';

*,
*::before,
*::after {
  box-sizing: border-box;
}

.login-page {
  margin: 0;
  font-family: Roboto, -apple-system, 'Helvetica Neue', 'Segoe UI', Arial, sans-serif;
  background-color: #1A659E;
  width: 100%;
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  overflow: visible;
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

.separator {
  display: flex;
  align-items: center;
  text-align: center;
  margin: 10px 10px;
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
  color: #000000;
}

.google-signup-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  margin-top: 10px;
  gap: 10px;
}

.error-message {
  color: red;
  font-size: 0.9em;
  margin-top: 5px;
}

.password-input-wrapper {
  position: relative;
  display: flex;
  align-items: center;
}

.toggle-password {
  position: absolute;
  right: 10px;
  top: 60%;
  transform: translateY(-50%);
  cursor: pointer;
  width: 20px;
  height: 20px;
}

.hidden {
  display: none !important;
}

.forms-section {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  margin-top: -60px;
}

.forms {
  margin-top: 50px;
  display: flex;
  align-items: flex-start;
  max-height: 400px;
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
  padding: 15px;
  text-align: center;
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
  padding: 15px;
  text-align: center;
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
  margin-bottom: 10px;
}

.input-block label {
  font-size: 14px;
  color: #000000;
}

.input-block input {
  display: block;
  width: 100%;
  margin-top: 8px;
  padding-right: 10px;
  padding-left: 10px;
  font-size: 16px;
  line-height: 30px;
  color: #0d1821;
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
  line-height: 30px;
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
  margin-top: 15px;
  color: #007bff;
  text-decoration: none;
  font-size: 14px;
}

.reset-password-link:hover {
  text-decoration: underline;
}

.btn-login {
  margin-top: 0 !important;
  margin-bottom: 0 !important;
  color: #fbfdff;
  background: #db5650;
  border-radius: 25px;
  line-height: 30px;
  transform: translateX(-30%);
}

.btn-login:hover {
  background-color: #144d75;
}

.btn-signup {
  margin-top: 0 !important;
  margin-bottom: 0 !important;
  color: #fbfdff;
  background: #db5650;
  border-radius: 25px;
  line-height: 30px;
  transform: translateX(30%);
}

.btn-signup:hover {
  background-color: #144d75;
}
</style>
