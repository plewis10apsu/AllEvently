<script setup lang="ts">
import { ref, computed } from 'vue';
import EventCard from './EventCard.vue';
import logo from '@/assets/AllEventlyLogo.png';

const activeTab = ref('attending');
const searchQuery = ref('');
const filterOption = ref('Upcoming Events');
const isSidebarVisible = ref(window.innerWidth > 768);

window.addEventListener('resize', () => {
  isSidebarVisible.value = window.innerWidth > 768;
});

isSidebarVisible.value = window.innerWidth > 768;

const events = ref([
  { id: 1, title: 'Event 1', date: '2024-10-19', time: '10:00 AM', location: 'Venue A', host: 'John' },
  { id: 2, title: 'Event 2', date: '2024-10-20', time: '11:00 AM', location: 'Venue B', host: 'Alice' },
  { id: 3, title: 'Event 3', date: '2024-10-21', time: '12:00 PM', location: 'Venue C', host: 'Bob' }
]);

const filteredEvents = computed(() => {
  // Logic to filter events based on activeTab, searchQuery, and filterOption
  return events.value;
});

const viewInvitation = (_event: any) => {
  // Handle viewing an invitation
};

const editInvitation = (_event: any) => {
  // Handle editing an invitation
};
</script>

<template>
  <div class="events-page">
    <!-- Top panel with logo -->
    <header class="top-panel">
      <div class="logo">
        <img :src="logo" alt="AllEvently Logo" class="logo-img" />
      </div>
    </header>

    <!-- Sidebar navigation panel -->
    <aside v-if="isSidebarVisible" class="sidebar">
      <!-- Place your navigation icons here -->
    </aside>

    <!-- Main content area -->
    <main class="events-content" >
      <div class="content-header">
        <h1 class="main-title">Events</h1>
        <div class="tabs">
          <button :class="{ active: activeTab === 'attending' }" @click="activeTab = 'attending'">Attending</button>
          <button :class="{ active: activeTab === 'hosting' }" @click="activeTab = 'hosting'">Hosting</button>
        </div>

        <div class="filters">
          <input type="text" placeholder="Search Events..." v-model="searchQuery" />
          <select v-model="filterOption">
            <option>Upcoming Events</option>
          </select>
        </div>
      </div>

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

<style scoped>

html, body {
  height: 100%;
  margin: 0;
  padding: 0;
  background-color: #f0f3fa; /* Set the default background color */
}


.main-title {
  font-size: 5rem; /* Larger for H1 */
  font-weight: bold;
  color: #0D1821;
  margin-bottom: 20px; /* Space below title */
}

.events-page {
  display: flex;
  flex-direction: row;
  min-height: 100vh; /* Ensures it extends to full viewport height */
  width: 100%;
  background-color: #f0f3fa; /* Set background to match content */
}

.top-panel {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 90px;
  background-color: #f0f3fa;
  color: white;
  display: flex;
  align-items: center; /* Center vertically */
  justify-content: flex-start; /* Align content to the left */
  padding: 0 20px;
  z-index: 10;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.logo {
  display: flex;
  align-items: center;
}

.logo-img {
  height: 90px;
  width: auto;
  margin-right: 0;
  margin-top: 0; /* Ensure no top margin */
}

.sidebar {
  flex-shrink: 0;
  width: 15%;
  min-width: 200px;
  background-color: #0d1821;
  padding: 20px;
  display: flex;
  flex-direction: column;
  align-items: center;
  box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
}

.events-content {
  margin-top: 90px; /* Space for the top panel */
  padding: 20px;
  flex-grow: 1;
  background-color: #f0f3fa;
  transition: margin-left 0.3s; /* Smooth transition for sidebar toggle */
  min-height: calc(100vh - 90px); /* Smooth transition for sidebar toggle */
}

.event-listings {
  display: flex;
  flex-direction: column;
  gap: 15px;
  width: 100%; /* Make listings take full width */
}

.tabs {
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
}

.tabs button {
  padding: 15px 30px; /* Increase padding for a larger button */
  font-size: 1.2rem; /* Increase font size */
  font-weight: bold;
  background-color: #1A659E;
  color: white;
  border: none;
  cursor: pointer;
  border-radius: 5px; /* Optional: Rounded corners for a modern look */
}

.tabs button.active {
  background-color: #0D1821;
  color: white;
  font-size: 1.2rem; /* Ensure font size is consistent when active */
}

.filters input[type="text"],
.filters select {
  font-size: 1.1rem; /* Increase font size for readability */
  padding: 10px 15px; /* Increase padding for a larger input field */
  border-radius: 4px;
  border: 1px solid #ccc;
}

.filters {
  display: flex;
  gap: 20px; /* Increase space between filter components */
  align-items: center;
  margin-bottom: 20px;
}

/* Dark Mode */
@media (prefers-color-scheme: dark) {
  body {
    background-color: #14213D; /* Dark blue for background */
  }
}

@media (max-width: 768px) {
  .events-content {
    margin-left: 0;
    min-width: 100%;
  }

  .sidebar {
    display: none; /* Hide the sidebar when the screen is too small */
  }
}


</style>
