import { createApp } from 'vue'
import App from './App.vue'
import router from './router';
import vue3GoogleLogin from 'vue3-google-login';
import { library } from '@fortawesome/fontawesome-svg-core';
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';
import { faBars, faTimes } from '@fortawesome/free-solid-svg-icons';
import { faUser, faUsers, faCalendarAlt, faRightFromBracket } from '@fortawesome/free-solid-svg-icons';

// Add icons
library.add(faBars, faTimes, faUser, faUsers, faCalendarAlt, faRightFromBracket);

const app = createApp(App);

app.component('FontAwesomeIcon', FontAwesomeIcon);

// Use the Google Login Plugin
app.use(vue3GoogleLogin, {
    clientId:'545474980671-5e1eoafiqoiic7tog5tpd4ih37f05i5u.apps.googleusercontent.com'
});

app.use(router);

app.mount('#app');
