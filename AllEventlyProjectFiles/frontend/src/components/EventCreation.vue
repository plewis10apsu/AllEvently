<script setup lang="ts">
import {ref, onUnmounted, onMounted, watch, computed} from "vue";
import logo from "@/assets/AllEventlyLogo.png";
import TopPanelWithBack from "@/components/TopPanelWithBack.vue";
import SidebarWithPreview from "@/components/SidebarWithPreview.vue";
import {loadGoogleMapsAPI} from "@/utils/googleMapsLoader.ts";

// Reactive state
const invitation = ref({
  eventName: "",
  date: "",
  time: "",
  location: "",
  imageId: null,
  layout: null,
  fontStyle: {
    fontFamily: "Arial",
    fontSize: 48,
    bold: false,
    italic: false,
    underline: false,
    color: "#000000",
  },
});
const guestNote = ref<string>("");
const googleMapsApiKey = import.meta.env.VITE_GOOGLE_MAPS_API_KEY;
const eventName = ref<string>("");
const eventNameValid = ref<boolean>(true);
const isSingleEvent = ref<boolean>(true);
const eventDisplayStartTime = ref<boolean>(false);
const eventAllDayEvent = ref<boolean>(false);
const eventDisplayEndTime = ref<boolean>(false);
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
const address = ref<string>("");
const inputValue = ref<string>("");
const links = ref<string[]>([]); // List of links
const newLink = ref<string>(""); // New link input
const isRemoveMode = ref(false); // Toggle remove mode
const searchQuery = ref("");
const selectedImage = ref<number | null>(null);
const mapImageUrl = ref<string>("");
let autocomplete: google.maps.places.Autocomplete | null = null;
const nearbyBounds = {  north: 36.678118, south: 34.982972, east: -81.6469, west: -90.3103, };
const activeTab = ref<"details" | "settings">("details");
const selectedLayout = ref("layout-default");
const isPrivate = ref<boolean>(true);
declare const google: any;
const filteredGallery = computed(() =>
    gallery.value.filter(
        (image) =>
            image.theme.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
            searchQuery.value.trim() === ""
    )
);

const selectedImageUrl = computed(() => {
  const image = gallery.value.find((img) => img.id === selectedImage.value);
  return image ? image.src : null;
});

// Function to select an image
function selectImage(imageId: number): void {
  selectedImage.value = imageId;
}

// Adjust sidebar width dynamically based on screen size
const updateSidebarWidth = () => {
  sidebarWidth.value = window.innerWidth <= 809 ? 80 : 200;
};

const fontStyle = ref<{
  fontFamily: string;
  fontSize: number;
  bold: boolean;
  italic: boolean;
  underline: boolean;
  color: string;
  backgroundColor: string;
}>({
  fontFamily: "Arial",
  fontSize: 48,
  bold: false,
  italic: false,
  underline: false,
  color: "#000000",
  backgroundColor: "#ffffff",
});

function updateFontStyle<K extends keyof typeof fontStyle.value>(
    property: K,
    value: typeof fontStyle.value[K]
) {
  fontStyle.value[property] = value;
}

function toggleEventType(isSingle: boolean): void {
  isSingleEvent.value = isSingle;
}

function validateEventName(): void {
  eventNameValid.value = eventName.value.trim().length > 0;
}

function addLink(link: string) {
  if (link.trim() !== "") {
    links.value.push(link);
    newLink.value = ""; // Clear the input after adding
  }
}

// Function to remove a link by index
function removeLink(index: number) {
  links.value.splice(index, 1);
}

// Toggle remove mode
function toggleRemoveMode() {
  isRemoveMode.value = !isRemoveMode.value;
}

/*

function selectLayout(layoutId: string): void {
  invitation.value.layout = layoutId;
}
*/

