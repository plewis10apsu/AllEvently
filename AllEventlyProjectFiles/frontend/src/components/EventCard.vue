<template>
  <div class="event-card">
    <h2>{{ event.title }} <span>({{ event.type }})</span></h2>
    <div class="event-details">
      <div>{{ event.date }} at {{ event.time }}</div>
      <div>{{ event.location }}</div>
      <div>Hosted by: {{ event.host }}</div>
    </div>
    <div class="event-actions">
      <button @click="$emit('viewInvitation')">View Invitation</button>
      <button v-if="event.host === 'You'" @click="$emit('editInvitation')">Edit Invitation</button>
    </div>
  </div>
</template>

<script setup lang="ts">
defineProps({
  event: Object
});
</script>

<style scoped>
.event-card {
  background-color: #fdf5c4; /* Use your preferred colors */
  padding: 20px;
  border-radius: 5px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.event-details {
  margin-bottom: 10px;
}

.event-actions button {
  margin-right: 10px;
  background-color: #f0f0f0;
  border: none;
  cursor: pointer;
}
</style>
