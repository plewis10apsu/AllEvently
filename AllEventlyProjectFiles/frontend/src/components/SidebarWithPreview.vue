<script setup lang="ts">

</script>

<template>
  <aside class="sidebar">
    <h3>Event Name</h3>
    <p>Sat, Sep 28, 2024 10:00 AM CDT</p>
    <div class="preview-box">Preview</div>
  </aside>
</template>

<style scoped>
.sidebar {
  margin-top: 90px;
  width: 250px; /* Default width for larger screens */
  max-width: 100%; /* Ensures it doesn't exceed the viewport width */
  background-color: #f1f1f1;
  padding: 20px;
  border-radius: 8px;
  box-sizing: border-box; /* Include padding in the width calculation */
  overflow: hidden; /* Prevent content from overflowing */
}

.preview-box {
  width: 100%; /* Always adjust to the sidebar's width */
  max-height: 150px; /* Set a max height to prevent it from growing too tall */
  height: auto; /* Allow height to adjust automatically */
  aspect-ratio: 1; /* Ensures a square aspect ratio */
  background-color: #add8e6;
  display: flex;
  align-items: center;
  justify-content: center;
  box-sizing: border-box; /* Include padding in calculations */
}

</style>
