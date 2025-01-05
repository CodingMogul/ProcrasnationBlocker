console.log("Block script initialized!");

// Function to remove videos
function removeVideos() {
  if (!window.blockingConfig?.removeVideos) return;
  console.log("Removing all videos...");
  document.querySelectorAll("video").forEach((video) => video.remove());
}

// Function to remove images
function removeImages() {
  if (!window.blockingConfig?.removeImages) return;
  console.log("Removing all images...");
  document.querySelectorAll("img").forEach((image) => image.remove());
}

// Function to block Google ads
function blockGoogleAds() {
  if (!window.blockingConfig?.removeGoogleAds) return;
  console.log("Blocking Google ads...");
  function removeAds() {
    const adSelectors = [
      "div[data-text-ad]",
      "div[data-text-ad] ~ div", // Ad-related divs
      "div[data-content-ad]",
      ".ads-ad",
      ".commercial-unit-desktop-top",
      ".commercial-unit-desktop-rhs",
      ".commercial-unit-desktop-bottom",
      "div[data-pcu]", // PCU ad block
      'span:contains("Sponsored")', // Sponsored label
      'span:contains("Ad")', // Ad label
    ];

    // Remove ad elements matching selectors
    adSelectors.forEach((selector) => {
      const elements = document.querySelectorAll(selector);
      elements.forEach((element) => element.remove());
    });

    // Remove iframes that may contain ads
    const iframes = document.querySelectorAll("iframe");
    iframes.forEach((iframe) => {
      if (iframe.src.includes("googleads")) {
        iframe.remove();
      }
    });
  }
}

// Request blocking configuration from background script
browser.runtime
  .sendMessage({ name: "getBlockingConfig" })
  .then((config) => {
    window.blockingConfig = config;
    console.log("Received blocking config:", config);

    // Run initial blocking
    removeVideos();
    removeImages();
    blockGoogleAds();
  })
  .catch((error) => {
    console.error("Error getting blocking config:", error);
  });

// Set up mutation observer to handle dynamically loaded content
const observer = new MutationObserver(() => {
  removeVideos();
  removeImages();
  blockGoogleAds();
});

// Start observing document changes
observer.observe(document.documentElement, {
  childList: true,
  subtree: true,
});
