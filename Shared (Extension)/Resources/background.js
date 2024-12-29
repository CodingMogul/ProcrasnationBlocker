console.log("Safari Background Service Worker initialized.");

// Function to send a message to the extension handler to get blocked URLs
function getBlockedUrls() {
    console.log("Fetching blocked URLs from extension handler...");
    return new Promise((resolve, reject) => {
        safari.extension.dispatchMessage("getBlockedSites", {}, (response) => {
            if (response && response.blockedSites) {
                console.log("Blocked URLs received:", response.blockedSites);
                resolve(response.blockedSites);
            } else {
                console.error("Failed to retrieve blocked URLs.");
                reject("Failed to retrieve blocked URLs");
            }
        });
    });
}

// Event listener for messages from the Safari extension
if (typeof safari !== "undefined" && safari.application) {
    console.log("Setting up Safari application event listener...");
    safari.application.addEventListener("message", async (event) => {
        console.log("Message received in background script:", event.name);

        if (event.name === "getBlockedUrls") {
            try {
                console.log("Processing 'getBlockedUrls' message...");
                // Wait for the blocked URLs to be retrieved
                const blockedUrls = await getBlockedUrls();
                console.log("Blocked URLs retrieved successfully:", blockedUrls);

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
