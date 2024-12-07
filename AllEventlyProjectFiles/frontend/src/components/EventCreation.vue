<script setup lang="ts">
import {ref, onUnmounted} from "vue";
import logo from "@/assets/AllEventlyLogo.png";
import TopPanelWithBack from "@/components/TopPanelWithBack.vue";
import SidebarWithPreview from "@/components/SidebarWithPreview.vue";

// Reactive state
const eventName = ref<string>("");
const eventNameValid = ref<boolean>(true);
const isSingleEvent = ref<boolean>(true);
const eventDate = ref<string>("");
const eventDisplayStartTime = ref<boolean>(false);
const eventAllDayEvent = ref<boolean>(false);
const eventDisplayEndTime = ref<boolean>(false);
const startTime = ref<string>("");
const endTime = ref<string>("");
const timeZone = ref<string>("CDT");
const timeZones = ref<string[]>(["CDT", "EST", "PST", "MST", "UTC"]);
const requestChildCount = ref<boolean>(false);
const limitGuests = ref<boolean>(false);
const allowRSVP = ref<boolean>(false);
const hostFirstName = ref<string>("");
const hostLastName = ref<string>("");
const notifyRSVPs = ref<boolean>(false);
const isSidebarVisible = ref<boolean>(true);
const sidebarWidth = ref<number>(200);
//commenting these out since they are used in the async function and vercel is whining
/*
const eventLocation = ref<string>("");
const isPublic = ref<Boolean>(true);
const hostEmail = ref<String>("");
*/

// Tab navigation
const activeTab = ref<"details" | "settings">("details");

// Adjust sidebar width dynamically based on screen size
const updateSidebarWidth = () => {
  sidebarWidth.value = window.innerWidth <= 809 ? 80 : 200;
};

window.addEventListener("resize", updateSidebarWidth);
onUnmounted(() => {
  window.removeEventListener("resize", updateSidebarWidth);
});

/*// Computed properties
const isFormValid = computed((): boolean => {
  return (
    eventName.value.trim() !== "" &&
    eventDate.value !== "" &&
    startTime.value !== "" &&
    endTime.value !== ""
  );
});*/
/*
//commented out for now to avoid vercel complaints
const createEvent = async () => {
  try {
    const response = await fetch('https://all-evently-backend.vercel.app/api/eventcreation', {
      method : 'POST',
      headers : {
        'Content-Type': 'application/json',
      },
      body : JSON.stringify({
        hostEmail : hostEmail.value,
        hostFirstName : hostFirstName.value,
        hostLastName : hostLastName.value,
        eventName : eventName.value,
        eventLocation : eventLocation.value,
        isPublic : isPublic.value
      })
    });
    if (response.ok) {
      const data = await response.json();
      alert("Successfully created event: "+data.eventName);
    } else {
      console.error("Error creating event. Please try again.");
    }
  } catch (error) {
    console.error(error);
  }
};
*/
// Methods
function toggleEventType(isSingle: boolean): void {
  isSingleEvent.value = isSingle;
}

function validateEventName(): void {
  eventNameValid.value = eventName.value.trim().length > 0;
}

/*function submitEvent(): void {
  if (isFormValid.value) {
    console.log("Event submitted with the following details:", {
      eventName: eventName.value,
      eventDate: eventDate.value,
      startTime: startTime.value,
      endTime: endTime.value,
      timeZone: timeZone.value,
      requestChildCount: requestChildCount.value,
      limitGuests: limitGuests.value,
      allowRSVP: allowRSVP.value,
      hostFirstName: hostFirstName.value,
      hostLastName: hostLastName.value,
      notifyRSVPs: notifyRSVPs.value,
    });
    alert("Event successfully created!");
  } else {
    alert("Please fill in all required fields.");
  }
}*/

</script>

