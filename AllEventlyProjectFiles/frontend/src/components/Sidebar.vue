<script setup lang="ts">
import { defineProps, PropType } from 'vue';
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';
import router from "@/router";

type NavItem = {
  label: string;
  path: string;
  icon: string;
};

defineProps({
  isVisible: {
    type: Boolean,
    default: true,
  },
  navItems: {
    type: Array as PropType<NavItem[]>,
    default: () => [
      { label: 'Account', path: '/account', icon: ['fas', 'user'] },
      { label: 'Public Events', path: '/public', icon: ['fas', 'users'] },
      { label: 'Events', path: '/events', icon: ['fas', 'calendar-alt'] },
      { label: 'Logout', path: '/', icon: ['fas', 'right-from-bracket'] },
    ],
  },
});

const navigateTo = (path: string) => {
  router.push(path);
};
</script>

<template>
  <aside :class="['sidebar', { 'sidebar-visible': isVisible }]">
    <nav class="navigation">
      <button v-for="item in navItems" :key="item.label" @click="navigateTo(item.path)" class="nav-button">
        <FontAwesomeIcon :icon="item.icon" class="nav-icon" />
        <span class="nav-label">{{ item.label }}</span>
      </button>
    </nav>
  </aside>
</template>

<style scoped>

.sidebar {
  margin-top: 90px;
  flex-shrink: 0;
  min-width: 200px;
  box-sizing: border-box;
  background-color: #083D77;
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

.nav-button {
  background: none;
  border: none;
  color: white;
  font-size: 1.2rem;
  padding: 10px 20px;
  margin: 10px 0;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 10px;
  width: 100%;
}

.nav-button:hover {
  background-color: #1B6CA8;
  border-radius: 5px;
}

.nav-icon {
  font-size: 1.5rem;
}

.nav-label {
  flex-grow: 1;
}

/* Adjustments for small screens */
@media (max-width: 809px) {
  .events-content {
    transition: margin-left 0.3s ease;
  }
  .sidebar{
    min-width: 80px;
    max-width: 80px;
  }
  .nav-label {
    display: none;
  }

  .nav-icon {
    font-size: 1.8rem; /* Optionally, make the icon slightly larger */
  }

  .nav-button {
    justify-content: center; /* Center the icon in the button */
  }
}
</style>