watch(inputValue, (newValue) => {
  if (newValue.trim() === "") {
    address.value = ""; // Clear the selected address if input is empty
    mapImageUrl.value = "";
  }

  if (autocomplete && newValue.trim() !== "") {
    autocomplete.setBounds(nearbyBounds);
  }
});

// Image gallery
const gallery = ref([
  { id: 1, src:new URL('@/assets/Bike.jpg', import.meta.url).href, theme: "Bike" },
  { id: 2, src:new URL('@/assets/Christmas.jpg', import.meta.url).href, theme: "Christmas" },
  { id: 3, src:new URL('@/assets/Confetti.jpg', import.meta.url).href, theme: "Confetti" },
  { id: 4, src:new URL('@/assets/Default_Invite.jpg', import.meta.url).href, theme: "Default" },
  { id: 5, src:new URL('@/assets/Dog.jpg', import.meta.url).href, theme: "Dog" },
  { id: 6, src:new URL('@/assets/Dry_Flower.jpg', import.meta.url).href, theme: "Flower" },
  { id: 7, src:new URL('@/assets/Easter.jpg', import.meta.url).href, theme: "Easter" },
  { id: 8, src:new URL('@/assets/Football.jpg', import.meta.url).href, theme: "Football" },
  { id: 9, src:new URL('@/assets/Fourth.jpg', import.meta.url).href, theme: "Fourth" },
  { id: 10, src:new URL('@/assets/Gamer.jpg', import.meta.url).href, theme: "Gamer" },
  { id: 11, src:new URL('@/assets/Haley\'s_Birthday_Event_Page.jpg', import.meta.url).href, theme: "Birthday" },
  { id: 12, src:new URL('@/assets/Hanukkah.jpg', import.meta.url).href, theme: "Hanukkah" },
  { id: 13, src:new URL('@/assets/Hike.jpg', import.meta.url).href, theme: "Hike" },
  { id: 14, src:new URL('@/assets/Joy.jpg', import.meta.url).href, theme: "Joy" },
  { id: 15, src:new URL('@/assets/Lisa\'s_Baby_Shower_Event_Page.jpg', import.meta.url).href, theme: "Baby Shower" },
  { id: 16, src:new URL('@/assets/Love.jpg', import.meta.url).href, theme: "Love" },
  { id: 17, src:new URL('@/assets/Pineapple.jpg', import.meta.url).href, theme: "Pineapple" },
  { id: 18, src:new URL('@/assets/PinkPurple_Birthday.jpg', import.meta.url).href, theme: "Purple_Birthday" },
  { id: 19, src:new URL('@/assets/Rose_Invite.jpg', import.meta.url).href, theme: "Rose" },
  { id: 20, src:new URL('@/assets/Soccer.jpg', import.meta.url).href, theme: "Soccer" },
  { id: 21, src:new URL('@/assets/Thanksgiving.jpg', import.meta.url).href, theme: "Thanksgiving" },
  { id: 22, src:new URL('@/assets/Wedding.jpg', import.meta.url).href, theme: "Wedding" },
  { id: 23, src:new URL('@/assets/Graduation.jpg', import.meta.url).href, theme: "Graduation" },
  // Add more images with themes as needed
]);

// Initialize functionality on mount
onMounted(async () => {
  updateSidebarWidth();
  window.addEventListener("resize", updateSidebarWidth);

  try {
    await loadGoogleMapsAPI(googleMapsApiKey);
    console.log("Google Maps API loaded successfully.");
    initializeAutocomplete();
  } catch {
    console.error(Error);
  }
});

