console.log("Safari Background Service Worker initialized.");

// Function to get blocked URLs from extension handler
function getBlockedUrls() {
  console.log("=== getBlockedUrls called ===");
  return new Promise((resolve, reject) => {
    const message = { message: "getBlockedSites" };
    console.log("Sending message to native handler:", message);

    browser.runtime.sendNativeMessage(message, (response) => {
      console.log("=== Native Response ===");
      console.log("Raw response:", response);
      console.log("Response type:", typeof response);
      console.log("Response keys:", response ? Object.keys(response) : "null");

      if (response && response.message) {
        console.log("Message content:", response.message);
        if (response.message.blockedSites) {
          console.log("Found blocked sites:", response.message.blockedSites);
          resolve(response.message.blockedSites);
        } else {
          console.error("No blockedSites in message");
          console.log(
            "Message structure:",
            JSON.stringify(response.message, null, 2)
          );
          resolve([]);
        }
      } else {
        console.error("Unexpected response format");
        console.log("Full response:", JSON.stringify(response, null, 2));
        resolve([]);
      }
    });
  });
}

// Function to get blocking configuration
function getBlockingConfig() {
  console.log("=== getBlockingConfig called ===");
  return new Promise((resolve, reject) => {
    const message = { message: "getBlockingConfig" };
    console.log("Sending config request to native handler:", message);

    browser.runtime.sendNativeMessage(message, (response) => {
      console.log("=== Config Response ===");
      console.log("Raw config response:", response);

      if (response && response.message) {
        console.log("Config received:", response.message);
        resolve(response.message);
      } else {
        console.error("Invalid config response format");
        resolve({
          removeVideos: false,
          removeImages: false,
          removeGoogleAds: false,
        });
      }
    });
  });
}

// Listen for messages from content scripts
browser.runtime.onMessage.addListener(async (message, sender, sendResponse) => {
  console.log("Background script received message:", message);

  if (message.name === "getBlockedUrls") {
    try {
      const blockedUrls = await getBlockedUrls();
      console.log("Retrieved blocked URLs:", blockedUrls);

      if (blockedUrls && blockedUrls.length > 0) {
        console.log("Sending non-empty blockedUrls to content script");
      } else {
        console.log("Warning: Empty blockedUrls array");
      }

      browser.tabs
        .sendMessage(sender.tab.id, {
          name: "blockedUrls",
          urls: blockedUrls,
        })
        .then(() => {
          console.log("Message sent to content script with URLs:", blockedUrls);
        })
        .catch((error) => {
          console.error("Error sending message to content script:", error);
        });
    } catch (error) {
      console.error("Error in background script:", error);
      browser.tabs.sendMessage(sender.tab.id, {
        name: "blockedUrls",
        urls: [],
      });
    }
  } else if (message.name === "getBlockingConfig") {
    try {
      const config = await getBlockingConfig();
      console.log("Retrieved blocking config:", config);
      return Promise.resolve(config);
    } catch (error) {
      console.error("Error getting blocking config:", error);
      return Promise.resolve({
        removeVideos: false,
        removeImages: false,
        removeGoogleAds: false,
      });
    }
  }
});
