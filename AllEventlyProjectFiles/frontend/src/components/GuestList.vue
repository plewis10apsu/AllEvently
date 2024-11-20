<script lang="ts">
import TopPanelWithBack from "@/components/TopPanelWithBack.vue";
import logo from "@/assets/AllEventlyLogo.png";

interface Guest {
  id: number;
  firstName: string;
  lastName: string;
  email: string;
  inviteSent: boolean;
  status: string;
  inviteDate: string;
}

export default {
  components: {TopPanelWithBack},
  data() {
    return {
      newGuest: {
        firstName: '',
        lastName: '',
        email: ''
      },
      guests: [
        { id: 1, firstName: 'John', lastName: 'Smith', email: 'johnsmith@gmail.com', inviteSent: true, status: 'Attending', inviteDate: '09/15/2024' },
        { id: 2, firstName: 'Ashley', lastName: 'Williams', email: 'ashley@example.com', inviteSent: false, status: 'Waiting', inviteDate: '' }
      ] as Guest[],
      searchTerm: '',
      selectedGuest: null as Guest | null,
      counts: {
        attending: 1,
        waiting: 1,
        regrets: 0
      }
    };
  },
  computed: {
    logo() {
      return logo
    },
    filteredGuests(): Guest[] {
      return this.guests.filter(guest =>
          `${guest.firstName} ${guest.lastName}`.toLowerCase().includes(this.searchTerm.toLowerCase())
      );
    }
  },
  methods: {
    addGuest() {
      if (this.newGuest.firstName && this.newGuest.lastName && this.newGuest.email) {
        this.guests.push({
          ...this.newGuest,
          id: Date.now(),
          inviteSent: false,
          status: 'Waiting',
          inviteDate: ''
        });
        this.updateCounts();
        this.newGuest = { firstName: '', lastName: '', email: '' };
      }
    },
    viewGuest(guestId: number) {
      this.selectedGuest = this.guests.find(guest => guest.id === guestId) || null;
    },
    sendEmailInvite() {
      if (this.selectedGuest) {
        this.selectedGuest.inviteSent = true;
        this.selectedGuest.inviteDate = new Date().toLocaleDateString();
      }
    },
    markAsAttending() {
      if (this.selectedGuest) {
        this.selectedGuest.status = 'Attending';
        this.updateCounts();
      }
    },
    markAsDeclined() {
      if (this.selectedGuest) {
        this.selectedGuest.status = 'Regrets';
        this.updateCounts();
      }
    },
    saveGuest() {
      if (this.selectedGuest) {
        // Logic to save guest information
        console.log('Guest information saved:', this.selectedGuest);
      }
    },
    deleteGuest() {
      if (this.selectedGuest) {
        this.guests = this.guests.filter(guest => guest.id !== this.selectedGuest!.id);
        this.updateCounts();
        this.selectedGuest = null;
      }
    },
    updateCounts() {
      this.counts.attending = this.guests.filter(guest => guest.status === 'Attending').length;
      this.counts.waiting = this.guests.filter(guest => guest.status === 'Waiting').length;
      this.counts.regrets = this.guests.filter(guest => guest.status === 'Regrets').length;
    }
  }
};
</script>

<template>
  <TopPanelWithBack :logo="logo" />
  <div class="guest-list-container">
    <!-- Row for New Guest and Guest List -->
    <div class="row-container">
      <!-- New Guest Section -->
      <div class="new-guest-section">
        <h2>New Guest</h2>
        <p>Invite someone to your event:</p>
        <form @submit.prevent="addGuest">
          <label for="firstName">First Name</label>
          <input v-model="newGuest.firstName" type="text" id="firstName" required />

          <label for="lastName">Last Name</label>
          <input v-model="newGuest.lastName" type="text" id="lastName" required />

          <label for="email">Email</label>
          <input v-model="newGuest.email" type="email" id="email" required />

          <button type="submit">Add Guest</button>
        </form>
      </div>

      <!-- Guest List Section -->
      <div class="guest-list-section">
        <h2>Guest List</h2>
        <div class="guest-summary">
          <span>Attending: {{ counts.attending }}</span>
          <span>Waiting: {{ counts.waiting }}</span>
          <span>Regrets: {{ counts.regrets }}</span>
        </div>
        <input v-model="searchTerm" placeholder="Search for Guests" />

        <div class="guest-entry" v-for="guest in filteredGuests" :key="guest.id">
          <div class="guest-info">
            <span :class="{ 'sent': guest.inviteSent }">
              {{ guest.firstName }} {{ guest.lastName }}
            </span>
            <span>{{ guest.inviteSent ? 'Invite Sent' : 'Not Sent' }}</span>
          </div>
          <button @click="viewGuest(guest.id)">View</button>
        </div>
      </div>
    </div>

    <!-- Guest Details Section -->
    <div v-if="selectedGuest" class="guest-detail-section">
      <h2>Guest Details</h2>
      <h3>{{ selectedGuest.firstName }} {{ selectedGuest.lastName }}</h3>

      <div class="guest-actions">
        <button @click="sendEmailInvite">Send Email Invite</button>
        <button @click="markAsAttending">Mark As Attending</button>
        <button @click="markAsDeclined">Mark As Declined</button>
      </div>

      <div class="guest-details">
        <p><strong>Invite Sent:</strong> {{ selectedGuest.inviteSent ? selectedGuest.inviteDate : 'Not Sent' }}</p>
        <p><strong>Status:</strong> {{ selectedGuest.status }}</p>

        <label for="firstName">First Name</label>
        <input v-model="selectedGuest.firstName" type="text" id="firstName" />

        <label for="lastName">Last Name</label>
        <input v-model="selectedGuest.lastName" type="text" id="lastName" />

        <label for="email">Email</label>
        <input v-model="selectedGuest.email" type="email" id="email" />

        <div class="detail-buttons">
          <button @click="deleteGuest">Delete</button>
          <button @click="saveGuest">Save</button>
        </div>
      </div>
    </div>
  </div>
