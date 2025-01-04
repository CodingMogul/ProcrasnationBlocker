console.log("Block script initialized!");

// Function to block images and videos
function blockMedia() {
    console.log("Blocking all images and videos...");
    document.querySelectorAll("img, video").forEach((element) => element.remove());
}

// Observe dynamically added content to block images and videos
const observer = new MutationObserver(blockMedia);
observer.observe(document.body, { childList: true, subtree: true });

// Ensure the DOM is fully loaded before blocking
if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", blockMedia);
} else {
    blockMedia();
}
