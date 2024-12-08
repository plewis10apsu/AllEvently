import { createRouter, createWebHistory } from 'vue-router';
import Login from '../components/Login.vue';
import PasswordReset from "@/components/PasswordReset.vue";
import UpdatePassword from "@/components/UpdatePassword.vue";
import Events from '../components/Events.vue';
import Chat from "@/components/Chat.vue";
import Account from "@/components/Account.vue";
import Public from "@/components/Public.vue";
import GuestList from "@/components/GuestList.vue";
import EventCreation from "@/components/EventCreation.vue";
import Invitation from "@/components/Invitation.vue";

const routes = [
    {
        path: '/',
        name: 'Login',
        component: Login
    },
    {
        path: '/password-reset',
        name: 'PasswordReset',
        component: PasswordReset
    },
    {
        path: '/update-password',
        name: 'UpdatePassword',
        component: UpdatePassword
    },
    {
        path: '/events/:userId',
        name: 'Events',
        component: Events,
        props: true,
    },
    {
        path: '/event-creation',
        name: 'EventCreation',
        component: EventCreation
    },
    {
        path: '/guest-list',
        name: 'GuestList',
        component: GuestList
    },
    {
        path: '/invitation/:eventId',
        name: 'Invitation',
        component: Invitation,
        props: true,
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
        component: Account,
        props: true,
    },
    {
        path: '/public',
        name: 'Public',
        component: Public,
        props: true,
    }
];

const router = createRouter({
    history: createWebHistory(),
    routes
});

export default router;
