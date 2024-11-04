<script setup lang="ts">
import {ref} from "vue";
import TopPanel from "@/components/TopPanel.vue";
import Sidebar from "./Sidebar.vue";
import logo from "@/assets/AllEventlyLogo.png";

const isSidebarVisible = ref(true);
const firstName = ref("Jane");
const lastName = ref("Smith");

function resetPassword() {
  // Logic for resetting password can be added here
  alert("Password reset link sent to your email.");
}

function saveChanges() {
  // Logic for saving changes can be added here
  alert("Account information saved.");
}

</script>

<template>

  <div class="page-layout account-page">
    <TopPanel :logo="logo" />
      <Sidebar :isVisible="isSidebarVisible"/>
      <!-- Main content area -->
      <main class="content-area account-content">
        <div class="content-header">
          <h1 class="main-title">Account Settings</h1>
        </div>
        <div class="form-container">
          <label for="first-name">First Name:</label>
          <input id="first-name" type="text" v-model="firstName" />

          <label for="last-name">Last Name:</label>
          <input id="last-name" type="text" v-model="lastName" />

          <button @click="resetPassword" class="action-button">Reset Password</button>
          <button @click="saveChanges" class="save-button">Save</button>
        </div>
      </main>
  </div>

</template>

<style scoped>
@import '@/styles/common.css';
.account-page {
  display: flex;
}

.form-container {
  margin-top: 20px;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.action-button, .save-button {
  margin-top: 10px;
}

input {
  padding: 5px;
  margin-bottom: 5px;
}
</style>