const initializeAutocomplete = (): void => {
  if (!window.google || !google.maps || !google.maps.places) {
    console.error("Google Maps API is not fully loaded.");
    return;
  }

  console.log("Initializing Google Maps Autocomplete...");

  const input = document.getElementById("event-address") as HTMLInputElement | null;
  if (!input) {
    console.error("Address input field is not found.");
    return;
  }

  autocomplete = new google.maps.places.Autocomplete(input, {
    fields: ["formatted_address", "geometry"],
  });

  if (autocomplete) {
  autocomplete.addListener("place_changed", () => {
    const place = autocomplete?.getPlace();
    console.log("Selected place:", place);

    if (place?.formatted_address) {
      inputValue.value = place.formatted_address;
    } else {
      console.error("Formatted address is missing from the selected place.");
    }

    if (place?.geometry?.location) {
      const lat = place.geometry.location.lat();
      const lng = place.geometry.location.lng();

      mapImageUrl.value = `https://maps.googleapis.com/maps/api/staticmap?center=${lat},${lng}&zoom=15&size=600x300&maptype=roadmap&markers=color:red%7C${lat},${lng}&key=${googleMapsApiKey}`;
      console.log("Static Map URL:", mapImageUrl.value);
    } else {
      console.error("Place geometry is missing or invalid.");
      mapImageUrl.value = ""; // Clear the map preview if invalid
    }
  });
  } else {
    console.error("Autocomplete is not initialized.");
  }
};

// Cleanup on unmount
onUnmounted(() => {
  window.removeEventListener("resize", updateSidebarWidth);
});

// Add save logic here, such as sending the data to an API or storing it locally
function saveEventDetails() {
  alert("Event details saved!");
  console.log("Saving details:", invitation.value);
}

