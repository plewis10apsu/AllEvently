<script setup lang="ts">
import {ref} from "vue";
import TopPanel from "@/components/TopPanel.vue";
import Sidebar from "./Sidebar.vue";
import logo from "@/assets/AllEventlyLogo.png";
import SearchBar from "@/components/SearchBar.vue";
import PublicEventCard from './PublicEventCard.vue';

const isSidebarVisible = ref(true);
</script>

<template>
  <div class="page-layout public-page">
    <TopPanel :logo="logo" />
    <Sidebar :isVisible="isSidebarVisible"/>

    <!-- Main content area -->
    <main class="content-area public-content">
      <div class="content-header">
        <h1 class="main-title">Public Events</h1>
        <div class="search-filter-container">
          <SearchBar />
          <!-- Add other filter buttons here -->
        </div>
      </div>

      <!-- Events grid -->
      <div class="events-grid">
        <PublicEventCard title="Ghouls, Brews & Bouquets" date="Sat, Oct 12 6:00 PM CDT" venue="The Fallen Brewery" location="Jordan Farms" attendees="25" />
        <PublicEventCard title="Horror-Fest" date="Sat, Oct 12 10:00 AM CDT" venue="Quality Inn Exit 4" location="Our Cons" attendees="1.7k" />
        <PublicEventCard title="Halloween Market" date="Sun, Oct 13 11:00 AM CDT" venue="Wilma Rudolph Event Center" location="Velvet Ghost Boutique" attendees="46" />
        <PublicEventCard title="Scary Sugar Cookie Decorating Class!" date="Sat, Oct 19 11:00 AM CDT" venue="Mugsy's Coffee Co" location="Cake My Day by Jayme" attendees="45" />
        <!-- Add more EventCard components -->
      </div>
    </main>
  </div>
</template>

<style scoped>
@import '@/styles/common.css';

.search-filter-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.events-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 20px;
  margin-top: 20px;
}
</style>