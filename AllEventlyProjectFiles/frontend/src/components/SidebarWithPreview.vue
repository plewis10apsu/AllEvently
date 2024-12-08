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
  };
}>();
const eventDetails = computed(() => props.eventDetails);
const isVisible = ref(true);
const emit = defineEmits(["save"]); // Emit save event

function handleSave() {
  emit("save");
}

const formattedDateTime = computed(() => {
  if (!props.eventDetails.date || !props.eventDetails.time) {
    return {
      formattedDate: "",
      formattedStartTime: "",
      formattedEndTime: "",
    };
  }

  const startDate = new Date(`${props.eventDetails.date}T${props.eventDetails.time}`);
  const endDate = props.eventDetails.endTime
      ? new Date(`${props.eventDetails.date}T${props.eventDetails.endTime}`)
      : null;

  const formattedDate = new Intl.DateTimeFormat("en-US", {
    month: "long",
    day: "numeric",
    year: "numeric",
  }).format(startDate);

  const formattedStartTime = new Intl.DateTimeFormat("en-US", {
    hour: "numeric",
    minute: "numeric",
    hour12: true,
  }).format(startDate);

  const formattedEndTime = endDate
      ? new Intl.DateTimeFormat("en-US", {
        hour: "numeric",
        minute: "numeric",
        hour12: true,
      }).format(endDate)
      : "";

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

  if (!details.date || !details.time) {
    alert("Event date and time are required.");
    return;
  }

  // Format the date and time
  const {formattedDate, formattedStartTime, formattedEndTime} = formattedDateTime.value;

  // Explicitly define the type of fontStyle and provide default values
  const fontStyle: {
    fontFamily: string;
    fontSize: number;
    bold: boolean;
    italic: boolean;
    underline: boolean;
    color: string;
    backgroundColor: string;
  } = {
    fontFamily: details.fontStyle?.fontFamily || "Arial",
    fontSize: details.fontStyle?.fontSize || 48,
    bold: details.fontStyle?.bold || false,
    italic: details.fontStyle?.italic || false,
    underline: details.fontStyle?.underline || false,
    color: details.fontStyle?.color || "#000000",
    backgroundColor: details.fontStyle?.backgroundColor || "#ffffff", // Include background color
  };

  const htmlContent = `
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <link href="https://fonts.googleapis.com/css2?family=Great+Vibes&family=Pacifico&family=Allura&family=Satisfy&display=swap" rel="stylesheet">
      <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@100;200;300;400;500;600;700&display=swap" rel="stylesheet">
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Event Invitation</title>
      <style>
        body {
          margin: 0;
          padding: 0;
          display: flex;
          align-items: center;
          justify-content: center;
          height: 100vh;
        }
        .invitation {
          width: 600px;
          height: 400px;
          position: relative;
          background-color: white;
          overflow: hidden;
          border: 1px solid #ccc;
          border-radius: 10px;
        }
        .invitation img {
          width: 100%;
          height: 100%;
          object-fit: cover;
        }
        .invitation-text {
          position: absolute;
          top: 20%;
          left: 10%;
          font-family: ${fontStyle.fontFamily};
          color: ${fontStyle.color};
          font-size: ${fontStyle.fontSize}px;
          font-weight: ${fontStyle.bold ? "bold" : "normal"};
          font-style: ${fontStyle.italic ? "italic" : "normal"};
          text-decoration: ${fontStyle.underline ? "underline" : "none"};
          background-color: ${fontStyle.backgroundColor};
          padding: 10px;
          border-radius: 5px;
        }
        .date-view {
          margin-bottom: 10px;
          font-size: 18px;
          font-weight: bold;
        }
        .time-view {
          font-size: 16px;
        }
      </style>
    </head>
    <body>
      <div class="invitation">
        <img src="${details.imageUrl || ''}" alt="Invitation Background">
        <div class="invitation-text">
          <h1>${details.name || "Event Name"}</h1>
          <div class="date-view">${formattedDate}</div>
          <div class="time-view">${formattedStartTime}${formattedEndTime ? ` - ${formattedEndTime}` : ""}</div>
          <p>${details.note || ""}</p>
        </div>
      </div>
    </body>
    </html>
  `;

  const newWindow = window.open("", "_blank", "width=800,height=600");
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
        :style="{
    backgroundColor: eventDetails.fontStyle?.backgroundColor, // Use the chosen background color
    padding: '10px',
    borderRadius: '8px',
  }"
    >

      <div class="event-details-section">
        <h3
            class="event-name-preview"
            :style="{
      fontFamily: eventDetails.fontStyle?.fontFamily,
      fontWeight: eventDetails.fontStyle?.bold ? 'bold' : 'normal',
      fontStyle: eventDetails.fontStyle?.italic ? 'italic' : 'normal',
      textDecoration: eventDetails.fontStyle?.underline ? 'underline' : 'none',
      color: eventDetails.fontStyle?.color
    }"
        >
          {{ eventDetails.name || "Event Name" }}
        </h3>
        <!-- Date and Time -->
        <div class="event-date-time-preview">
          <div
              class="date-preview"
              :style="{ fontFamily: eventDetails.fontStyle?.fontFamily }"
          >
            {{ formattedDateTime.formattedDate }}
          </div>
          <div
              class="time-preview"
              :style="{ fontFamily: eventDetails.fontStyle?.fontFamily }"
          >
            {{ formattedDateTime.formattedStartTime }}
            <span v-if="formattedDateTime.formattedEndTime">
      - {{ formattedDateTime.formattedEndTime }}
    </span>
          </div>
        </div>
      <!-- Show the selected image if available -->
      <div class="preview-box">
        <img
            v-if="eventDetails.imageUrl"
            :src="eventDetails.imageUrl"
            alt="Selected Preview Image"
            class="preview-image"
        />
        <p v-else>No image selected</p>
      </div>
      <!-- Notes Section -->
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
    <!-- View Button -->
    <button class="view-button" @click="viewInvitation">View</button>

    <!-- Save Button -->
    <button class="save-button" @click="handleSave">Save</button>
  </aside>
</template>

<style scoped>

.event-sidebar {
  margin-top: 90px;
  flex-shrink: 0;
  min-width: 200px;
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
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 20px;
  padding: 20px 0;
}

.event-name-preview {
  color: #c8ddf8;
  font-size: 20px;
  font-weight: bold;
}

.date-preview {
  font-size: 20px;
  font-weight: bold;
}

.time-preview {
  font-size: 20px;
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
   background-color: #add8e6;
   display: flex;
   align-items: center;
   justify-content: center;
   border-radius: 8px;
   overflow: hidden;
   object-fit: cover;
 }

.event-note {
  font-size: 20px;
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

  .event-name-preview,
  .event-details-preview {
    display: none; /* Hide text content on smaller screens */
  }

  .preview-box {
    max-height: 80px;
  }
}
</style>
