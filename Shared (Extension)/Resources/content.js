console.log("Content script initialized!");

// Redirect URL
const redirectUrl = "https://procrastinationblocker.com/remind";

// Function to check if the current URL matches any blocked sites
function isUrlBlocked(blockedUrls, currentUrl) {
  console.log("=== URL Check ===");
  console.log("Checking URL:", currentUrl);
  console.log("Against blocked URLs:", blockedUrls);

  if (!blockedUrls || blockedUrls.length === 0) {
    console.warn("No blocked URLs provided!");
    return false;
  }

  return blockedUrls.some((blockedUrl) => {
    const normalizedBlockedUrl = blockedUrl.toLowerCase();
    const normalizedCurrentUrl = currentUrl.toLowerCase();
    const isBlocked = normalizedCurrentUrl.includes(normalizedBlockedUrl);
    console.log(
      `Checking ${normalizedBlockedUrl} against ${normalizedCurrentUrl}: ${isBlocked}`
    );
    return isBlocked;
  });
}

// Function to request blocked URLs from background script
function requestBlockedUrls() {
  console.log("=== Requesting Blocked URLs ===");
  try {
    browser.runtime.sendMessage({ name: "getBlockedUrls" }).catch((error) => {
      console.error("Error sending message to background script:", error);
    });
  } catch (error) {
    console.error("Error in requestBlockedUrls:", error);
  }
}

// Function to block the website
function blockWebsite() {
  console.log("=== Blocking Website ===");
  try {
    document.body.innerHTML = `
            <div style="text-align: center; margin-top: 20%;">
                <h1>This site is blocked by Procrastination Blocker!</h1>
                <p>Redirecting to your productivity reminder...</p>
            </div>
        `;

    setTimeout(() => {
      window.location.href = redirectUrl;
    }, 2000);
  } catch (error) {
    console.error("Error in blockWebsite:", error);
  }
}

// Listen for blocked URLs from background script
browser.runtime.onMessage.addListener((message) => {
  console.log("=== Message Received in Content Script ===");
  console.log("Message:", message);

  if (message.name === "blockedUrls") {
    console.log("Blocked URLs message received");
    console.log("URLs in message:", message.urls);

    const currentUrl = window.location.href;
    console.log("Current URL:", currentUrl);

    if (isUrlBlocked(message.urls, currentUrl)) {
      console.log("Site is blocked, initiating block...");
      blockWebsite();
    } else {
      console.log("Site is not blocked");
    }
  }
});

// Initialize
console.log("=== Content Script Setup ===");
if (document.readyState === "loading") {
  console.log("Document still loading, adding DOMContentLoaded listener");
  document.addEventListener("DOMContentLoaded", requestBlockedUrls);
} else {
  console.log("Document already loaded, requesting URLs immediately");
  requestBlockedUrls();
}
