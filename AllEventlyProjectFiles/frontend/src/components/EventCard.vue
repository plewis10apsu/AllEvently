<script setup lang="ts">
import { defineProps } from 'vue';
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

function navigateToInvitation(eventId: string) {
  router.push({ name: 'Invitation', params: { eventId } });
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
        <img class="invitation-image" :src="event.imageUrl" alt="Event Invitation" />
        <div class="event-details">
          <div class="event-date">{{ event.date }}</div>
          <div class="event-time">{{ event.time }}</div>
        </div>
      </div>
      <div class="event-venue-container">
        <div class="event-venue">{{ event.venue }}</div>
        <a :href="event.venueLink" target="_blank" class="event-venue-link">{{ event.venueAddress }}</a>
      </div>
    </div>
    <div class="event-actions">
      <!-- Show only for hosts -->
      <button
          v-if="isHost"
          class="edit-invitation"
      >
        <i class="fas fa-edit"></i> Edit Invitation
      </button>
      <button v-if="isHost" class="guest-list" @click="navigateToGuestList">
        <i class="fas fa-users"></i> Guest List
      </button>
      <button v-if="isHost" class="print" @click="$emit('print')">
        <i class="fas fa-print"></i> Print
      </button>

      <!-- Show for guests -->
      <button v-if="isGuest" class="view-invitation" @click="navigateToInvitation(event.id)"
      >
        <i class="fas fa-eye"></i> View Invitation
      </button>

      <!-- Show for both hosts and guests -->
      <button class="event-chat" @click="navigateToChat(event.id)">
        <i class="fas fa-comments"></i> Event Chat
      </button>
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
  padding: 5px;
  background-color: #F7E1D7;
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
  justify-content: space-evenly; /* Spread buttons equally across the container */
  align-items: center; /* Vertically align buttons */
  gap: 12px; /* Add optional spacing between buttons */
  padding: 8px 0; /* Add some vertical padding if needed */
  width: 100%; /* Ensure the container spans the full width of the card */
  box-sizing: border-box; /* Include padding in width calculations */
}

.event-actions button {
  flex: 0 1 auto; /* Prevent buttons from stretching too much */
  width: auto; /* Size the button based on content */
  max-width: 150px; /* Optional: Limit the button width */
  padding: 8px 16px; /* Adjust padding for button size */
  background-color: transparent;
  color: #0D1821;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  transition: text-shadow 0.3s, color 0.3s;
  font-size: 1rem; /* Adjust font size */
  font-weight: bold;
  text-align: center; /* Center text inside buttons */
}


.event-actions :deep(.edit-invitation) {
  color: #1A659E;
}

.event-actions :deep(.edit-invitation:hover) {
  background-color: #1A659E;
  color: #fff;
}

.event-actions :deep(.view-invitation) {
  color: #1A659E;
}

.event-actions :deep(.view-invitation:hover) {
  background-color: #1A659E;
  color: #fff;
}

.event-actions :deep(.guest-list) {
  color: #ff9100;
}

.event-actions :deep(.guest-list:hover) {
  background-color: #ff9100;
  color: #fff;
}

.event-actions :deep(.print) {
  color: #FF6B35;
}

.event-actions :deep(.print:hover) {
  background-color: #FF6B35;
  color: #fff;
}

.event-actions :deep(.event-chat) {
  color: #E63946;
}

.event-actions :deep(.event-chat:hover) {
  background-color: #E63946;
  color: #fff;
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

}

/* Adjustments for smaller screens */
@media (max-width: 720px) {
  .event-main-content {
    display: flex;
    flex-wrap: wrap; /* Allow wrapping for better responsiveness */
    justify-content: space-between;
    align-items: center; /* Center items horizontally */
    gap: 10px;
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
    font-size: 1rem;
    padding: 6px 12px; /* Reduce button size */
  }
}

/* Adjustments for very small screens */
@media (max-width: 480px) {
  .event-header {
    display: flex;
    flex-direction: row; /* Keep them in a row */
    justify-content: space-between; /* Add spacing between title and host */
    align-items: center; /* Vertically align the content */
    flex-wrap: nowrap; /* Prevent wrapping */
    gap: 10px; /* Add some space between the elements */
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
