<script setup lang="ts">
import { ref } from 'vue';
import logo from "@/assets/AllEventlyLogo.png";
import TopPanelWithBack from "@/components/TopPanelWithBack.vue";
import SidebarWithPreview from "@/components/SidebarWithPreview.vue";

// Reactive state using `ref` or `reactive`
const isSingleEvent = ref(true);
const eventDate = ref('');
const startTime = ref('');
const endTime = ref('');
const timeZone = ref('CDT');
const timeZones = ['CDT', 'EST', 'PST'];
const requestChildCount = ref(false);
const limitGuests = ref(false);
const allowRSVP = ref(false);
const hostFirstName = ref('');
const hostLastName = ref('');
const notifyRSVPs = ref(false);

// Methods defined as regular functions
function toggleEventType(isSingle: boolean) {
  isSingleEvent.value = isSingle;
}
</script>

<template>
  <div class="event-creation">
    <TopPanelWithBack :logo="logo"/>
    <div class="event-sidebar">
      <SidebarWithPreview />
    </div>

    <div class="event-main">
      <header class="event-header">
        <h1>ALL EVENTLY</h1>
        <p>EVENT MANAGEMENT</p>
      </header>

      <section class="event-details">
        <h2>Event Name</h2>
        <input type="text" placeholder="Enter event name" required/>

        <h2>Note for Guests</h2>
        <textarea placeholder="Enter a note for guests"></textarea>
      </section>

      <section class="event-date-location">
        <h2>Date and Location</h2>
        <div class="event-type">
          <button :class="{ 'selected': isSingleEvent }" @click="toggleEventType(true)">Single Event</button>
          <button :class="{ 'selected': !isSingleEvent }" @click="toggleEventType(false)">Recurring Event</button>
        </div>

        <div class="event-date-time">
          <label>Date and time</label>
          <input type="date" v-model="eventDate" required/>
          <input type="time" v-model="startTime" required/>
          <input type="time" v-model="endTime" required/>

          <label>Event Time Zone</label>
          <select v-model="timeZone">
            <option v-for="tz in timeZones" :key="tz" :value="tz">{{ tz }}</option>
          </select>
        </div>

        <div class="event-location">
          <label>Event Address</label>
          <input type="text" placeholder="Enter address" required/>

          <label>Event Venue Name</label>
          <input type="text" placeholder="Enter venue name"/>
        </div>
      </section>

      <section class="guest-settings">
        <h2>Guest Settings</h2>
        <div class="toggle-setting">
          <label>Request Child Count</label>
          <input type="checkbox" v-model="requestChildCount"/>
        </div>
        <div class="toggle-setting">
          <label>Limit Additional Guests</label>
          <input type="checkbox" v-model="limitGuests"/>
        </div>
        <div class="toggle-setting">
          <label>Allow Guests to RSVP</label>
          <input type="checkbox" v-model="allowRSVP"/>
        </div>
      </section>

      <section class="host-settings">
        <h2>Host Settings</h2>
        <label>Hosted By</label>
        <input type="text" placeholder="Insert Host First Name" v-model="hostFirstName"/>
        <input type="text" placeholder="Insert Host Last Name" v-model="hostLastName"/>
        <div class="toggle-setting">
          <label>Get Notified of RSVPs</label>
          <input type="checkbox" v-model="notifyRSVPs"/>
        </div>
      </section>

      <section class="event-links">
        <h2>Links</h2>
        <button class="add-link-button" v-for="n in 4" :key="n">Add a Link to Your Invite</button>
      </section>
    </div>
  </div>
</template>

<style scoped>
.event-creation {
  display: flex;
  flex-direction: row;
}

.event-sidebar {
  width: 20%;
  padding: 10px;
  background-color: #f0f0f0;
}

.event-preview {
  border: 1px solid #ccc;
  padding: 10px;
}

.event-main {
  width: 80%;
  padding: 20px;
}

.event-header {
  text-align: center;
}

.event-details, .event-date-location, .guest-settings, .host-settings, .event-links {
  margin-bottom: 20px;
}

.event-type button {
  margin-right: 10px;
  padding: 5px 10px;
}

.event-type .selected {
  background-color: #b0c4de;
}

.toggle-setting {
  display: flex;
  justify-content: space-between;
  margin-bottom: 10px;
}

.add-link-button {
  display: block;
  margin-top: 10px;
  padding: 10px;
  background-color: #e7e7e7;
  border: 1px solid #ccc;
}
</style>
