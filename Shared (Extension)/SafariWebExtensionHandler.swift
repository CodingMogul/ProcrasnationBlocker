import SafariServices
import os.log

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {
    private let SFExtensionMessageKey = "message"
    private let appGroupID = "group.com.forwardautomations.profocus"
    private let userDefaults: UserDefaults?
    
    override init() {
        userDefaults = UserDefaults(suiteName: appGroupID)
        super.init()
        os_log(.default, "=== SafariWebExtensionHandler Initialization ===")
        os_log(.default, "App Group ID: %@", appGroupID)
        
        if let defaults = userDefaults {
            os_log(.default, "UserDefaults initialized successfully")
            // Print all keys in UserDefaults
            let allKeys = defaults.dictionaryRepresentation().keys
            os_log(.default, "All UserDefaults keys: %@", allKeys.joined(separator: ", "))
            
            if let blacklist = defaults.array(forKey: "blacklist") as? [String] {
                os_log(.default, "Found blacklist with %d items: %@", blacklist.count, blacklist)
            } else {
                os_log(.error, "No blacklist found in UserDefaults")
            }
        } else {
            os_log(.error, "Failed to initialize UserDefaults with suite: %@", appGroupID)
        }
    }

    func beginRequest(with context: NSExtensionContext) {
        os_log(.default, "\n=== Begin Request ===")
        
        guard let item = context.inputItems.first as? NSExtensionItem else {
            os_log(.error, "No input items found")
            context.completeRequest(returningItems: [], completionHandler: nil)
            return
        }
        
        os_log(.default, "Input item: %@", item)
        
        guard let userInfo = item.userInfo else {
            os_log(.error, "No userInfo found")
            context.completeRequest(returningItems: [], completionHandler: nil)
            return
        }
        
        os_log(.default, "UserInfo: %@", userInfo)
        
        guard let messageData = userInfo[SFExtensionMessageKey] as? [String: Any] else {
            os_log(.error, "No message data found")
            context.completeRequest(returningItems: [], completionHandler: nil)
            return
        }
        
        os_log(.default, "Message data: %@", messageData)
        
        guard let message = messageData["message"] as? String else {
            os_log(.error, "No message string found")
            context.completeRequest(returningItems: [], completionHandler: nil)
            return
        }

        os_log(.default, "Received message: %@", message)
        let response = NSExtensionItem()

        if message == "getBlockedSites" {
            let blockedSites = userDefaults?.array(forKey: "blacklist") as? [String] ?? []
            os_log(.default, "Retrieved blocked sites: %@", blockedSites)
            
            let messageResponse = ["blockedSites": blockedSites]
            let responseDict = ["message": messageResponse]
            response.userInfo = [SFExtensionMessageKey: responseDict]
            
            os_log(.default, "Final response structure: %@", response.userInfo ?? [:])
        } else if message == "getBlockingConfig" {
            let config = [
                "removeVideos": userDefaults?.bool(forKey: "removeVideos") ?? false,
                "removeImages": userDefaults?.bool(forKey: "removeImages") ?? false,
                "removeGoogleAds": userDefaults?.bool(forKey: "removeGoogleAds") ?? false
            ]
            
            let responseDict = ["message": config]
            response.userInfo = [SFExtensionMessageKey: responseDict]
            
            os_log(.default, "Sending blocking config: %@", config)
        }

        context.completeRequest(returningItems: [response], completionHandler: { success in
            os_log(.default, "Request completed: %@", success ? "success" : "failure")
        })
    }
}
