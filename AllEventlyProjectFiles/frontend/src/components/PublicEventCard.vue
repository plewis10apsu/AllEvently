<script setup lang="ts">
defineProps({
  title: String,
  date: String,
  time: String,
  venue: String,
  venueLink: String,
  location: String,
  attendees: [String, Number],
  imageUrl: String,
});
</script>

<template>
  <div class="public-event-card">
    <img :src="imageUrl" alt="Event Image" class="event-image" />
    <div class="event-content">
      <h3 class="event-title">{{ title }}</h3>
      <div class="event-details">
        <p class="event-date">{{ date }} at {{ time }}</p>
        <a :href="venueLink" target="_blank" class="event-venue">{{ venue }}</a>
        <p class="event-location">{{ location }}</p>
        <p class="event-attendees">{{ attendees }} Attending</p>
      </div>
    </div>
  </div>
</template>

<style scoped>
.public-event-card {
  display: flex;
  flex-direction: column;
  gap: 15px;
  padding: 20px;
  border: 1px solid #ddd;
  border-radius: 8px;
  background-color: #ffffff;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s, box-shadow 0.3s;
}

.public-event-card:hover {
  transform: scale(1.02);
  box-shadow: 0 8px 12px rgba(0, 0, 0, 0.2);
}

.event-image {
  width: 100%;
  height: auto;
  border-radius: 8px;
  object-fit: cover;
}

.event-content {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.event-title {
  font-size: 1.5rem;
  font-weight: bold;
  margin: 0;
  color: #333;
}

.event-details {
  display: flex;
  flex-direction: column;
  gap: 5px;
}

.event-details p,
.event-details a {
  font-size: 1rem;
  color: #555;
  margin: 0;
}

.event-venue {
  font-weight: bold;
  text-decoration: none;
  color: #007bff;
  transition: color 0.2s;
}

.event-venue:hover {
  color: #0056b3;
}

.event-attendees {
  margin-top: 10px;
  font-weight: bold;
  color: #333;
}
</style>