//commenting these out since they are used in the async function and vercel is whining
/*
const eventLocation = ref<string>("");
const isPublic = ref<Boolean>(true);
const hostEmail = ref<String>("");
*/
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
      :eventDetails="{
        name: invitation.eventName,
        date: invitation.date,
        time: invitation.time,
        endTime: endTime,
        imageUrl: selectedImageUrl,
        fontStyle:{
          fontFamily: fontStyle.fontFamily,
          fontSize: fontStyle.fontSize,
          bold: fontStyle.bold,
          italic: fontStyle.italic,
          underline: fontStyle.underline,
          color: fontStyle.color,
          backgroundColor: fontStyle.backgroundColor
    },
    note: guestNote
    }"
      @save="saveEventDetails"
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

        <!-- Event Details Section -->
        <section v-if="activeTab === 'details'" class="event-details">
          <fieldset>
            <legend>Event Details</legend>
            <label for="event-name">Event Name</label>
            <input
              id="event-name"
              type="text"
              v-model="invitation.eventName"
              @blur="validateEventName"
              :class="{ 'input-error': !eventNameValid }"
              placeholder="Enter event name"
              required
            />
            <p v-if="!invitation.eventName" class="error-message">
              Event name is required.
            </p>
            <label for="event-note">Note for Guests</label>
            <input
              id="event-note"
              type="text"
              v-model="guestNote"
              placeholder="Optional: Note for Guests"
              required
            />
          </fieldset>

          <fieldset>
            <legend>Date and Location</legend>
            <!-- Event Type Selection -->
            <div class="event-type">
              <button
                :class="{ active: isSingleEvent }"
                @click="toggleEventType(true)"
              >
                Single Event
              </button>
              <button
                :class="{ active: !isSingleEvent }"
                @click="toggleEventType(false)"
              >
                Recurring Event
              </button>
            </div>

            <!-- Date and Time Inputs -->
            <div class="event-date-time-row">
              <div>
                <label for="event-date">Date</label>
                <input id="event-date" type="date" v-model="invitation.date" required/>
              </div>
              <div>
                <label for="start-time">Start Time</label>
                <input id="start-time" type="time" v-model="invitation.time" required/>
              </div>
              <div>
                <label for="end-time">End Time</label>
                <input id="end-time" type="time" v-model="endTime" required/>
              </div>
              <div>
                <label for="time-zone">Time Zone</label>
                <select id="time-zone" v-model="timeZone">
                  <option v-for="tz in timeZones" :key="tz" :value="tz">{{ tz }}</option>
                </select>
              </div>
            </div>

            <!-- Checkboxes -->
            <div class="checkbox-row">
              <div>
                <label for="all-day-event">All-day event</label>
                <input id="all-day-event" class="checkbox" type="checkbox" v-model="eventAllDayEvent"/>
              </div>
              <div>
                <label for="display-start-time">Display Start Time</label>
                <input id="display-start-time" class="checkbox" type="checkbox" v-model="eventDisplayStartTime"/>
              </div>
              <div>
                <label for="display-end-time">Display End Time</label>
                <input id="display-end-time" class="checkbox" type="checkbox" v-model="eventDisplayEndTime"/>
              </div>
            </div>

            <!-- Location Inputs -->
            <div class="event-location">
              <div class="event-location-row">
                <div>
                  <label for="event-address">Event Address</label>
                  <input
                      id="event-address"
                      type="text"
                      v-model="inputValue"
                      placeholder="Enter address"
                      required
                      style="width: 100%;"
                  />
                </div>
                <div>
                  <label for="event-venue">Event Venue Name</label>
                  <input id="event-venue" type="text" placeholder="Enter venue name"/>
                </div>
              </div>

              <!-- Map Preview -->
              <div v-if="mapImageUrl" class="map-preview">
                <label>Location Preview</label>
                <img
                    :src="mapImageUrl"
                    alt="Map preview"
                    style="width: 100%; height: auto; border-radius: 8px;"
                />
              </div>
            </div>
          </fieldset>
          <fieldset>
            <legend>Choose an Image</legend>
            <!-- Search Bar -->
            <div class="search-bar">
              <input
                  type="text"
                  v-model="searchQuery"
                  placeholder="Search themes..."
                  class="search-input"
              />
            </div>

            <!-- Image Gallery -->
            <div class="image-gallery">
              <div
                  v-for="image in filteredGallery"
                  :key="image.id"
                  class="gallery-item"
                  :class="{ selected: selectedImage === image.id }"
                  @click="selectImage(image.id)"
              >
                <img :src="image.src" :alt="image.theme" class="gallery-image" />
                <p class="image-theme">{{ image.theme }}</p>
              </div>
            </div>
          </fieldset>

          <fieldset>
            <legend>Choose a Layout</legend>
            <div class="layout-grid">
              <button
                  class="layout-button"
                  :class="{ selected: selectedLayout === 'layout-default' }"
                  @click="selectedLayout = 'layout-default'"
              >
                Default Layout
              </button>
            </div>
          </fieldset>

          <fieldset>
            <legend>Customize the Font</legend>
            <div class="font-customization">
              <select v-model="fontStyle.fontFamily">
                <option value="Allura, cursive">Allura</option>
                <option value="Arial">Arial</option>
                <option value="Dancing Script, cursive">Dancing Script</option>
                <option value="Courier New">Courier New</option>
                <option value="Great Vibes, cursive">Great Vibes</option>
                <option value="Georgia">Georgia</option>
                <option value="Lato, sans-serif">Lato</option>
                <option value="Lucida Console">Lucida Console</option>
                <option value="Montserrat, sans-serif">Montserrat</option>
                <option value="Open Sans, sans-serif">Open Sans</option>
                <option value="Pacifico, cursive">Pacifico</option>
                <option value="Poppins, sans-serif">Poppins</option>
                <option value="Roboto, sans-serif">Roboto</option>
                <option value="Satisfy, cursive">Satisfy</option>
                <option value="Tahoma">Tahoma</option>
                <option value="Times New Roman">Times New Roman</option>
                <option value="Verdana">Verdana</option>
              </select>

              <input
                  type="number"
                  v-model.string="fontStyle.fontSize"
                  :min="10"
                  :max="72"
                  placeholder="Font Size"
              />

              <button
                  :class="{ active: fontStyle.bold }"
                  @click="updateFontStyle('bold', !fontStyle.bold)"
              >
                B
              </button>
              <button
                  :class="{ active: fontStyle.italic }"
                  @click="updateFontStyle('italic', !fontStyle.italic)"
              >
                I
              </button>
              <button
                  :class="{ active: fontStyle.underline }"
                  @click="updateFontStyle('underline', !fontStyle.underline)"
              >
                U
              </button>

              <div>
                <label for="text-color">Text Color</label>
                <input
                    id="text-color"
                    type="color"
                    v-model="fontStyle.color"
                    title="Text Color"
                />
              </div>
            </div>
            <div>
              <label for="background-color">Background Color</label>
              <input
                  id="background-color"
                  type="color"
                  v-model="fontStyle.backgroundColor"
                  title="Background Color"
              />
            </div>
            <div
                class="font-preview"
                :style="{
      fontFamily: fontStyle.fontFamily,
      fontSize: fontStyle.fontSize + 'px',
      fontWeight: fontStyle.bold ? 'bold' : 'normal',
      fontStyle: fontStyle.italic ? 'italic' : 'normal',
      textDecoration: fontStyle.underline ? 'underline' : 'none',
      color: fontStyle.color,
      backgroundColor: fontStyle.backgroundColor,
      padding: '10px',
      borderRadius: '5px',
    }"
            >
              Sample Text Preview
            </div>
          </fieldset>


        </section>

        <!-- Event Settings Section -->
        <section v-if="activeTab === 'settings'" class="event-settings">
          <section class="guest-settings">
            <fieldset>
              <legend>Guest Settings</legend>
              <div class="toggle-setting">
                <label for="request-child-count">Request Child Count</label>
                <button :class="{'active-toggle': requestChildCount}" @click="requestChildCount = !requestChildCount">
                  {{ requestChildCount ? 'ON' : 'OFF' }}
                </button>
              </div>
              <div class="toggle-setting">
                <label for="limit-additional-guests">Limit Additional Guests</label>
                <button :class="{'active-toggle': limitGuests}" @click="limitGuests = !limitGuests">
                  {{ limitGuests ? 'ON' : 'OFF' }}
                </button>
              </div>
              <div class="toggle-setting">
                <label for="allow-rsvp">Allow Guests to RSVP</label>
                <button :class="{'active-toggle': allowRSVP}" @click="allowRSVP = !allowRSVP">
                  {{ allowRSVP ? 'ON' : 'OFF' }}
                </button>
              </div>
            </fieldset>

          </section>
        <section>
          <fieldset>
            <legend>Host Settings</legend>
            <div class="host-setting">
              <label for="host-first-name">Host First Name</label>
              <input
                  id="host-first-name"
                  class="event-input"
                  v-model="hostFirstName"
                  placeholder="Insert Host First Name"
              />
            </div>
            <div class="host-setting">
              <label for="host-last-name">Host Last Name</label>
              <input
                  id="host-last-name"
                  class="event-input"
                  v-model="hostLastName"
                  placeholder="Insert Host Last Name"
              />
            </div>
            <div class="toggle-setting">
              <label for="notify-rsvps">Get Notified of RSVPs</label>
              <button
                  :class="{'active-toggle': notifyRSVPs}"
                  @click="notifyRSVPs = !notifyRSVPs"
              >
                {{ notifyRSVPs ? 'ON' : 'OFF' }}
              </button>
            </div>
            <div class="toggle-setting">
              <label for="event-public-private">Event is Public or Private</label>
              <button
                  class="toggle-button"
                  :class="{'active-toggle': isPrivate}"
                  @click="isPrivate = !isPrivate"
              >
                {{ isPrivate ? 'Private' : 'Public' }}
              </button>
            </div>
          </fieldset>
        </section>

          <fieldset class="event-links">
            <legend>Links</legend>
            <div class="add-link-section">
              <input
                  type="text"
                  v-model="newLink"
                  placeholder="Enter link URL"
                  class="link-input"
              />
              <button class="add-link-button" @click="addLink(newLink)">
                Add Link
              </button>
              <button
                  v-if="links.length > 0"
                  class="remove-mode-button"
                  @click="toggleRemoveMode"
              >
                {{ isRemoveMode ? "Done" : "Remove Mode" }}
              </button>
            </div>

            <ul v-if="links.length > 0" class="links-list">
              <li v-for="(link, index) in links" :key="index" class="link-item">
                <a :href="link" target="_blank" class="link-url">{{ link }}</a>
                <button
                    v-if="isRemoveMode"
                    class="remove-link-button"
                    @click="removeLink(index)"
                >
                  ×
                </button>
              </li>
            </ul>
            <p v-else class="no-links-message">No links added yet.</p>
          </fieldset>

        </section>
      </div>
    </main>
  </div>
