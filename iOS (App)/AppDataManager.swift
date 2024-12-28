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
    private let appGroupID = "group.com.forwardautomations.ProcrastinationBlocker"

    // UserDefaults for the shared App Group
    private var userDefaults: UserDefaults? {
        return UserDefaults(suiteName: appGroupID)
    }

    // MARK: - Blacklist
    func saveBlacklist(_ blacklist: [String]) {
        userDefaults?.set(blacklist, forKey: "blacklist")
    }

    func loadBlacklist() -> [String] {
        return userDefaults?.stringArray(forKey: "blacklist") ?? []
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
}

