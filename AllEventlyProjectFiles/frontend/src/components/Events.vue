<template>
    <div class="events-page">
<aside class="sidebar">
<!-- Icons for navigation -->
<div class="icon-container">
    <!-- Add your icons here -->
    </div>
    </aside>

    <main class="events-content">
    <!-- Title and filter options -->
    <header>
        <h1>Events</h1>
    <div class="tabs">
    <button :class="{ active: activeTab === 'attending' }" @click="activeTab = 'attending'">Attending</button>
    <button :class="{ active: activeTab === 'hosting' }" @click="activeTab = 'hosting'">Hosting</button>
    </div>

    <!-- Search Bar and Filter Options -->
    <div class="filters">
<input type="text" placeholder="Search Events..." v-model="searchQuery" />
<select v-model="filterOption">
    <option>Upcoming Events</option>
<!-- Add more filter options if needed -->
</select>
</div>
</header>

<!-- Event Listings -->
<section class="event-listings">
    <EventCard
        v-for="event in filteredEvents"
  :key="event.id"
:event="event"
@viewInvitation="viewInvitation(event)"
@editInvitation="editInvitation(event)"
    />
    </section>
    </main>
    </div>
    </template>

    <script setup lang="ts">
import { ref, computed } from 'vue';
import EventCard from './EventCard.vue';

const activeTab = ref('attending');
const searchQuery = ref('');
const filterOption = ref('Upcoming Events');
const events = ref([
  { id: 1, title: 'Event 1', date: '2024-10-19', time: '10:00 AM', location: 'Venue A', host: 'John' },
  { id: 2, title: 'Event 2', date: '2024-10-20', time: '11:00 AM', location: 'Venue B', host: 'Alice' },
  { id: 3, title: 'Event 3', date: '2024-10-21', time: '12:00 PM', location: 'Venue C', host: 'Bob' }
]);


const filteredEvents = computed(() => {
  // Logic to filter events based on activeTab, searchQuery, and filterOption
  return events.value; // Return all events
});

const viewInvitation = () => { //event parameter
  // Handle viewing an invitation
};

const editInvitation = () => { //event parameter
  // Handle editing an invitation
};
</script>

<style scoped>
/* Basic layout and styles */
.events-page {
  display: flex;
}

.sidebar {
  width: 15%;
  background-color: #f3f3f3;
}

.events-content {
  width: 85%;
  padding: 20px;
}

.tabs button {
  /* Style your tabs */
}

.filters {
  display: flex;
  justify-content: space-between;
  margin-bottom: 20px;
}

.event-listings {
  display: flex;
  flex-direction: column;
  gap: 15px;
}
</style>
