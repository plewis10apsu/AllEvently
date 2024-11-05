<script>
export default {
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
      ],
      searchTerm: '',
      selectedGuest: null,
      counts: {
        attending: 1,
        waiting: 1,
        regrets: 0
      }
    };
  },
  computed: {
    filteredGuests() {
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
        this.newGuest = {firstName: '', lastName: '', email: ''};
      }
    },
    viewGuest(guestId) {
      this.selectedGuest = this.guests.find(guest => guest.id === guestId);
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
      // Logic to save guest information
      console.log('Guest information saved:', this.selectedGuest);
    },
    deleteGuest() {
      this.guests = this.guests.filter(guest => guest.id !== this.selectedGuest.id);
      this.updateCounts();
      this.selectedGuest = null;
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
  <div class="guest-list-container">
    <!-- New Guest Section -->
    <div class="new-guest-section">
      <h2>New Guest</h2>
      <p>Let's invite someone!</p>
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
        <span>Attending {{ counts.attending }}</span>
        <span>Waiting {{ counts.waiting }}</span>
        <span>Regrets {{ counts.regrets }}</span>
      </div>
      <input v-model="searchTerm" placeholder="Search for Guests" />

      <div class="guest-entry" v-for="guest in filteredGuests" :key="guest.id">
        <div class="guest-info">
          <span :class="{ 'sent': guest.inviteSent }">
            {{ guest.firstName }} {{ guest.lastName }}
          </span>
          <span>{{ guest.inviteSent ? 'Sent' : 'Not Sent' }}</span>
        </div>
        <button @click="viewGuest(guest.id)">View</button>
      </div>
    </div>

    <!-- Detailed Guest View Section -->
    <div v-if="selectedGuest" class="guest-detail-section">
      <h2>Guest Information</h2>
      <h3>{{ selectedGuest.firstName }} {{ selectedGuest.lastName }}</h3>

      <div class="guest-actions">
        <button @click="sendEmailInvite">Email Invite</button>
        <button @click="markAsAttending">Mark As Attending</button>
        <button @click="markAsDeclined">Mark As Declined</button>
      </div>

      <div class="guest-details">
        <p><strong>Invite Sent:</strong> {{ selectedGuest.inviteSent ? selectedGuest.inviteDate : 'Not Sent' }}</p>
        <p><strong>Responded:</strong> {{ selectedGuest.status }}</p>

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
.guest-list-container {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.new-guest-section,
.guest-list-section,
.guest-detail-section {
  border: 1px solid #ddd;
  padding: 20px;
  border-radius: 8px;
}

.guest-summary span {
  margin-right: 15px;
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

.sent {
  font-weight: bold;
}

button {
  background-color: #007bff;
  color: #fff;
  border: none;
  border-radius: 5px;
  padding: 5px 10px;
  cursor: pointer;
}

button:hover {
  background-color: #0056b3;
}

.guest-actions {
  display: flex;
  gap: 10px;
  margin-bottom: 15px;
}

.detail-buttons {
  display: flex;
  gap: 10px;
  margin-top: 15px;
}
</style>
