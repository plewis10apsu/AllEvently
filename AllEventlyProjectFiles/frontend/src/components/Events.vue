<script setup lang="ts">
import { ref, computed } from 'vue';
import EventCard from './EventCard.vue';
import Sidebar from "./Sidebar.vue";
import logo from '@/assets/AllEventlyLogo.png';
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';
import { faBars, faTimes } from '@fortawesome/free-solid-svg-icons';

const activeTab = ref('attending');
const searchQuery = ref('');
const filterOption = ref('Upcoming Events');
const isSidebarVisible = ref(true);

window.addEventListener('resize', () => {
  // Only close the sidebar if the screen is resized to a small width and it is currently visible
  if (window.innerWidth <= 768 && isSidebarVisible.value) {
    isSidebarVisible.value = false;
  }
  // Do nothing when resizing to larger widths if the sidebar is closed by the user
});

const toggleSidebar = () => {
  // Toggle the sidebar visibility regardless of screen size
  isSidebarVisible.value = !isSidebarVisible.value;
};


const events = ref([
  { id: 1, title: 'Lisa\'s Baby Shower', type: 'public', venue: 'Wilma Rudolph Event Center',
    date: 'Sep 28, 2024', time: '3:00 PM CDT',  host: 'John', imageUrl: 'https://img.freepik.com/premium-photo/chameleon-with-red-spot-its-head_924629-217761.jpg', venueLink: 'www.google.com',
  venueAddress: '8 Champion\'s Wy, Clarksville, TN 37040' },
  { id: 2, title: 'Jonie\'s Birthday', type: 'public', venue: 'Smith-Trahern Mansion',
    date: 'Oct 5, 2024', time: '6:00 PM CDT',  host: 'Alice' },
  { id: 3, title: 'Carson\'s Bounce Party', type: 'public', venue: 'Sky Zone',
    date: '2024-10-21', time: '12:00 PM',  host: 'Bob' }
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
        <!-- Top panel with toggle button and logo -->         
        <header class="top-panel"> 
            <button class="toggle-sidebar" @click="toggleSidebar"> 
                <FontAwesomeIcon :icon="isSidebarVisible ? faTimes : faBars"/> 
            </button>             
            <div class="logo"> 
                <img :src="logo" alt="AllEvently Logo" class="logo-img"/> 
            </div>             
        </header>         
        <!-- Sidebar navigation panel -->         
        <Sidebar :isVisible="isSidebarVisible"/> 
        <!-- Main content area -->         
        <main class="events-content" :style="{ marginLeft: isSidebarVisible ? '0' : '-200px' }"> 
            <div class="content-header"> 
                <h1 class="main-title">Events</h1> 
                <div class="tabs">                      
                    <button :class="{ active: activeTab === 'attending' }" @click="activeTab = 'attending'">Attending</button>
                    <button :class="{ active: activeTab === 'hosting' }" @click="activeTab = 'hosting'">Hosting</button>                     
                </div>                 
                <div class="filters"> 
                    <input type="text" placeholder="Search Events..." v-model="searchQuery"/> 
                    <select v-model="filterOption"> 
                        <option>Upcoming Events</option>                         
                    </select>                     
                </div>                 
            </div>             
            <section class="event-listings"> 
                <EventCard v-for="event in filteredEvents" :key="event.id" :event="event" @viewInvitation="viewInvitation(event)" @editInvitation="editInvitation(event)"/> 
            </section>             
        </main>         
    </div>     
</template> 
<style scoped>

.main-title {
  font-size: 5rem;
  font-weight: bold;
  color: #0D1821;
  margin-bottom: 20px;
}

.events-page {
  display: flex;
  flex-direction: row;
  width: 100%;
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

.top-panel {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 90px;
  background-color: #f0f3fa;
  color: white;
  display: flex;
  align-items: center;
  justify-content: flex-start;
  padding: 0 20px;
  z-index: 10;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.toggle-sidebar {
  background: none;
  border: none;
  cursor: pointer;
  font-size: 1.5rem;
  color: #0D1821;
  margin-left: 0;
}

.logo {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  margin: 20px 0;
}

.logo-img {
  height: 120px;
  width: auto;
  margin-top: -20px;
}

.events-content {
  margin-left: 0;
  margin-top: 60px;
  padding: 20px;
  flex-grow: 1;
  background-color: #f0f3fa;
  transition: margin-left 0.3s, width 0.3s;
  min-height: calc(100vh - 90px);
}

.event-listings {
  display: flex;
  flex-direction: column;
  gap: 15px;
  width: 100%;
}

.tabs {
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
}

.tabs button {
  padding: 15px 30px; /* Height(px), Width(px) */
  font-size: 1.2rem;
  font-weight: bold;
  background-color: #FF6B35;
  color: white;
  border: none;
  cursor: pointer;
  border-radius: 5px;
}

.tabs button.active {
  background-color: #E63946;
  color: white;
  font-size: 1.2rem;
  box-shadow: 0 0 10px 1px rgba(230, 57, 70, 0.6);
}

.filters input[type="text"],
.filters select {
  font-size: 1.1rem;
  padding: 10px 15px; /* {Search Bar} Height(px), Width(px) */
  border-radius: 4px;
  border: 1px solid #ccc;
}

.filters {
  display: flex;
  gap: 20px;
  align-items: center;
  margin-bottom: 20px;
}

@media (max-width: 768px) {
  .events-content {
    width: 100%;
    margin-left: 0;
  }
}

</style>