</template>


<style scoped>
@import '@/styles/common.css';

.content-header .main-title {
  margin-top: 25px;
  font-size: 4rem;
  font-weight: bold;
  margin-bottom: 10px;
}

.tabs {
  display: flex;
  gap: 10px;
  justify-content: flex-start;
  margin-bottom: 20px;
}

.tabs button {
  padding: 15px 30px;
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
  font-size: 1.5rem;
  font-weight: bold;
  color: #FF6B35;
  padding: 0 10px;
  text-transform: uppercase;
  border-bottom: 2px solid #FF6B35;
  display: inline-block;
}

.event-date-time-row {
  display: flex;
  flex-wrap: wrap;
  gap: 15px;
  justify-content: flex-start;
  align-items: flex-start;
}

.event-date-time-row > div {
  flex: 1 1 calc(25% - 15px);
  min-width: 150px;
  max-width: 300px;
}

.checkbox-row {
  display: flex;
  flex-wrap: wrap;
  gap: 16px;
}

.checkbox-row > div {
  display: flex;
  align-items: center;
  gap: 8px;
}

.checkbox {
  margin: 0;
  width: 16px;
  height: 16px;
}

.checkbox-row label {
  min-width: 125px;
}

.event-location-row {
  display: flex;
  flex-wrap: wrap;
  gap: 15px;
  justify-content: flex-start;
  align-items: flex-start;
}

