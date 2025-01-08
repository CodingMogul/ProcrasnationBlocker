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

    func saveRemoveGoogleAds(_ isEnabled: Bool) {
        userDefaults?.set(isEnabled, forKey: "removeGoogleAds")
    }

    func loadRemoveGoogleAds() -> Bool {
        return userDefaults?.bool(forKey: "removeGoogleAds") ?? false
    }

    func saveRemoveImages(_ isEnabled: Bool) {
        userDefaults?.set(isEnabled, forKey: "removeImages")
    }

    func loadRemoveImages() -> Bool {
        return userDefaults?.bool(forKey: "removeImages") ?? false
    }

    func saveRemoveVideos(_ isEnabled: Bool) {
        userDefaults?.set(isEnabled, forKey: "removeVideos")
    }

    func loadRemoveVideos() -> Bool {
        return userDefaults?.bool(forKey: "removeVideos") ?? false
    }
    
    
    func saveTimerState(active: Bool, duration: Double) {
        userDefaults?.set(active, forKey: "TimerActive")
        userDefaults?.set(duration, forKey: "TimerDuration")
    }

    func loadTimerState() -> (active: Bool, duration: Double) {
        let active = userDefaults?.bool(forKey: "TimerActive") ?? false
        let duration = userDefaults?.double(forKey: "TimerDuration") ?? 0
        return (active, duration)
    }



}

