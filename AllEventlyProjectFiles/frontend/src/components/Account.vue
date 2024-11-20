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

.main-title {
  margin-top: 25px;
  font-size: 4rem; /* Adjust to your desired size */
  font-weight: bold; /* Optional: Keep it bold or adjust */
  margin-bottom: 10px; /* Optional: Add spacing if needed */
}

.content-area {
  margin-left: 0; /* Ensure content aligns with the sidebar */
  padding: 20px; /* Add consistent padding for spacing */
  flex-grow: 1;
}

.form-container {
  margin-top: 20px;
  display: flex;
  flex-direction: column;
  gap: 10px;
  max-width: 400px; /* Set a maximum width for the form */
}

label {
  font-weight: bold;
}

input {
  padding: 5px;
  margin-bottom: 5px;
  border: 1px solid #ccc;
  border-radius: 4px;
  width: 100%;
  box-sizing: border-box;
}

.action-button,
.save-button {
  margin-top: 10px;
  padding: 10px 20px;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  background-color: #FAC55A; /* Yellow from the palette */
  color: #0D1821; /* Dark color from the palette for contrast */
  font-size: 1em;
  width: auto; /* Allow buttons to size naturally */
  box-sizing: border-box;
  transition: background-color 0.3s ease; /* Smooth hover effect */
}

.action-button:hover {
  color: #fff;
  background-color: #1A659E; /* Orange from the palette for hover effect */
}

.save-button:hover {
  color: #fff;
  background-color: #1A659E; /* Red from the palette for hover effect */
}


</style>