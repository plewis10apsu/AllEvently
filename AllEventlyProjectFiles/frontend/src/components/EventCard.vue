<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue';

defineProps<{
  event?: Record<string, any>;
}>();

const isSmallScreen = ref(window.innerWidth < 768);

const updateScreenSize = () => {
  isSmallScreen.value = window.innerWidth < 768;
};

onMounted(() => {
  window.addEventListener('resize', updateScreenSize);
});

onUnmounted(() => {
  window.removeEventListener('resize', updateScreenSize);
});
</script> 
<template> 
    <div class="event-card" v-if="event"> 
        <div class="event-header"> 
            <div class="event-title-section"> 
                <h2 class="event-title">{{ event.title }}</h2>
              <span class="event-type">{{ event.type === 'public' ? '(Public event)' : '(Private event)' }}</span>
            </div>             
            <div class="event-host">Hosted By: {{ event.host }}</div>             
        </div>         
        <div class="event-main-content">
          <div class="event-invitation-section">
          <img class="invitation-image" :src="event.imageUrl" alt="Event Invitation"/>
            <div class="event-details"> 
                <div class="event-date">{{ event.date }}</div>                 
                <div class="event-time">{{ event.time }}</div>                 
            </div>
            </div>
            <!-- Add the venue container on the same row -->             
            <div class="event-venue-container"> 
                <div class="event-venue">{{ event.venue }}</div>
              <a :href="event.venueLink" target="_blank" class="event-venue-link">{{ event.venueAddress }}</a>
            </div>             
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
  display: flex;
  flex-direction: column;
  background-color: #F7E1D7;
  padding: 20px;
  margin-bottom: 10px;
  border-radius: 5px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  position: relative;
}

.event-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 10px;
}

.event-title-section {
  display: flex;
  align-items: baseline;
  gap: 5px;
}

.event-title {
  font-size: 1.5rem;
  font-weight: bold;
  color: #0D1821;
}

.event-type {
  font-size: 1rem;
  color: #666;
}

.event-host {
  font-size: 1rem;
  color: #333;
  text-align: right;
}

.event-main-content {
  display: flex;
  align-items: center;
  gap: 20px; /* Retain the gap between the sections */
}

.event-invitation-section {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 10px;
}

.invitation-image {
  width: 100px; /* Adjust size as needed */
  height: auto;
  border-radius: 5px;
}

.event-details {
  display: flex;
  align-items: center;
  flex-direction: column;
  justify-content: center;
  gap: 5px;
}

.event-date,
.event-time {
  text-align: left; /* Ensures text is aligned to the left */
  font-size: 1rem;
  color: #333;
}

.event-venue-container {
  position: absolute; /* Position it within the parent */
  left: 50%; /* Moves it to the center */
  transform: translateX(-50%); /* Centers the element */
  display: flex;
  align-items: center;
  flex-direction: column;
  justify-content: center;
}

.event-venue {
  color: #0D1821;
  font-size: 1.2rem;
  font-weight: bold;
}

.event-venue-link {
  color: #007bff;
  font-size: 1rem;
  text-decoration: none;
}

.event-venue-link:hover {
  text-decoration: underline;
}

.event-actions {
  display: flex;
  justify-content: flex-start;
  gap: 10px;
}

.event-actions button {
  background-color: #1A659E;
  color: white;
  border: none;
  padding: 8px 16px;
  border-radius: 4px;
  cursor: pointer;
}

.event-actions button:hover {
  background-color: #083D77;
}

/* Dark Mode */
@media (prefers-color-scheme: dark) {
  .event-card {
    background-color: #2d2d2d;
    color: #ddd;
  }
  .event-title {
    color: #f5f5f5;
  }
  .event-host, .event-venue, .event-details {
    color: #bbb;
  }
  .event-actions button {
    background-color: #083D77;
  }
  .event-actions button:hover {
    background-color: #083D77;
  }
}

</style>
