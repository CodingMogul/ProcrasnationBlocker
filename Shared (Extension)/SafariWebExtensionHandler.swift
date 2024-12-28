import SafariServices
import os.log

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {
    private let SFExtensionMessageKey = "message"
    private let userDefaults = UserDefaults(suiteName: "group.com.forwadautomations.ProcrasnationBlocker") // Use app group for sharing data

    func beginRequest(with context: NSExtensionContext) {
        guard let request = context.inputItems.first as? NSExtensionItem,
              let message = request.userInfo?[SFExtensionMessageKey] as? String else {
            os_log(.error, "Invalid request received.")
            return
        }

        os_log(.default, "Received message: %@", message)

        let response = NSExtensionItem()
        if message == "getBlockedSites" {
            let blockedSites = userDefaults?.array(forKey: "blockedSites") as? [String] ?? []
            os_log(.default, "Returning blocked sites: %@", blockedSites)
            response.userInfo = [SFExtensionMessageKey: ["blockedSites": blockedSites]]
        } else if message == "updateBlockedSites" {
            if let newBlockedSites = request.userInfo?["blockedSites"] as? [String] {
                userDefaults?.setValue(newBlockedSites, forKey: "blockedSites")
                os_log(.default, "Updated blocked sites: %@", newBlockedSites)
            }
            response.userInfo = [SFExtensionMessageKey: ["success": true]]
        }

        context.completeRequest(returningItems: [response], completionHandler: nil)
    }
}
