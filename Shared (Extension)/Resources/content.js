console.log("Content script initialized!");

// Redirect URL
const redirectUrl = "https://procrastinationblocker.com/remind";

try {
    console.log("Blocking all websites!");

    // Replace page content with a motivational message
    document.body.innerHTML = `
        <div style="text-align: center; margin-top: 20%;">
            <h1>This site is blocked by Procrastination Blocker!</h1>
            <p>Redirecting to your productivity reminder...</p>
        </div>
    `;

    // Redirect after a delay
    setTimeout(() => {
        console.log("Redirecting to reminder page...");
        window.location.href = redirectUrl;
    }, 2000); // Adjust delay as needed
} catch (error) {
    console.error("Error in content script:", error);
}
