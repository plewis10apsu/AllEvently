<script setup lang="ts">

import {ref} from "vue";

const isVisible = ref(true);

defineProps<{
  eventDetails: {
    name: string;
    date: string;
    time: string;
  };
}>();

</script>

<template>
  <aside :class="['event-sidebar', { 'sidebar-visible': isVisible }]">
    <nav class="preview-container">
      <div class="event-details-section">
        <h3 class="event-name-preview">Event Name</h3>
        <p class="event-details-preview">Sat, Sep 28, 2024 10:00 AM CDT</p>
      </div>
      <div class="preview-box">Preview</div>
    </nav>
  </aside>
</template>

<style scoped>

.event-sidebar {
  margin-top: 90px;
  flex-shrink: 0;
  min-width: 200px;
  box-sizing: border-box;
  background-color: #083D77; /* Same background as the main sidebar */
  display: flex;
  flex-direction: column;
  align-items: center;
  box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
  transform: translateX(-100%);
  transition: transform 0.3s ease;
}

.sidebar-visible {
  transform: translateX(0);
}

.preview-container {
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 20px;
  padding: 20px 0;
}

.event-name-preview {
  font-size: 1.4rem;
  font-weight: bold;
}

.event-details-preview {
  font-size: 1.1rem;
  margin-top: 5px;
  color: #c7d1da;
}

.preview-box {
  width: 100%;
  max-height: 150px;
  aspect-ratio: 1;
  background-color: #add8e6;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 8px;
  overflow: hidden;
}

/* Adjustments for small screens */
@media (max-width: 809px) {
  .event-sidebar {
    min-width: 80px;
    max-width: 80px;
  }

  .event-name-preview,
  .event-details-preview {
    display: none; /* Hide text content on smaller screens */
  }

  .preview-box {
    max-height: 80px;
  }
}
</style>
