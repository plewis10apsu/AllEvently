<script setup lang="ts">
import { ref } from 'vue';
import logo from "@/assets/AllEventlyLogo.png";
import TopPanelWithBack from "@/components/TopPanelWithBack.vue";
import SidebarWithPreview from "@/components/SidebarWithPreview.vue";

// Reactive state using `ref` or `reactive`
const eventName = ref('');
const eventNameValid = ref(true);
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

function toggleEventType(isSingle: boolean) {
  isSingleEvent.value = isSingle;
}

function validateEventName() {
  eventNameValid.value = eventName.value.trim().length > 0;
}
</script>

<template>
  <div class="event-creation">
    <TopPanelWithBack :logo="logo" />

    <div class="event-sidebar">
      <SidebarWithPreview :eventDetails="{ name: eventName, date: eventDate, time: startTime }" />
    </div>

    <div class="event-main">
      <header class="event-header">
        <h1>ALL EVENTLY</h1>
        <p>EVENT MANAGEMENT</p>
      </header>

      <fieldset>
        <legend>Event Details</legend>
        <label for="event-name">Event Name</label>
        <input
            id="event-name"
            type="text"
            v-model="eventName"
            @blur="validateEventName"
            :class="{ 'input-error': !eventNameValid }"
            placeholder="Enter event name"
            required
        />
        <p v-if="!eventNameValid" class="error-message">Event name is required.</p>
      </fieldset>

      <fieldset>
        <legend>Date and Location</legend>
        <div class="event-type">
          <button
              class="button"
              :class="{ selected: isSingleEvent }"
              @click="toggleEventType(true)"
          >
            Single Event
          </button>
          <button
              class="button"
              :class="{ selected: !isSingleEvent }"
              @click="toggleEventType(false)"
          >
            Recurring Event
          </button>
        </div>

        <div class="event-date-time">
          <label for="event-date">Date and time</label>
          <input id="event-date" type="date" v-model="eventDate" required />
          <input id="start-time" type="time" v-model="startTime" required />
          <input id="end-time" type="time" v-model="endTime" required />

          <label for="time-zone">Event Time Zone</label>
          <select id="time-zone" v-model="timeZone">
            <option v-for="tz in timeZones" :key="tz" :value="tz">{{ tz }}</option>
          </select>
        </div>

        <div class="event-location">
          <label for="event-address">Event Address</label>
          <input id="event-address" type="text" placeholder="Enter address" required />

          <label for="event-venue">Event Venue Name</label>
          <input id="event-venue" type="text" placeholder="Enter venue name" />
        </div>
      </fieldset>

      <section class="guest-settings">
        <h2>Guest Settings</h2>
        <div class="toggle-setting">
          <label>Request Child Count</label>
          <input type="checkbox" v-model="requestChildCount" />
        </div>
        <div class="toggle-setting">
          <label>Limit Additional Guests</label>
          <input type="checkbox" v-model="limitGuests" />
        </div>
        <div class="toggle-setting">
          <label>Allow Guests to RSVP</label>
          <input type="checkbox" v-model="allowRSVP" />
        </div>
      </section>

      <section class="host-settings">
        <h2>Host Settings</h2>
        <label for="host-first-name">Hosted By</label>
        <input
            id="host-first-name"
            class="event-input"
            v-model="hostFirstName"
            placeholder="Insert Host First Name"
        />
        <input
            id="host-last-name"
            class="event-input"
            v-model="hostLastName"
            placeholder="Insert Host Last Name"
        />
        <div class="toggle-setting">
          <label>Get Notified of RSVPs</label>
          <input type="checkbox" v-model="notifyRSVPs" />
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
@import '@/styles/common.css';

:root {
  --primary: #3b5998;
  --light: #f7f7f7;
  --dark: #333;
  --error: #ff4d4f;
  --border: #ccc;
  --background: #eef2f3;
}

body {
  font-family: Arial, sans-serif;
  background-color: var(--background);
  color: var(--dark);
}

.event-creation {
  display: flex;
  gap: 20px;
  padding: 20px;
}

.event-sidebar {
  width: 25%;
  background-color: var(--light);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  border-radius: 8px;
  padding: 20px;
}

.event-main {
  width: 75%;
  background-color: white;
  border-radius: 8px;
  padding: 30px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.event-header h1 {
  font-size: 1.5rem;
  color: var(--primary);
}

fieldset {
  border: 1px solid var(--border);
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 20px;
}

legend {
  color: var(--primary);
  font-weight: bold;
}

label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
}

input, select {
  width: 100%;
  padding: 10px;
  margin-bottom: 15px;
  border: 1px solid var(--border);
  border-radius: 4px;
}

input:focus, select:focus {
  border-color: var(--primary);
  outline: none;
}

.button {
  padding: 10px 15px;
  background-color: var(--primary);
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  transition: transform 0.2s ease;
}

.button:hover {
  transform: scale(1.05);
}

.error-message {
  color: var(--error);
  font-size: 0.9rem;
}

.toggle-setting {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.add-link-button {
  display: block;
  width: 100%;
  text-align: center;
  background-color: var(--light);
  border: 1px solid var(--border);
  border-radius: 4px;
  padding: 10px;
  margin-top: 10px;
  cursor: pointer;
  transition: all 0.3s ease-in-out;
}

.add-link-button:hover {
  background-color: var(--primary);
  color: white;
}

@media (max-width: 768px) {
  .event-creation {
    flex-direction: column;
  }

  .event-sidebar, .event-main {
    width: 100%;
  }
}
</style>
