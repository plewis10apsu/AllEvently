<script setup lang="ts">
import { defineProps } from 'vue';

// Define props
defineProps({
  eventName: { type: String, required: true },
  venue: { type: String, required: true },
  address: { type: String, required: true },
  googleMapLink: { type: String, required: true },
  date: { type: String, required: true },
  time: { type: String, required: true },
  headline: { type: String, required: true },
  rsvpStatus: { type: String, required: true },
  rsvpClass: { type: String, required: true },
  chatLink: { type: String, required: true },
  hostName: { type: String, required: true },
  hostLink: { type: String, required: true },
  wishListLink: { type: String, required: true },
  hostNotes: { type: String, default: "" },
  backgroundImage: { type: String, required: true },
});

// Define a method for RSVP button click
function onRSVPClick() {
  console.log("RSVP button clicked!");
}
</script>t>

// "{ backgroundImage: `url(${backgroundImage})` }"

<template>
  <div class="invitation-container">
    <div class="background-image" :style="{ backgroundImage: `url(${backgroundImage})` }">
      <div class="invitation-content">
        <h1 class="event-title">Lisa's Baby Shower</h1>
        <p class="event-details">
          Wilma Rudolph Event Center<br>
          8 Champion's Wy, Clarksville TN, 37042<br>
          <iframe
              src="https://www.google.com/maps/embed?pb=..."
              class="google-map"
              allowfullscreen>
          </iframe>
        </p>
        <h2 class="message">WE ARE HAVING A BABY</h2>
        <div class="event-info">
          <p>Sat, Oct 5, 2024<br>3PM - 5PM CDT</p>
          <p>Current RSVP: <span class="rsvp-status">You Haven't Responded Yet</span></p>
        </div>
        <div class="links">
          <a href="/chat" class="link">Open the Chat</a>
          <a href="/host-info" class="link">Hosted by: Mary Johnson</a>
          <a href="/wish-list" class="link">My Wish List</a>
        </div>
        <div class="host-notes">
          <strong>Note From the Host:</strong>
          <p>
            We are looking forward to celebrating with everyone. Bring a friend to have some fun. Wear pink if you think the baby is a girl, or blue for a boy.
          </p>
        </div>
        <button class="rsvp-button" @click="onRSVPClick">RSVP</button>
      </div>
    </div>
  </div>
</template>

<style scoped>
body {
  margin: 0;
  font-family: Arial, sans-serif;
  background-color: #f5f5f5;
}

.invitation-container {
  background-size: cover;
  background-position: center;
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
}

.background-image {
  width: 100%;
  height: 100%;
  background-size: cover !important;
  background-position: center !important;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 20px;
}

.invitation-content {
  background-color: rgba(255, 255, 255, 0.9);
  padding: 20px;
  border-radius: 10px;
  max-width: 600px;
  text-align: center;
}

.event-title {
  font-family: 'Cursive', sans-serif;
  font-size: 2.5em;
  margin-bottom: 10px;
}

.event-details {
  margin: 10px 0;
  font-size: 1.1em;
}

.google-map {
  width: 100%;
  height: 150px;
  border: none;
  margin-top: 10px;
}

.message {
  font-size: 1.8em;
  margin: 20px 0;
}

.event-info {
  font-size: 1em;
  margin: 15px 0;
}

.rsvp-status {
  font-weight: bold;
  color: red;
}

.links {
  margin: 15px 0;
}

.links .link {
  display: block;
  margin: 5px 0;
  color: blue;
  text-decoration: underline;
  cursor: pointer;
}

.host-notes {
  font-size: 0.9em;
  margin: 15px 0;
}

.rsvp-button {
  background-color: #87ceeb;
  color: white;
  border: none;
  padding: 10px 20px;
  font-size: 1em;
  cursor: pointer;
  border-radius: 5px;
}

.rsvp-button:hover {
  background-color: #4682b4;
}

</style>