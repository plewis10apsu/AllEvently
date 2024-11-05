<script setup lang="ts">
import { useRouter } from 'vue-router';

defineProps<{
  event?: Record<string, any>;
  isHost?: boolean;
  isGuest?: boolean;
}>();

const router = useRouter();

function navigateToChat(eventId: string) {
  router.push({ name: 'Chat', params: { eventId } });
}

function navigateToGuestList() {
  router.push({ name: 'GuestList' });
}

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
          <button v-if="event.isGuest" @click="$emit('viewInvitation')">View Invitation</button>
          <button v-if="event.isHost" @click="$emit('editInvitation')">Edit Invitation</button>
          <button v-if="event.isHost" @click="navigateToGuestList">Guest List</button>
          <button v-if="event.isHost" @click="$emit('print')">Print</button>
          <button v-if="event.isGuest || event.isHost" @click="navigateToChat(event.id)">Event Chat</button>
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
  font-size: 1.5rem;
  font-weight: bold;
  color: #333;
  text-align: right;
}

.event-main-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 20px; /* Retain the gap between the sections */
  position: relative;
  flex-wrap: wrap;
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
  justify-content: center;
  align-items: center;
  margin-top: 5px;
  gap: 10px;
  width: 100%;
}

.event-actions button {
  flex: 1;
  background-color: transparent;
  color: #0D1821;
  border: none;
  padding: 8px 16px;
  border-radius: 4px;
  cursor: pointer;
  transition: text-shadow 0.3s, color 0.3s; /* Smooth transition */
}

.event-actions button:hover {
  text-shadow: 0 0 8px rgba(13, 24, 33, 0.7); /* Glow effect */
  color: #0D1821;
}

/* Dark Mode */
@media (prefers-color-scheme: dark) {
  .event-card {
    background-color: #2d2d2d;
    color: #ddd;
  }
  .event-type {
    font-size: 1rem;
    color: #bbb;
  }
  .event-title {
    color: #f5f5f5 !important;
  }
  .event-date,
  .event-time {
    text-align: left;
    font-size: 1rem;
    color: #f5f5f5;
  }
  .event-host, .event-venue, .event-details {
    color: #bbb !important;
  }
  .event-actions button {
    background-color: transparent;
    color: #f5f5f5;
    border: 2px solid #f5f5f5;
  }
  .event-actions button:hover {
    text-shadow: 0 0 20px rgba(255, 0, 0, 1), 0 0 40px rgba(255, 0, 0, 0.7);
    color: #f5f5f5;
    border-color: #EDAFB8;
  }
}

/* Adjustments for smaller screens */
@media (max-width: 720px) {
  .event-main-content {
    flex-direction: column; /* Stack items vertically */
    align-items: center; /* Center items horizontally */
    gap: 15px;
  }

  .event-invitation-section {
    flex-direction: row;
    align-items: center; /* Center items */
  }

  .invitation-image {
    width: 80px; /* Reduce image size */
  }

  .event-details {
    align-items: center; /* Center the date and time */
  }

  .event-venue-container {
    position: static; /* Removes absolute positioning */
    transform: none; /* Resets transform */
    width: 100%; /* Full width to adapt to the screen */
    text-align: center; /* Center text */
  }

  .event-venue {
    font-size: 1rem; /* Adjust font size */
  }

  .event-venue-link {
    font-size: 0.9rem; /* Adjust font size */
  }

  .event-actions button {
    padding: 6px 12px; /* Reduce button size */
  }
}

/* Adjustments for very small screens */
@media (max-width: 480px) {
  .event-header {
    flex-direction: column;
    align-items: center;
  }

  .event-title {
    font-size: 1rem;
    font-weight: bold;
    color: #0D1821;
  }

  .event-type {
    font-size: 0;
    color: #666;
  }

  .event-host {
    font-size: 1rem;
    font-weight: bold;
    color: #333;
    text-align: right;
  }
  .invitation-image {
    width: 60px; /* Further reduce image size */
  }



  .event-date,
  .event-time {
    font-size: 0.9rem; /* Adjust text size */
  }

  .event-venue {
    font-size: 0.9rem;
  }

  .event-venue-link {
    font-size: 0.8rem;
  }
}

</style>