</template>


<style scoped>

h2 {
  color: #083D77; /* Heading color */
  font-size: 1.5rem;
  margin-bottom: 10px;
}

p {
  color: #0D1821; /* Text color */
}

/* Row container for New-Guest and Guest-List */
.row-container {
  display: flex;
  flex-direction: row; /* Align items horizontally */
  justify-content: space-between; /* Add space between the two sections */
  gap: 24px; /* Add spacing between the two sections */
  flex-wrap: wrap; /* Ensure responsiveness on smaller screens */
}

.guest-list-container {
  margin-top: 90px;
  display: flex;
  flex-direction: column; /* Stack sections vertically */
  gap: 24px; /* Add spacing between sections */
  padding: 20px;
  background-color: #F7E1D7;
  border-radius: 8px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  height: 84vh; /* Full viewport height */
  overflow-y: auto; /* Enable scrolling for the entire page */
}

/* Row container for New-Guest and Guest-List */
.row-container {
  display: flex;
  flex-direction: row; /* Align items horizontally */
  justify-content: space-between; /* Add space between the */
}

/* New Guest Section */
  .new-guest-section {
    min-width: 300px;
    flex: 0 0 auto; /* Prevent this section from growing */
    width: 300px; /* Fixed width */
    background-color: #FFF;
    border: 2px solid #1A659E;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  }

/* Guest List Section */
.guest-list-section {
  flex: 1; /* Allow this section to take up remaining space */
  min-width: 300px; /* Match the width of the New Guest section */
  background-color: #FFF;
  border: 2px solid #1A659E;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}


/* Guest Details Section */
  .guest-detail-section {
    min-width: 300px;
    background-color: #FFF;
    border: 2px solid #1A659E;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  }

label {
  display: block;
  font-weight: bold;
  margin-top: 10px;
  margin-bottom: 5px;
  color: #0D1821;
}

input {
  width: 100%; /* Make input fields responsive within the container */
  max-width: 400px; /* Set a maximum width for the input fields */
  margin-bottom: 15px; /* Add spacing between inputs */
  padding: 8px;
  border: 1px solid #1A659E;
  border-radius: 4px;
  font-size: 1rem;
}

input:focus {
  outline: none;
  border-color: #083D77;
  box-shadow: 0 0 4px rgba(0, 0, 0, 0.2);
}

.guest-summary span {
  color: #1A659E;
  font-weight: bold;
  margin-right: 20px;
}

.guest-entry {
  display: flex;
  justify-content: space-between;
  padding: 10px 0;
  border-bottom: 1px solid #ccc;
}

.guest-info {
  display: flex;
  flex-direction: column;
}

.guest-info span {
  color: #0D1821;
}

.sent {
  font-weight: bold;
}

button {
  background-color: #FF6B35; /* Primary button color */
  color: #FFF;
  border: none;
  padding: 10px 16px;
  border-radius: 5px;
  font-size: 1rem;
  font-weight: bold;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

button:hover {
  background-color: #E63946; /* Hover effect */
}

.guest-actions {
  display: flex;
  gap: 10px;
  margin-bottom: 15px;
}

.guest-actions button {
  background-color: #FAC55A; /* Secondary button color */
  color: #0D1821;
}

.guest-actions button:hover {
  background-color: #FF6B35;
  color: #FFF;
}

.detail-buttons button {
  background-color: #083D77;
  color: #FFF;
}

.detail-buttons button:hover {
  background-color: #1A659E;
}

.detail-buttons {
  display: flex;
  gap: 10px;
  margin-top: 15px;
}
</style>
