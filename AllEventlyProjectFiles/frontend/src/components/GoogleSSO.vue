<script setup lang="ts">
import { ref, onMounted, defineProps } from 'vue';

const props = defineProps({
  buttonText: {
    type: String,
    default: 'Sign In with Google',
  },
});

declare const google: any;
const googleButtonRef = ref(null);

onMounted(() => {
  const loadGoogleScript = () => {
    if (typeof google === 'undefined') {
      const script = document.createElement('script');
      script.src = 'https://accounts.google.com/gsi/client';
      script.async = true;
      script.defer = true;
      script.onload = () => initializeGoogleSignIn();
      document.head.appendChild(script);
    } else {
      initializeGoogleSignIn();
    }
  };

  const initializeGoogleSignIn = () => {
    if (googleButtonRef.value) {
      google.accounts.id.initialize({
        client_id: '545474980671-5e1eoafiqoiic7tog5tpd4ih37f05i5u.apps.googleusercontent.com',
        callback: (response: any) => {
          console.log('Google ID Token:', response.credential);
          // Handle the response, e.g., send token to your backend
        },
      });
      google.accounts.id.renderButton(googleButtonRef.value, {
        theme: 'outline',
        size: 'large',
        type: 'icon',
        shape: 'pill',
        logo_alignment: 'center',
        width: '250',
      });
    }
  };

  loadGoogleScript();
});
</script>

<template>
  <label>{{ props.buttonText }}</label>
  <div ref="googleButtonRef"></div>
</template>
