let isGoogleMapsScriptLoaded = false;

export const loadGoogleMapsAPI = (apiKey: string): Promise<void> => {
    return new Promise((resolve, reject) => {
        // Check if the script is already loaded
        if (isGoogleMapsScriptLoaded) {
            console.warn("Google Maps API script is already loaded.");
            resolve();
            return;
        }

        if (!apiKey) {
            reject(new Error("Google Maps API key is missing"));
            return;
        }

        // Create the script element
        const script = document.createElement("script");
        script.src = `https://maps.googleapis.com/maps/api/js?key=${apiKey}&libraries=places`;
        script.async = true;
        script.defer = true;

        // Handle script load
        script.onload = () => {
            isGoogleMapsScriptLoaded = true;
            resolve();
        };

        // Handle script error
        script.onerror = () => {
            reject(new Error("Failed to load Google Maps API script"));
        };

        // Append the script to the document head
        document.head.appendChild(script);
    });
};
