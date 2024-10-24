import { createRouter, createWebHistory } from 'vue-router';
import Login from '../components/Login.vue';
import Events from '../components/Events.vue';

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
    }
];

const router = createRouter({
    history: createWebHistory(),
    routes
});

export default router;
