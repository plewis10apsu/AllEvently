<script setup lang="ts">
import {defineProps, computed, ref} from "vue";

const props = defineProps<{
  eventDetails: {
    name: string;
    date: string;
    time: string;
    endTime?: string;
    imageUrl?: string | null;
    fontStyle?: {
      fontFamily: string;
      fontSize: number;
      bold: boolean;
      italic: boolean;
      underline: boolean;
      color: string;
      backgroundColor: string;
    };
    note?: string;
    locationName?: string; // Venue Name
    locationAddress?: string; // Address
    mapImageUrl?: string; // Map URL
  };
  isAllDayEvent: boolean;
  displayStartTime: boolean;
  displayEndTime: boolean;
}>();

const eventDetails = computed(() => props.eventDetails);
const isVisible = ref(true);
const emit = defineEmits(["save"]); // Emit save event

function handleSave() {
  emit("save");
}

const formattedDateTime = computed(() => {
  if (!props.eventDetails.date) {
    return {
      formattedDate: "",
      formattedStartTime: "",
      formattedEndTime: "",
    };
  }

  const startDate = new Date(`${props.eventDetails.date}T${props.eventDetails.time || "00:00"}`);
  const endDate = props.eventDetails.endTime
      ? new Date(`${props.eventDetails.date}T${props.eventDetails.endTime}`)
      : null;

  const formattedDate = new Intl.DateTimeFormat("en-US", {
    month: "long",
    day: "numeric",
    year: "numeric",
  }).format(startDate);

  const formattedStartTime = props.displayStartTime
      ? new Intl.DateTimeFormat("en-US", {
        hour: "numeric",
        minute: "numeric",
        hour12: true,
      }).format(startDate)
      : "";

  const formattedEndTime = props.displayEndTime && endDate
      ? new Intl.DateTimeFormat("en-US", {
        hour: "numeric",
        minute: "numeric",
        hour12: true,
      }).format(endDate)
      : "";

  if (props.isAllDayEvent) {
    return {
      formattedDate,
      formattedStartTime: "",
      formattedEndTime: "",
    };
  }

  return {
    formattedDate,
    formattedStartTime,
    formattedEndTime,
  };
});

function viewInvitation() {
  if (!eventDetails.value) {
    console.error("Event details are undefined.");
    return;
  }

  const details = eventDetails.value;

  if (!details.date) {
    alert("Event date is required.");
    return;
  }

  const { formattedDate, formattedStartTime, formattedEndTime } = formattedDateTime.value;

  const fontStyle = {
    fontFamily: details.fontStyle?.fontFamily || "Arial",
    fontSize: details.fontStyle?.fontSize || 16,
    bold: details.fontStyle?.bold || false,
    italic: details.fontStyle?.italic || false,
    underline: details.fontStyle?.underline || false,
    color: details.fontStyle?.color || "#ffffff",
    backgroundColor: details.fontStyle?.backgroundColor || "rgba(0, 0, 0, 0.7)",
  };

  const htmlContent = `
    <!DOCTYPE html>
    <html lang="en">
    <head>
    <!--Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Great+Vibes&family=Pacifico&family=Allura&family=Satisfy&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@100;200;300;400;500;600;700&display=swap" rel="stylesheet">
      <link href="https://fonts.googleapis.com/css2?family=Great+Vibes&display=swap" rel="stylesheet">
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Event Invitation</title>
      <style>
        body {
          margin: 0;
          padding: 0;
          font-family: ${fontStyle.fontFamily};
          background: ${details.imageUrl ? `url('${details.imageUrl}') no-repeat center center / cover` : "#333"};
          height: 100vh;
          display: flex;
          align-items: flex-start;
          justify-content: flex-start;
          overflow: hidden;
        }
        .invitation {
          position: absolute;
          left: 10px;
          top: 20px;
          max-width: 400px;
          padding: 10px;
          background-color: ${fontStyle.backgroundColor};
          border-radius: 8px;
          box-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
          color: ${fontStyle.color};
          font-size: ${fontStyle.fontSize};
          text-align: left;
        }
        .event-name {
          font-size: ${fontStyle.fontSize + 4}px;
          font-weight: ${fontStyle.bold ? "bold" : "normal"};
          text-decoration: ${fontStyle.underline ? "underline" : "none"};
          margin-bottom: 5px;
        }
        .event-date{
          margin: 5px 0;
        }
        .event-note {
            margin-top: 10px;
            max-width: 180px; /* Match the map width */
            word-wrap: break-word; /* Break long words */
            overflow-wrap: break-word; /* For modern browsers */
            line-height: 1.4;
        }
        .map-preview img {
          width: 180px;
          height: auto;
          border-radius: 6px;
          margin-top: 8px;
        }
        .qr-code-placeholder {
          margin-top: 10px;
          width: 60px;
          height: 60px;
          background-color: #ccc;
          border-radius: 6px;
          font-size: 10px;
          color: #333;
          display: flex;
          align-items: center;
          justify-content: center;
        }
      </style>
    </head>
    <body>
      <div class="invitation">
        <!-- Event Name -->
        <div class="event-name">${details.name || "Event Name"}</div>

        <!-- Event Date -->
        <div class="event-date">${formattedDate || "Event Date"}</div>

        <!-- Event Time -->
        ${
      formattedStartTime || formattedEndTime
          ? `<div class="event-time">
                  ${formattedStartTime || ""} ${
              formattedEndTime ? `- ${formattedEndTime}` : ""
          }
                </div>`
          : ""
  }

        <!-- Venue Name and Address -->
        ${
      details.locationName || details.locationAddress
          ? `<div class="event-location">
         <div class="location-details">
           <span>${details.locationName || ""}</span><br>
           <span>${details.locationAddress?.split(",")[0] ?? ""}</span><br>
           <span>${details.locationAddress?.split(",").slice(1).join(",") ?? ""}</span>
         </div>
       </div>`
          : ""
  }

        <!-- Map Preview -->
        ${
      details.mapImageUrl
          ? `<div class="map-preview">
                   <img src="${details.mapImageUrl}" alt="Map Preview" />
                 </div>`
          : ""
  }

        <!-- Notes -->
        ${
      details.note
          ? `<div class="event-note">${details.note}</div>`
          : ""
  }
      </div>
    </body>
    </html>
  `;

  const newWindow = window.open("", "_blank", "width=600,height=400");
  if (newWindow) {
    newWindow.document.write(htmlContent);
    newWindow.document.close();
  } else {
    alert("Popup blocked! Please allow popups for this website.");
  }
}

