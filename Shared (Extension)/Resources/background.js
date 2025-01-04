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

browser.runtime.onMessage.addListener(async (message, sender, sendResponse) => {
  console.log("=== Background Message Received ===");
  console.log("Message:", message);
  console.log("Sender:", sender);

  if (message.name === "getBlockedUrls") {
    try {
      console.log("Fetching blocked URLs...");
      const blockedUrls = await getBlockedUrls();
      console.log("Fetched blocked URLs:", blockedUrls);

      const response = {
        name: "blockedUrls",
        urls: blockedUrls,
      };
      console.log("Sending response to content script:", response);

      await browser.tabs.sendMessage(sender.tab.id, response);
      console.log("Response sent successfully");
    } catch (error) {
      console.error("Error in background script:", error);
      console.error("Stack:", error.stack);
      browser.tabs.sendMessage(sender.tab.id, {
        name: "blockedUrls",
        urls: [],
      });
    }
  }
});
