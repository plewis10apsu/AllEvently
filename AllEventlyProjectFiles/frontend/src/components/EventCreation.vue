<script setup lang="ts">
import {ref, onUnmounted, onMounted, watch, computed} from "vue";
import logo from "@/assets/AllEventlyLogo.png";
import TopPanelWithBack from "@/components/TopPanelWithBack.vue";
import SidebarWithPreview from "@/components/SidebarWithPreview.vue";
import {loadGoogleMapsAPI} from "@/utils/googleMapsLoader.ts";

const guestNote = ref<string>("");
const googleMapsApiKey = import.meta.env.VITE_GOOGLE_MAPS_API_KEY;
const eventName = ref<string>("");
const eventNameValid = ref<boolean>(true);
const isSingleEvent = ref<boolean>(true);
const isAllDayEvent = ref<boolean>(false);
const eventDisplayStartTime = ref<boolean>(false);
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
const maxAdditionalGuests = ref<number>(0);
const hostEmail = ref<string>("johndoe@gmail.com");

const recurringSettings = ref({
  unit: "week", // Frequency unit: day, week, month
  interval: 1, // Number of intervals
  selectedDays: [] as string[], // Selected days for weekly recurrence
  monthOption: "specific-day", // Monthly recurrence option
  specificDay: 1, // Specific day of the month for monthly recurrence
  nthWeek: "1st", // Nth occurrence for monthly recurrence (1st, 2nd, etc.)
  selectedDay: "Monday", // Day of the week for nth occurrence
  ends: "never", // End condition: never, on a date, or after occurrences
  endDate: "", // End date for recurrence
  occurrences: 1, // Number of occurrences if "after" is selected
});

const recurring = computed(() => !isSingleEvent.value);

const recurFrequency = ref<number>(1); // Interval frequency (e.g., every 1 week)
const recurEndDate = ref<string>(""); // End date for recurring events
const daysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

//added some additional necessary variables for database entry - Spenser
//commenting them out for now
/*



*/
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
  fontSize: 10,
  bold: false,
  italic: false,
  underline: false,
  color: "#ffffff",
  backgroundColor: "#083D77",
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

function toggleLimitGuests() {
  limitGuests.value = !limitGuests.value;
  if (!limitGuests.value) {
    maxAdditionalGuests.value = 0; // Reset dropdown value when toggled off
  }
}

function removeLink(index: number) {
  links.value.splice(index, 1);
}

