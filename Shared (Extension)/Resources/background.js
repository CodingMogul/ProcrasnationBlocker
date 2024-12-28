console.log("Safari Background Service Worker initialized.");

// Function to send a message to the extension handler to get blocked URLs
function getBlockedUrls() {
    return new Promise((resolve, reject) => {
        safari.extension.dispatchMessage("getBlockedSites", {}, (response) => {
            if (response && response.blockedSites) {
                resolve(response.blockedSites);
            } else {
                reject("Failed to retrieve blocked URLs");
            }
        });
    });
}

// Event listener for messages from the Safari extension
if (typeof safari !== "undefined" && safari.application) {
    safari.application.addEventListener("message", async (event) => {
        console.log("Message received in background script:", event.name);

        if (event.name === "getBlockedUrls") {
            try {
                // Wait for the blocked URLs to be retrieved
                const blockedUrls = await getBlockedUrls();
                console.log("Blocked URLs retrieved:", blockedUrls);

                // Send the blocked URLs back to the content script
                event.target.page.dispatchMessage("blockedUrls", { urls: blockedUrls });
            } catch (error) {
                console.error("Error retrieving blocked URLs:", error);
                event.target.page.dispatchMessage("blockedUrls", { urls: [] }); // Send an empty list on error
            }
        } else {
            console.error("Unknown message type received:", event.name);
        }
    });
} else {
    console.error("Safari application object not available.");
}
