//
//  AppDataManager.swift
//  ProcrastinationBlocker
//
//  Created by Daniel McKenzie on 12/28/24.
//

import Foundation

class AppDataManager {
    // Singleton instance to access the manager globally
    static let shared = AppDataManager()

    // App Group Identifier (replace with your actual group identifier)
    private let appGroupID = "group.com.forwardautomations.profocus"

    // UserDefaults for the shared App Group
    private var userDefaults: UserDefaults? {
        let defaults = UserDefaults(suiteName: appGroupID)
        print("Accessing UserDefaults with suite: \(appGroupID)")
        if defaults == nil {
            print("⚠️ WARNING: Failed to initialize UserDefaults!")
        }
        return defaults
    }

    init() {
        print("\n=== AppDataManager Initialization ===")
        if let defaults = userDefaults {
            print("✅ UserDefaults initialized successfully")
            
            // Initialize with default sites if empty
            if defaults.array(forKey: "blacklist") == nil {
                let defaultSites = ["youtube.com", "facebook.com"]
                print("Initializing blacklist with default sites: \(defaultSites)")
                defaults.set(defaultSites, forKey: "blacklist")
                defaults.synchronize()
                
                // Verify initialization
                if let saved = defaults.array(forKey: "blacklist") as? [String] {
                    print("✅ Successfully initialized with default sites: \(saved)")
                } else {
                    print("❌ Failed to initialize default sites!")
                }
            } else {
                if let existing = defaults.array(forKey: "blacklist") as? [String] {
                    print("📋 Found existing blacklist: \(existing)")
                }
            }
        } else {
            print("❌ CRITICAL: Failed to initialize UserDefaults!")
        }
        debugPrintAllData()
    }

    // MARK: - Blacklist
    func saveBlacklist(_ blacklist: [String]) {
        print("\n=== Saving Blacklist ===")
        print("Attempting to save: \(blacklist)")
        
        guard let defaults = userDefaults else {
            print("❌ ERROR: UserDefaults is nil!")
            return
        }
        
        // Normalize URLs to lowercase
        let normalizedBlacklist = blacklist.map { $0.lowercased() }
        
        // Save and synchronize
        defaults.set(normalizedBlacklist, forKey: "blacklist")
        defaults.synchronize()
        
        // Verify the save
        if let saved = defaults.array(forKey: "blacklist") as? [String] {
            print("✅ Successfully saved and verified: \(saved)")
        } else {
            print("❌ Failed to verify saved blacklist!")
        }
        
        debugPrintAllData()
    }

    func loadBlacklist() -> [String] {
        print("\n=== Loading Blacklist ===")
        guard let defaults = userDefaults else {
            print("❌ ERROR: UserDefaults is nil!")
            return []
        }
        
        if let blacklist = defaults.array(forKey: "blacklist") as? [String] {
            print("📋 Loaded blacklist: \(blacklist)")
            return blacklist
        } else {
            print("⚠️ No blacklist found, returning empty array")
            return []
        }
    }

    // MARK: - Whitelist
    func saveWhitelist(_ whitelist: [String]) {
        userDefaults?.set(whitelist, forKey: "whitelist")
    }

    func loadWhitelist() -> [String] {
        return userDefaults?.stringArray(forKey: "whitelist") ?? []
    }

    // MARK: - Blocker Status
    func saveBlockerStatus(_ isEnabled: Bool) {
        userDefaults?.set(isEnabled, forKey: "blockerStatus")
    }

    func loadBlockerStatus() -> Bool {
        return userDefaults?.bool(forKey: "blockerStatus") ?? false
    }

    // MARK: - Social Media Blacklist
    /// Save Social Media Blacklist as a dictionary with the site and its toggle state
    func saveSocialMediaBlacklist(_ blacklist: [String: Bool]) {
        userDefaults?.set(blacklist, forKey: "socialMediaBlacklist")
    }

    /// Load Social Media Blacklist as a dictionary
    func loadSocialMediaBlacklist() -> [String: Bool] {
        return userDefaults?.dictionary(forKey: "socialMediaBlacklist") as? [String: Bool] ?? [:]
    }

    func debugPrintAllData() {
        print("\n=== AppDataManager Debug ===")
        if let defaults = userDefaults {
            print("UserDefaults contents for group \(appGroupID):")
            let dict = defaults.dictionaryRepresentation()
            if dict.isEmpty {
                print("⚠️ UserDefaults is empty!")
            } else {
                for (key, value) in dict {
                    print("🔑 Key: \(key)")
                    print("📝 Value: \(value)")
                }
            }
        } else {
            print("❌ ERROR: UserDefaults is nil!")
        }
        print("=== End Debug ===\n")
    }

    // Add a test method to verify UserDefaults access
    func testUserDefaultsAccess() {
        print("\n=== Testing UserDefaults Access ===")
        guard let defaults = userDefaults else {
            print("❌ ERROR: Could not access UserDefaults!")
            return
        }
        
        // Try writing and reading a test value
        let testKey = "testKey"
        let testValue = ["test.com"]
        
        print("Writing test value: \(testValue)")
        defaults.set(testValue, forKey: testKey)
        defaults.synchronize()
        
        if let readValue = defaults.array(forKey: testKey) as? [String] {
            print("✅ Successfully read test value: \(readValue)")
        } else {
            print("❌ Failed to read test value!")
        }
        
        // Clean up
        defaults.removeObject(forKey: testKey)
        defaults.synchronize()
        print("=== End Test ===\n")
    }
}

