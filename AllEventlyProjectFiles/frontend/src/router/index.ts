import { createRouter, createWebHistory } from 'vue-router';
import Login from '../components/Login.vue';
import Events from '../components/Events.vue';
import Account from "@/components/Account.vue";
import Public from "@/components/Public.vue";
import PasswordReset from "@/components/PasswordReset.vue";
import PasswordUpdate from "@/components/UpdatePassword.vue";

const routes = [
    {
        path: '/',
        name: 'Login',
        component: Login
    },
    {
        path: '/reset-password',
        name: 'PasswordReset',
        component: PasswordReset,
    },
    {
        path: '/update-password',
        name: 'PasswordUpdate',
        component: PasswordUpdate,
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
