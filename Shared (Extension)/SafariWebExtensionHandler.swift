import SafariServices
import os.log

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {
    private let SFExtensionMessageKey = "message"
    private let userDefaults = UserDefaults(suiteName: "group.com.forwadautomations.ProcrastinationBlocker") // Use app group for sharing data

    func beginRequest(with context: NSExtensionContext) {
        os_log(.default, "Begin request received.");

        guard let request = context.inputItems.first as? NSExtensionItem,
              let message = request.userInfo?[SFExtensionMessageKey] as? String else {
            os_log(.error, "Invalid request received. Missing message or input items.");
            return
        }

        os_log(.default, "Received message: %@", message);

        let response = NSExtensionItem()

        if message == "getBlockedSites" {
            os_log(.default, "Processing 'getBlockedSites' message.");
            let blockedSites = userDefaults?.array(forKey: "blockedSites") as? [String] ?? []
            os_log(.default, "Returning blocked sites: %@", blockedSites);
            response.userInfo = [SFExtensionMessageKey: ["blockedSites": blockedSites]]
        } else if message == "updateBlockedSites" {
            os_log(.default, "Processing 'updateBlockedSites' message.");
            if let newBlockedSites = request.userInfo?["blockedSites"] as? [String] {
                os_log(.default, "Updating blocked sites with new list: %@", newBlockedSites);
                userDefaults?.setValue(newBlockedSites, forKey: "blockedSites")
            } else {
                os_log(.error, "Failed to parse 'blockedSites' from request userInfo.");
            }
            response.userInfo = [SFExtensionMessageKey: ["success": true]]
        } else {
            os_log(.error, "Unknown message type received: %@", message);
        }

        os_log(.default, "Completing request with response: %@", response.userInfo ?? [:]);
        context.completeRequest(returningItems: [response], completionHandler: nil)
    }
}