function toggleRemoveMode() {
  isRemoveMode.value = !isRemoveMode.value;
}
/*
const createEvent = async () => {
  try {
    const response = await fetch('https://all-evently-backend.vercel.app/api/eventcreation', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        hostEmail: hostEmail.value,
        hostFirstName: hostFirstName.value,
        hostLastName: hostLastName.value,
        eventName: eventName.value,
        address: address.value,
        date: invitation.date,
        startTime: invitation.startTime,
        endTime: endTime.value,
        timeZone: timeZone.value,
        selectedLayout: selectedLayout.value,
        selectedImage: selectedImage.value,
        backGroundColor: fontStyle.backGroundColor,
        fontColor: fontStyle.fontColor,
        font: fontStyle.font,
        isPrivate: isPrivate.value,
        recurring: recurring.value,
        recurrenceFrequency: recurFrequency.value,
        recurrenceEndDate: recurEndDate.value,
        requestChildCount: requestChildCount.value,
        limitGuests: limitGuests.value,
        maxAdditionalGuests: maxAdditionalGuests.value,
        notifyRSVPs: notifyRSVPs.value
      }),
    });
    if (response.ok) {
      //change later
      console.log("Event successfully created!");
      alert("Event successfully created!");
    } else {
      alert("Error creating event.");
    }
  } catch (error) {
    console.error(error);
    alert("Error creating event.");
  }
};
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
  { id: 1, src: new URL('@/assets/Invitations/Bike.jpg', import.meta.url).href, theme: "Bike" },
  { id: 2, src: new URL('@/assets/Invitations/Christmas.jpg', import.meta.url).href, theme: "Christmas" },
  { id: 3, src: new URL('@/assets/Invitations/Confetti.jpg', import.meta.url).href, theme: "Confetti" },
  { id: 4, src: new URL('@/assets/Invitations/Default_Invite.jpg', import.meta.url).href, theme: "Default" },
  { id: 5, src: new URL('@/assets/Invitations/Dog.jpg', import.meta.url).href, theme: "Dog" },
  { id: 6, src: new URL('@/assets/Invitations/Dry_Flower.jpg', import.meta.url).href, theme: "Flower" },
  { id: 7, src: new URL('@/assets/Invitations/Easter.jpg', import.meta.url).href, theme: "Easter" },
  { id: 8, src: new URL('@/assets/Invitations/Football.jpg', import.meta.url).href, theme: "Football" },
  { id: 9, src: new URL('@/assets/Invitations/Fourth.jpg', import.meta.url).href, theme: "Fourth" },
  { id: 10, src: new URL('@/assets/Invitations/Gamer.jpg', import.meta.url).href, theme: "Gamer" },
  { id: 11, src: new URL('@/assets/Invitations/Haley\'s_Birthday_Event_Page.jpg', import.meta.url).href, theme: "Birthday" },
  { id: 12, src: new URL('@/assets/Invitations/Hanukkah.jpg', import.meta.url).href, theme: "Hanukkah" },
  { id: 13, src: new URL('@/assets/Invitations/Hike.jpg', import.meta.url).href, theme: "Hike" },
  { id: 14, src: new URL('@/assets/Invitations/Joy.jpg', import.meta.url).href, theme: "Joy" },
  { id: 15, src: new URL('@/assets/Invitations/Lisa\'s_Baby_Shower_Event_Page.jpg', import.meta.url).href, theme: "Baby Shower" },
  { id: 16, src: new URL('@/assets/Invitations/Love.jpg', import.meta.url).href, theme: "Love" },
  { id: 17, src: new URL('@/assets/Invitations/Pineapple.jpg', import.meta.url).href, theme: "Pineapple" },
  { id: 18, src: new URL('@/assets/Invitations/PinkPurple_Birthday.jpg', import.meta.url).href, theme: "Birthday" },
  { id: 19, src: new URL('@/assets/Invitations/Rose_Invite.jpg', import.meta.url).href, theme: "Rose" },
  { id: 20, src: new URL('@/assets/Invitations/Soccer.jpg', import.meta.url).href, theme: "Soccer" },
  { id: 21, src: new URL('@/assets/Invitations/Thanksgiving.jpg', import.meta.url).href, theme: "Thanksgiving" },
  { id: 22, src: new URL('@/assets/Invitations/Wedding.jpg', import.meta.url).href, theme: "Wedding" },
  { id: 23, src: new URL('@/assets/Invitations/Graduation.jpg', import.meta.url).href, theme: "Graduation" },
  { id: 24, src: new URL('@/assets/Invitations/Birthday_Confetti.jpg', import.meta.url).href, theme: "Birthday" },
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
      invitation.value.locationAddress = place.formatted_address;
      console.log("Full Address Updated:", invitation.value.locationAddress);
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
  console.log("Saving event details:", {
    hostFirstName: hostFirstName.value,
    hostLastName: hostLastName.value,
    hostEmail: hostEmail.value,
    recurring: !isSingleEvent.value,
    frequency: recurringSettings.value.interval,
    unit: recurringSettings.value.unit,
    weeklyDays: recurringSettings.value.unit === "week" ? recurringSettings.value.selectedDays : [],
    monthlyOption: recurringSettings.value.unit === "month" ? recurringSettings.value.monthOption : null,
    specificDay:
        recurringSettings.value.unit === "month" && recurringSettings.value.monthOption === "specific-day"
            ? recurringSettings.value.specificDay
            : null,
    nthWeek:
        recurringSettings.value.unit === "month" && recurringSettings.value.monthOption === "nth-weekday"
            ? recurringSettings.value.nthWeek
            : null,
    selectedDay:
        recurringSettings.value.unit === "month" && recurringSettings.value.monthOption === "nth-weekday"
            ? recurringSettings.value.selectedDay
            : null,
    endCondition: recurringSettings.value.ends,
    endDate: recurringSettings.value.ends === "on" ? recurEndDate.value : null,
    occurrences: recurringSettings.value.ends === "after" ? recurringSettings.value.occurrences : null,
    // Add other fields as needed
  });
  alert("Event details saved!");
}

// Reactive state
const invitation = ref({
  eventName: "",
  date: "",
  time: "",
  locationName: "", // Venue Name
  locationAddress: "", // Address
  imageId: null,
  layout: null,
  fontStyle: {
    fontFamily: "Arial",
    fontSize: 10,
    bold: false,
    italic: false,
    underline: false,
    color: "#fbfbfb",
    backgroundColor: "#083D77"
  },
});

const sidebarEventDetails = computed(() => ({
  name: invitation.value.eventName,
  date: invitation.value.date,
  time: isAllDayEvent.value ? "" : invitation.value.time,
  endTime: isAllDayEvent.value ? "" : endTime.value,
  imageUrl: selectedImageUrl.value,
  fontStyle: {
    fontFamily: fontStyle.value.fontFamily,
    fontSize: fontStyle.value.fontSize,
    bold: fontStyle.value.bold,
    italic: fontStyle.value.italic,
    underline: fontStyle.value.underline,
    color: fontStyle.value.color,
    backgroundColor: fontStyle.value.backgroundColor,
  },
  note: guestNote.value,
  locationName: invitation.value.locationName,
  locationAddress: invitation.value.locationAddress,
  mapImageUrl: mapImageUrl.value,
}));

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
      :eventDetails="sidebarEventDetails"
      :isAllDayEvent="isAllDayEvent"
      :displayStartTime="eventDisplayStartTime"
      :displayEndTime="eventDisplayEndTime"
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
                <input id="start-time" type="time" v-model="invitation.time" :disabled="isAllDayEvent"/>
              </div>
              <div>
                <label for="end-time">End Time</label>
                <input id="end-time" type="time" v-model="endTime" :disabled="isAllDayEvent"/>
              </div>
              <div>
                <label for="time-zone">Time Zone</label>
                <select id="time-zone" v-model="timeZone" :disabled="isAllDayEvent">
                  <option v-for="tz in timeZones" :key="tz" :value="tz">{{ tz }}</option>
                </select>
              </div>
            </div>

            <!-- Checkboxes -->
            <div class="checkbox-row">
              <!-- All-day Event Checkbox -->
              <div>
                <label for="all-day-event">All-day event</label>
                <input id="all-day-event" class="checkbox" type="checkbox" v-model="isAllDayEvent"/>
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

            <!-- Recurring Event Details -->
            <div v-if="recurring" class="recurring-event-details">
              <fieldset>
                <legend>Repeats</legend>
                <div class="repeat-options">
                  <label for="repeat-interval">Every</label>
                  <input
                      id="repeat-interval"
                      type="number"
                      min="1"
                      v-model="recurFrequency"
                  />
                  <select id="repeat-unit" v-model="recurringSettings.unit">
                    <option value="day">Day</option>
                    <option value="week">Week</option>
                    <option value="month">Month</option>
                  </select>
                </div>
                <!-- Weekly Recurrence: Day Selection -->
                <div v-if="recurringSettings.unit === 'week'" class="repeat-days">
                  <p>Select Day(s):</p>
                  <div class="day-checkboxes">
                    <label v-for="(day, index) in daysOfWeek" :key="index">
                      <input
                          type="checkbox"
                          :value="day"
                          v-model="recurringSettings.selectedDays"
                      />
                      {{ day }}
                    </label>
                  </div>
                </div>
                <!-- Monthly Recurrence: Weekday Selection -->
                <div v-if="recurringSettings.unit === 'month'" class="repeat-monthly">
                  <p>Repeat on:</p>
                  <select v-model="recurringSettings.monthOption">
                    <option value="specific-day">Specific Day</option>
                    <option value="nth-weekday">Nth Weekday</option>
                  </select>
                  <div v-if="recurringSettings.monthOption === 'specific-day'">
                    <label for="specific-day">Day of the Month</label>
                    <input
                        id="specific-day"
                        type="number"
                        min="1"
                        max="31"
                        v-model="recurringSettings.specificDay"
                    />
                  </div>
                  <div v-else>
                    <label for="nth-weekday">
                      <select v-model="recurringSettings.nthWeek">
                        <option value="1st">1st</option>
                        <option value="2nd">2nd</option>
                        <option value="3rd">3rd</option>
                        <option value="4th">4th</option>
                        <option value="last">Last</option>
                      </select>
                      <select v-model="recurringSettings.selectedDay">
                        <option v-for="day in daysOfWeek" :key="day" :value="day">
                          {{ day }}
                        </option>
                      </select>
                    </label>
                  </div>
                </div>
              </fieldset>
              <fieldset>
                <legend>Ends</legend>
                <div>
                  <label>
                    <input
                        type="radio"
                        value="never"
                        v-model="recurringSettings.ends"
                    />
                    Never
                  </label>
                </div>
                <div>
                  <label>
                    <input
                        type="radio"
                        value="on"
                        v-model="recurringSettings.ends"
                    />
                    On
                    <input
                        type="date"
                        v-model="recurEndDate"
                        :disabled="recurringSettings.ends !== 'on'"
                    />
                  </label>
                </div>
                <div>
                  <label>
                    <input
                        type="radio"
                        value="after"
                        v-model="recurringSettings.ends"
                    />
                    After
                    <input
                        type="number"
                        min="1"
                        v-model="recurringSettings.occurrences"
                        :disabled="recurringSettings.ends !== 'after'"
                    />
                    times
                  </label>
                </div>
              </fieldset>
            </div>

            <!-- Location Inputs -->
            <div class="event-location">
              <div class="event-location-row">
                <div>
                  <label for="event-address">Event Address</label>
                  <input
                      id="event-address"
                      type="text"
                      v-model="invitation.locationAddress"
                      placeholder="Enter address"
                      required
                      style="width: 100%;"
                  />
                </div>
                <div>
                  <label for="event-venue">Event Venue Name</label>
                  <input id="event-venue"
                         type="text"
                         v-model="invitation.locationName"
                         placeholder="Enter venue name"/>
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
                <button :class="{'active-toggle': limitGuests}" @click="toggleLimitGuests">
                  {{ limitGuests ? 'ON' : 'OFF' }}
                </button>
              </div>

              <!-- Dropdown appears only if limitGuests is true -->
              <div v-if="limitGuests" class="guest-limit-dropdown">
                <label for="max-additional-guests">Maximum Additional Guests</label>
                <select id="max-additional-guests" v-model="maxAdditionalGuests">
                  <option v-for="num in 10" :key="num" :value="num">{{ num }}</option>
                </select>
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

            <!-- New Host Email Field -->
            <div class="host-setting">
              <label for="host-email">Host Email</label>
              <input
                  id="host-email"
                  class="event-input"
                  v-model="hostEmail"
                  placeholder="Insert Host Email"
                  type="email"
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

.time-zone-input:disabled {
  background-color: #e9ecef;
  cursor: not-allowed;
}

.recurring-event-details {
  margin-top: 15px;
  border: 1px solid #ccc;
  padding: 15px;
  border-radius: 8px;
}

.repeat-options,
.repeat-days,
.repeat-monthly {
  margin-bottom: 15px;
}

.day-checkboxes {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.day-checkboxes label {
  display: flex;
  align-items: center;
  gap: 5px;
}


fieldset legend {
  font-size: 1.2rem;
  color: #ff6b35;
  font-weight: bold;
}

input[type="number"], input[type="date"], select {
  width: auto;
  padding: 8px;
  font-size: 1rem;
  border: 1px solid #ccc;
  border-radius: 4px;
}

input[type="checkbox"] {
  margin-right: 5px;
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

.guest-limit-dropdown {
  margin-top: 10px;
  display: flex;
  flex-direction: column;
  gap: 5px;
}

.guest-limit-dropdown select {
  width: 100%;
  max-width: 300px;
  padding: 8px;
  border: 1px solid #ccc;
  border-radius: 4px;
  font-size: 1rem;
}

.guest-limit-dropdown label {
  font-weight: bold;
}

.host-setting {
  display: flex;
  flex-direction: column;
  margin-bottom: 15px;
}

.host-setting label {
  margin-bottom: 5px;
  font-weight: bold;
}

.host-setting input {
  width: 100%;
  max-width: 400px;
  padding: 8px;
  font-size: 1rem;
  border: 1px solid #ccc;
  border-radius: 4px;
}

.host-setting input:focus {
  border-color: #E63946;
  outline: none;
  box-shadow: 0 0 8px rgba(230, 57, 70, 0.4);
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
