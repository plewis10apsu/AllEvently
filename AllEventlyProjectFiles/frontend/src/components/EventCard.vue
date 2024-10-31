<script setup lang="ts">
defineProps<{
  event?: Record<string, any>;
}>();
</script>

<template>
  <div class="event-card" v-if="event">
    <h2 class="event-title"> {{ event.title }} <span>{{ event.type }}</span></h2>
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

<style scoped>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

.event-card {
  font-size: 1.1rem;
  background-color: #f7e1d7;
  padding: 20px;
  border-radius: 5px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.event-title {
  font-size: 2.2rem;
  font-weight: 600;
  color: #0D1821;
  margin-bottom: 10px;
}

.event-details {
  font-size: 1.2rem;
  color: #333333;
  margin-bottom: 10px;
}

.event-actions button {
  font-size: 1.1rem;
  margin-right: 10px;
  background-color: #1A659E;
  color: white;
  font-weight: bold;
  border: none;
  padding: 8px 16px;
  border-radius: 4px;
  cursor: pointer;
}

/* Dark Mode */
@media (prefers-color-scheme: dark) {
  .event-title {
    color: #F7E1D7;
  }

  .event-card {
    background-color: #2b3a51; /* Dark mode background for card */
    color: #e0e0e0; /* Light text for readability */
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.3); /* Subtle shadow for depth */
  }

  .event-details {
    color: #cccccc; /* Slightly lighter color for detail text */
  }

  .event-actions button {
    background-color: #083d77; /* Darker background for button in dark mode */
    color: #ffffff; /* Lighter text color for button text */
  }

  .event-actions button:hover {
    background-color: #1a659e; /* Slightly lighter shade on hover */
  }
}

</style>
