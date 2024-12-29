console.log("Content script initialized!");

// Redirect URL
const redirectUrl = "https://procrastinationblocker.com/remind";

// Function to block the website
function blockWebsite() {
    try {
        console.log("Blocking all websites!");

        // Replace page content with a motivational message
        document.body.innerHTML = `
            <div style="text-align: center; margin-top: 20%;">
                <h1>This site is blocked by Procrastination Blocker!</h1>
                <p>Redirecting to your productivity reminder...</p>
            </div>
        `;

        console.log("Page content replaced successfully.");

        // Redirect after a delay
        setTimeout(() => {
            console.log("Redirecting to reminder page: " + redirectUrl);
            window.location.href = redirectUrl;
        }, 2000); // Adjust delay as needed
    } catch (error) {
        console.error("Error in content script:", error);
    }
}

// Ensure the DOM is fully loaded before executing the script
if (document.readyState === "loading") {
    console.log("Document not ready, waiting for DOMContentLoaded...");
    document.addEventListener("DOMContentLoaded", blockWebsite);
} else {
    console.log("Document is ready, executing blockWebsite immediately.");
    blockWebsite();
}