.event-location-row > div {
  flex: 1 1 calc(50% - 15px);
  min-width: 200px;
  max-width: 100%;
}

/* Input and Label Styling */
fieldset {
  border: 1px solid #ccc;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 20px;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
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

.event-links {
  border: 1px solid #ccc;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 20px;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.event-links legend {
  font-size: 1.5rem;
  font-weight: bold;
  color: #FF6B35;
  padding: 0 10px;
  text-transform: uppercase;
  border-bottom: 2px solid #FF6B35;
  display: inline-block;
}

/* Input and Button Alignment */
.add-link-section {
  display: flex;
  align-items: center;
  gap: 10px; /* Space between input and buttons */
  width: 100%; /* Ensure the section spans the fieldset */
}

.link-input {
  flex: 1; /* Input spans remaining space */
  padding: 10px;
  font-size: 1rem;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-sizing: border-box;
}

.link-input:focus {
  border-color: #E63946;
  outline: none;
  box-shadow: 0 0 8px rgba(230, 57, 70, 0.4);
}

.add-link-button,
.remove-mode-button {
  padding: 10px 20px;
  font-size: 1rem;
  background-color: #ff6b35;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  transition: background-color 0.3s, transform 0.2s;
  white-space: nowrap; /* Prevent button text from wrapping */
}

.add-link-button:hover,
.remove-mode-button:hover {
  background-color: #d9432c;
  transform: scale(1.05);
}

/* Links List */
.links-list {
  margin-top: 15px;
  list-style: none;
  padding: 0;
  width: 100%; /* Ensure the list spans the fieldset */
}

.link-item {
  display: flex;
  align-items: center;
  justify-content: space-between; /* Space between link and remove button */
  padding: 8px 0; /* Add space between items */
  border-bottom: 1px solid #eee; /* Divider between items */
}

.link-item:last-child {
  border-bottom: none; /* Remove divider for the last item */
}

.link-url {
  flex: 1; /* Ensures the link spans available space */
  color: #007bff;
  text-decoration: none;
  word-break: break-word; /* Break long URLs to fit in smaller screens */
  margin-right: 10px; /* Add space between the link and remove button */
}

.link-url:hover {
  text-decoration: underline;
}

/* Remove Button */
.remove-link-button {
  background-color: #ff6b35;
  color: white;
  border: none;
  border-radius: 50%;
  width: 30px;
  height: 30px;
  font-size: 1.2rem;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background-color 0.3s, transform 0.2s;
}

.remove-link-button:hover {
  background-color: #d9432c;
  transform: scale(1.1);
}

/* Empty Links Message */
.no-links-message {
  font-size: 1rem;
  color: #888;
  margin-top: 10px;
  text-align: center;
}

.image-gallery {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); /* Responsive grid */
  gap: 10px; /* Space between images */
  width: 100%; /* Ensure the container spans the full width */
  box-sizing: border-box; /* Include padding and borders in width calculation */
}

