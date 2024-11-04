import { createRouter, createWebHistory } from 'vue-router';
import Login from '../components/Login.vue';
import Events from '../components/Events.vue';
import Account from "@/components/Account.vue";
import Public from "@/components/Public.vue";

const routes = [
    {
        path: '/',
        name: 'Login',
        component: Login
    },
    {
        path: '/events',
        name: 'Events',
        component: Events
    },
    {
        path: '/account',
        name: 'Account',
        component: Account
    },
    {
        path: '/public',
        name: 'Public',
        component: Public
    }
];

const router = createRouter({
    history: createWebHistory(),
    routes
});

export default router;