</script>

<template>
  <aside :class="['event-sidebar', { 'sidebar-visible': isVisible }]">
    <div
        class="preview-container"
        :style="{ backgroundColor: eventDetails.fontStyle?.backgroundColor, // Use the chosen background color
        borderRadius: '8px',}"
    >
      <div class="event-details-section">

        <!---------------- Event Name -------------->
        <h3
            class="event-name-preview shared-preview-style"
            :style="{
      fontFamily: eventDetails.fontStyle?.fontFamily,
      fontWeight: eventDetails.fontStyle?.bold ? 'bold' : 'normal',
      fontStyle: eventDetails.fontStyle?.italic ? 'italic' : 'normal',
      textDecoration: eventDetails.fontStyle?.underline ? 'underline' : 'none',
      color: eventDetails.fontStyle?.color}"
        >
          {{ eventDetails.name || "Event Name" }}
        </h3>

        <!---------------- Date and Time -------------->
        <div class="date-preview shared-preview-style">
          <!-- Always display the date -->
          <div class="date-preview" :style="{
            fontFamily: eventDetails.fontStyle?.fontFamily,
            fontWeight: eventDetails.fontStyle?.bold ? 'bold' : 'normal',
            fontStyle: eventDetails.fontStyle?.italic ? 'italic' : 'normal',
            textDecoration: eventDetails.fontStyle?.underline ? 'underline' : 'none',
            color: eventDetails.fontStyle?.color}"
          >
            {{ formattedDateTime.formattedDate || "Event Date"}} </div>

          <!-- Conditionally display the time -->
          <div
              class="time-preview shared-preview-style"
              :style="{
            fontFamily: eventDetails.fontStyle?.fontFamily,
            fontWeight: eventDetails.fontStyle?.bold ? 'bold' : 'normal',
            fontStyle: eventDetails.fontStyle?.italic ? 'italic' : 'normal',
            textDecoration: eventDetails.fontStyle?.underline ? 'underline' : 'none',
            color: eventDetails.fontStyle?.color}"
          >
            <span v-if="props.displayStartTime && formattedDateTime.formattedStartTime">
             {{ formattedDateTime.formattedStartTime }}
            </span>
                <span v-if="props.displayEndTime && formattedDateTime.formattedEndTime">
                   - {{ formattedDateTime.formattedEndTime }}
                 </span>
          </div>
        </div>

        <!---------------- Event Image -------------->
      <div class="preview-box">
        <img
            v-if="eventDetails.imageUrl"
            :src="eventDetails.imageUrl"
            alt="Selected Preview Image"
            class="preview-image"
        />
        <p v-else class="no-image-text"
           :style="{
                fontFamily: eventDetails.fontStyle?.fontFamily,
                fontWeight: eventDetails.fontStyle?.bold ? 'bold' : 'normal',
                fontStyle: eventDetails.fontStyle?.italic ? 'italic' : 'normal',
                textDecoration: eventDetails.fontStyle?.underline ? 'underline' : 'none',
                color: eventDetails.fontStyle?.color
                }"
        >No image selected</p>
      </div>

        <div class="event-location-preview">
          <!-- Location Name -->
          <div v-if="props.eventDetails.locationName" class="no-image-text"
               :style="{
                fontFamily: eventDetails.fontStyle?.fontFamily,
                fontWeight: eventDetails.fontStyle?.bold ? 'bold' : 'normal',
                fontStyle: eventDetails.fontStyle?.italic ? 'italic' : 'normal',
                textDecoration: eventDetails.fontStyle?.underline ? 'underline' : 'none',
                color: eventDetails.fontStyle?.color
                }"
          >
             {{ props.eventDetails.locationName }}
          </div>

          <!-- Location Address -->
          <div v-if="props.eventDetails.locationAddress" class="location-address"
               :style="{
                fontFamily: eventDetails.fontStyle?.fontFamily,
                fontWeight: eventDetails.fontStyle?.bold ? 'bold' : 'normal',
                fontStyle: eventDetails.fontStyle?.italic ? 'italic' : 'normal',
                textDecoration: eventDetails.fontStyle?.underline ? 'underline' : 'none',
                color: eventDetails.fontStyle?.color
                }"
          >
             {{ props.eventDetails.locationAddress }}
          </div>

          <!-- Map Preview -->
          <div v-if="props.eventDetails.mapImageUrl" class="map-preview">
            <img :src="props.eventDetails.mapImageUrl" alt="Map Preview" />
          </div>
        </div>


        <!---------------- Notes Section -------------->
      <div v-if="eventDetails.note" class="event-note">
        <p
            :style="{
              fontFamily: eventDetails.fontStyle?.fontFamily,
              fontWeight: eventDetails.fontStyle?.bold ? 'bold' : 'normal',
              fontStyle: eventDetails.fontStyle?.italic ? 'italic' : 'normal',
              textDecoration: eventDetails.fontStyle?.underline ? 'underline' : 'none',
               color: eventDetails.fontStyle?.color
    }"
        >
          {{ eventDetails.note }}
        </p>
      </div>
      </div>
    </div>
    <!---------------- View Button -------------->
    <button class="view-button" @click="viewInvitation">View</button>

    <!---------------- Save Button -------------->
    <button class="save-button" @click="handleSave">Save</button>
  </aside>