.gallery-item {
  width: 150px; /* Fixed width for each image container */
  height: 150px; /* Fixed height for each image container */
  overflow: hidden; /* Ensure no part of the image spills outside the container */
  border: 2px solid transparent; /* Add a border for selection effect */
  border-radius: 8px; /* Optional: rounded corners */
  cursor: pointer;
  transition: border-color 0.3s;
}

.gallery-item.selected {
  border-color: #ff6b35; /* Highlight selected image */
}

.gallery-image {
  width: 100%; /* Make the image fill the container width */
  height: 100%; /* Make the image fill the container height */
  object-fit: cover; /* Ensure the image scales and crops to fit the container */
}

/* Layout for Host First Name and Last Name */
.host-setting {
  display: flex;
  flex-direction: column; /* Stack label and input vertically */
  margin-bottom: 15px; /* Space between fields */
}

.host-setting label {
  margin-bottom: 5px; /* Space between label and input */
  font-weight: bold;
}

.host-setting input {
  width: 100%; /* Input spans the full width */
  max-width: 400px; /* Optional: Limit input width */
  padding: 8px; /* Add padding for better usability */
  font-size: 1rem;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-sizing: border-box;
}

.host-setting input:focus {
  border-color: #E63946; /* Add focus styling */
  outline: none;
  box-shadow: 0 0 8px rgba(230, 57, 70, 0.4);
}

.toggle-setting {
  display: flex; /* Enables flexbox layout */
  justify-content: space-between; /* Space between label and button */
  align-items: center; /* Aligns label and button vertically */
  margin-bottom: 10px;
  width: 100%; /* Ensure the container spans the full width */
}

.toggle-setting label {
  flex: 1; /* Makes the label take up available space */
  margin-bottom: 0; /* Removes extra space below the label */
  font-weight: bold;
  text-align: left; /* Aligns label text to the left */
  padding-right: 10px; /* Optional spacing */
}

.toggle-setting button {
  flex: 0; /* Ensures button does not stretch */
  min-width: 120px; /* Consistent button width */
  padding: 5px 15px; /* Adjust padding for better sizing */
  font-size: 16px; /* Ensure readable text */
  border: 1px solid #ccc;
  border-radius: 4px;
  cursor: pointer;
  background-color: #f1b8a3; /* Default button background */
  text-align: center;
  transition: background-color 0.3s;
}

.toggle-setting button.active-toggle {
  background-color: #ff6b35; /* Active state background */
  color: white;
}

@media screen and (max-width: 768px) {
  .tabs button {
    padding: 10px 20px;
    font-size: 1rem;
  }
}
</style>
