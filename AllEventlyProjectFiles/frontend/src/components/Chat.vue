<script setup lang="ts">
import {ref, onMounted, onUpdated} from 'vue';
import TopPanelWithBack from "@/components/TopPanelWithBack.vue";
import logo from "@/assets/AllEventlyLogo.png";

// Use defineProps directly without re-declaring it
const { eventId } = defineProps<{ eventId: string }>();

// Placeholder for event name (replace with actual data-fetching logic)
const eventName = ref('');

// Simulate fetching the event name based on eventId
// Replace this with actual API call or data retrieval logic
onMounted(() => {
  if (eventId === '1') {
    eventName.value = 'Jonie\'s Birthday';
  } else {
    eventName.value = 'Unknown Event';
  }
});

onUpdated(() => {
  const chatMessagesContainer = document.querySelector('.chat-messages');
  if (chatMessagesContainer) {
    chatMessagesContainer.scrollTop = chatMessagesContainer.scrollHeight;
  }
});

// Messages for display
const messages = ref([
  { sender: 'Me', time: '09/11/2024 10:35 AM', text: "Hi Alice! I’m so excited! I was just about to ask if there’s anything I should bring? 🎁" },
  { sender: 'Alice', time: '09/11/2024 10:37 AM', text: "That’s so sweet of you! Just your wonderful presence will be enough, but Suzie does love balloons if you want to bring a small surprise. 🎈", isHostOnly: true },
  { sender: 'Me', time: '09/11/2024 10:35 AM', text: "Perfect, I’ll bring some colorful balloons then. Can’t wait to celebrate! 🥳" }
]);

const newMessage = ref('');

function sendMessage() {
  if (newMessage.value.trim() !== '') {
    messages.value.push({
      sender: 'Me',
      time: new Date().toLocaleString(),
      text: newMessage.value,
      isHostOnly: false
    });
    newMessage.value = '';
  }
}
</script>

<template>
  <TopPanelWithBack :logo="logo" />
  <div class="chat-page">
    <header class="chat-header">
      <h2>Chat for: {{ eventName }}</h2>
    </header>
    <div class="chat-messages">
      <div
          v-for="(message, index) in messages"
          :key="index"
          :class="['message', { 'host': message.isHostOnly, 'me': message.sender === 'Me', 'other-user': message.sender !== 'Me' }]">
        <div class="message-info" :class="{ 'align-right': message.sender === 'Me' }">
          <strong>{{ message.sender }}</strong>
          <span class="message-time">{{ message.time }}</span>
        </div>
        <div class="message-content">
          {{ message.text }}
        </div>
      </div>
    </div>
    <div class="chat-input-container">
      <input type="text" v-model="newMessage" placeholder="Type your message..." />
      <button @click="sendMessage">Send</button>
    </div>
  </div>
</template>

<style scoped>
.chat-page {
  margin-top: 90px;
  display: flex;
  flex-direction: column;
  background-color: #f4f4f9;
  height: 89vh;
}

.chat-header {
  padding: 10px;
  background-color: #FAC55A;
  color: #0D1821;
  text-align: center;
}

.chat-messages {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow-y: auto;
  margin-top: 10px;
}

.message {
  display: inline-block;
  max-width: 75%;
  min-width: 10%;
  margin-bottom: 10px;
  padding: 10px 15px;
  border-radius: 8px;
  background-color: #e0e0e0;
  font-size: 1.1rem;
  word-wrap: break-word;
}

.message-info {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  font-size: 1.2rem;
  margin-bottom: 5px;
}

.message-info.align-right {
  align-items: flex-end; /* Alignment for the current user ("Me") */
}

.message-content {
  font-size: 1.6rem;
  line-height: 1.4;
}

.message.host {
  border: 2px solid #4caf50;
}

.message.other-user {
  background-color: #e0e0e0;
  width: auto; /* Allows the bubble to shrink based on content */
}

.message.me {
  background-color: #1A659E;
  color: white;
  align-self: flex-end; /* Aligns the user's message to the right */
}

.message-info strong {
  font-size: 1.5rem;
  margin-bottom: 2px;
}

.chat-input-container {
  display: flex;
  padding: 15px;
  border-top: 1px solid #ddd;
}

.chat-input-container input {
  flex: 1;
  padding: 12px;
  font-size: 1.2rem;
  border: 1px solid #ccc;
  border-radius: 4px;
}

.chat-input-container button {
  margin-left: 10px;
  padding: 12px 18px;
  font-size: 1.2rem;
  background-color: #007bff;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.chat-input-container button:hover {
  background-color: #0056b3;
}
</style>