</template>

<style scoped>

.event-sidebar {
  margin-top: 90px;
  flex-shrink: 0;
  width: 200px;
  max-width: 200px;
  box-sizing: border-box;
  background-color: #083D77; /* Same background as the main sidebar */
  display: flex;
  flex-direction: column;
  align-items: center;
  box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
  transform: translateX(-100%);
  transition: transform 0.3s ease;
}

.sidebar-visible {
  transform: translateX(0);
}

.preview-container {
  width: 100%;
  max-width: 200px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px; /* Adjust spacing between elements */
  overflow: hidden; /* Prevent content overflow */
  padding: 10px; /* Add padding for better spacing */
  box-sizing: border-box; /* Ensure padding doesn't affect width */
}

.shared-preview-style {
  color: #c8ddf8;
  font-size: 16px;
  font-weight: bold;
  white-space: normal;
  word-wrap: break-word;
  overflow-wrap: break-word;
  max-width: 90%;
  overflow: hidden;
  text-align: center;
}

.no-image-text {
  color: #ffffff;
  font-size: 16px;
  text-align: center;
  margin: 0;
}

.preview-image {
  width: 100%; /* Image fills the box horizontally */
  height: 100%; /* Image fills the box vertically */
  object-fit: contain; /* Adjust the scaling to show the entire image */
  border-radius: 8px; /* Match the box's rounded corners */
}
.preview-box {
   width: 100%;
   max-height: 150px;
   aspect-ratio: 1;
   display: flex;
   align-items: center;
   justify-content: center;
   border-radius: 8px;
   overflow: hidden;
   object-fit: cover;
 }

.event-location-preview {
  margin-top: 10px;
  text-align: center;
}

.location-address {
  font-size: 16px;
  color: #666;
}

.event-note {
  font-size: 16px;
  font-weight: normal;
}

.map-preview img {
  width: 100%;
  height: auto;
  border-radius: 8px;
  margin-top: 10px;
}

.view-button {
  margin-top: 10px;
  padding: 10px 20px;
  font-size: 1rem;
  background-color: #007bff;
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s, transform 0.2s;
}

.view-button:hover {
  background-color: #0056b3;
  transform: scale(1.05);
}

.save-button {
  margin-top: auto;
  margin-bottom: 20px;
  padding: 10px 20px;
  font-size: 1rem;
  background-color: #ff6b35;
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s, transform 0.2s;
  width: 80%;
  align-self: center;
}

.save-button:hover {
  background-color: #d9432c;
  transform: scale(1.05);
}

/* Adjustments for small screens */
@media (max-width: 809px) {
  .event-sidebar {
    min-width: 80px;
    max-width: 80px;
  }

  .preview-box {
    max-height: 80px;
  }
}
</style>