<template>
  <div class="page-layout event-creation-page">
    <TopPanelWithBack :logo="logo"/>
    <SidebarWithPreview
        :isVisible="isSidebarVisible"
        :width="sidebarWidth"
        :eventDetails="{ name: eventName, date: eventDate, time: startTime }"
    />
    <!-- Main content area -->
    <main class="content-area event-creation-content">
      <div>
        <div class="content-header">
          <h1 class="main-title">New Event</h1>
          <div class="tabs">
            <button
                :class="{ active: activeTab === 'details' }"
                @click="activeTab = 'details'"
            >
              Event Details
            </button>
            <button
                :class="{ active: activeTab === 'settings' }"
                @click="activeTab = 'settings'"
            >
              Event Settings
            </button>
          </div>
        </div>
        <section v-if="activeTab === 'details'" class="event-details">
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

            <label for="event-name">Note for Guests</label>
            <input
                id="event-note"
                type="text"
                placeholder="Optional: Note for Guests"
                required
            />
          </fieldset>

          <fieldset>
            <legend>Date and Location</legend>
            <div class="event-type">
              <label for="event-type">Type of Event</label>
              <button class="button" :class="{ selected: isSingleEvent }" @click="toggleEventType(true)">
                Single Event
              </button>
              <button class="button" :class="{ selected: !isSingleEvent }" @click="toggleEventType(false)">
                Recurring Event
              </button>

            </div>
            <div class="event-date-time-row" v-if="isSingleEvent">
              <div>
                <label for="event-date" class="">
                  Date
                </label>
                <input id="event-date" type="date" v-model="eventDate" required/>
              </div>
              <div>
                <label for="start-time">Start Time</label>
                <input id="start-time" type="time" v-model="startTime" required/>
              </div>
              <div>
                <label for="end-time">End Time</label>
                <input id="end-time" type="time" v-model="endTime" required/>
              </div>
              <div>
                <label for="time-zone">Event Time Zone</label>
                <select id="time-zone" v-model="timeZone">
                  <option v-for="tz in timeZones" :key="tz" :value="tz">{{ tz }}</option>
                </select>
              </div>
            </div>
            <div class="checkbox-row" v-if="isSingleEvent">
              <div>
                <label for="all-day-event">All-day event</label>
                <input id="all-day-event" class="checkbox" type="checkbox" v-model="eventAllDayEvent" required/>
              </div>
              <div>
                <label for="display-start-time">Display start time</label>
                <input id="display-start-time" class="checkbox" type="checkbox" v-model="eventDisplayStartTime"
                       required/>
              </div>
              <div>
                <label for="display-end-time">Display end time</label>
                <input id="display-end-time" class="checkbox" type="checkbox" v-model="eventDisplayEndTime" required/>
              </div>
            </div>
            <div class="event-location">
              <label for="event-address">Event Address</label>
              <input id="event-address" type="text" placeholder="Enter address" required/>

              <label for="event-venue">Event Venue Name</label>
              <input id="event-venue" type="text" placeholder="Enter venue name"/>
            </div>
          </fieldset>
        </section>

        <section v-if="activeTab === 'settings'" class="event-settings">
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
              <input type="checkbox" v-model="notifyRSVPs"/>
            </div>
          </section>

          <section class="event-links">
            <h2>Links</h2>
            <button
                class="add-link-button"
                v-for="n in 4"
                :key="n"
            >
              Add a Link to Your Invite
            </button>
          </section>
        </section>
      </div>
    </main>
  </div>
</template>

<style scoped>
@import '@/styles/common.css';

.content-header .main-title {
  margin-top: 25px;
  font-size: 4rem; /* Adjust to your desired size */
  font-weight: bold; /* Optional: Keep it bold or adjust */
  margin-bottom: 10px; /* Optional: Adjust spacing around the title */
}

.tabs {
  display: flex;
  gap: 10px;
  justify-content: flex-start; /* Align buttons to the left */
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
  transition: transform 0.2s, background-color 0.3s;
}

.tabs button:hover {
  background-color: #D9432C;
  transform: scale(1.05);
}

.tabs button.active {
  background-color: #E63946;
  color: white;
  font-size: 1.2rem;
  box-shadow: 0 4px 15px rgba(230, 57, 70, 0.4);
}

legend {
  font-size: 1.5rem; /* Adjust to match your design */
  font-weight: bold;
  color: #FF6B35; /* Match the primary accent color from your tabs */
  padding: 0 10px; /* Adds spacing around the legend text */
  text-transform: uppercase; /* Optional: Makes the text uppercase */
  border-bottom: 2px solid #FF6B35; /* Adds an underline effect */
  display: inline-block;
}

.event-date-time-row {
  display: flex;
  flex-wrap: wrap; /* Allow items to wrap to the next line if necessary */
  gap: 15px; /* Space between the inputs */
  justify-content: flex-start; /* Align items to the left */
  align-items: flex-start; /* Align items at the top */
}

.event-date-time-row > div {
  flex: 1 1 calc(25% - 15px); /* Adjust size of each input field */
  min-width: 150px; /* Ensure inputs don’t shrink below this size */
  max-width: 300px; /* Optional: Limit the maximum width */
}

.checkbox-row {
  display: flex; /* Make the entire row a flex container */
  flex-wrap: wrap; /* Allow wrapping if there are too many items in a row */
  gap: 16px; /* Space between each checkbox-label pair */
}

.checkbox-row > div {
  display: flex; /* Align each label-checkbox pair in a row */
  align-items: center; /* Vertically align the checkbox and label */
  gap: 8px; /* Space between the checkbox and label */
}

.checkbox {
  margin: 0; /* Remove default margins for checkboxes */
  width: 16px; /* Ensure consistent width for the checkbox */
  height: 16px; /* Ensure consistent height for the checkbox */
}

.checkbox-row label {
  min-width: 125px; /* Ensure all labels take at least this much space */
}

/* Input and Label Styling */
fieldset {
  border: 1px solid #ccc;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 20px;
  display: flex;
  flex-direction: column; /* Align items vertically */
  align-items: flex-start; /* Align content to the left */
}

label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
}

input, select {
  width: 100%;
  max-width: 400px;
  padding: 10px;
  border: 1px solid #ccc;
  border-radius: 4px;
  font-size: 1rem;
  box-sizing: border-box;
}

input:focus, select:focus {
  border-color: #E63946;
  outline: none;
  box-shadow: 0 0 8px rgba(230, 57, 70, 0.4);
}

/* Button Styling */
button {
  font-size: 1rem;
  padding: 10px 20px;
  background-color: #FF6B35;
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s, transform 0.2s;
}

button:hover {
  background-color: #D9432C;
  transform: scale(1.05);
}

@media screen and (max-width: 768px) {
  .tabs button {
    padding: 10px 20px; /* Adjust padding for smaller screens */
    font-size: 1rem; /* Reduce font size */
  }
}
</style>
