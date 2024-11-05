import { createRouter, createWebHistory } from 'vue-router';
import Login from '../components/Login.vue';
import PasswordReset from "@/components/PasswordReset.vue";
import UpdatePassword from "@/components/UpdatePassword.vue";
import Events from '../components/Events.vue';
import Chat from "@/components/Chat.vue";
import Account from "@/components/Account.vue";
import Public from "@/components/Public.vue";

const routes = [
    {
        path: '/',
        name: 'Login',
        component: Login
    },
    {
        path: '/password-reset',
        name: 'PasswordReset',
        component: PasswordReset,
    },
    {
        path: '/update-password',
        name: 'UpdatePassword',
        component: UpdatePassword,
    },
    {
        path: '/events',
        name: 'Events',
        component: Events
    },
    {
        path: '/chat/:eventId',
        name: 'Chat',
        component: Chat,
        props: true, // Allows route params to be passed as props
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
