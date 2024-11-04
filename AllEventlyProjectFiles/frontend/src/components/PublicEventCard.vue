<template>
  <div class="public-event-card">
    <h3 class="event-title">{{ title }}</h3>
    <div class="event-details">
      <p class="event-date">{{ date }}</p>
      <p class="event-venue">{{ venue }}</p>
      <p class="event-location">{{ location }}</p>
      <p class="event-attendees">{{ attendees }} Attending Public Event</p>
    </div>
  </div>
</template>

<script setup lang="ts">
defineProps({
  title: String,
  date: String,
  venue: String,
  location: String,
  attendees: [String, Number],
});
</script>

<style scoped>
.public-event-card {
  padding: 15px;
  border: 1px solid #ddd;
  border-radius: 8px;
  background-color: #fdfdfd;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.event-title {
  font-size: 1.25em;
  margin-bottom: 10px;
  font-weight: bold;
}

.event-details p {
  margin: 5px 0;
  color: #555;
}

.event-attendees {
  font-weight: bold;
  margin-top: 10px;
  color: #333;
}
</style>
