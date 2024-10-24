import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import router from './router';
import vue3GoogleLogin from 'vue3-google-login';

const app = createApp(App);

// Use the Google Login Plugin
app.use(vue3GoogleLogin, {
    clientId:'545474980671-5e1eoafiqoiic7tog5tpd4ih37f05i5u.apps.googleusercontent.com'
});

app.use(router);

app.mount('#app');
