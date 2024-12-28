//
//  SocialMediaBlacklistView.swift
//  ProcrastinationBlocker
//
//  Created by Daniel McKenzie on 12/28/24.
//

import SwiftUI

struct SocialMediaBlacklistView: View {
    @State private var socialMediaSites: [String: Bool] = AppDataManager.shared.loadSocialMediaBlacklist() // Load saved blacklist
    @State private var availableSites: [String] = [
        "facebook.com", "twitter.com", "instagram.com", "tiktok.com", "youtube.com", "reddit.com", "linkedin.com", "snapchat.com"
    ] // Common social media sites
    @State private var selectedSite: String = "Select a site" // Default option for the dropdown

    var body: some View {
        VStack(spacing: 20) {
            Text("Social Media Blacklist")
                .font(.largeTitle)
                .bold()
                .padding()

            // Dropdown for selecting a social media site
            Picker("Select a site", selection: $selectedSite) {
                Text("Select a site").tag("Select a site")
                ForEach(availableSites, id: \.self) { site in
                    Text(site).tag(site)
                }
            }
            .pickerStyle(MenuPickerStyle()) // Display as a dropdown menu
            .padding()
            .onChange(of: selectedSite) { site in
                if site != "Select a site" && !socialMediaSites.keys.contains(site) {
                    socialMediaSites[site] = true // Default to "on" state
                    AppDataManager.shared.saveSocialMediaBlacklist(socialMediaSites) // Save the updated list
                    selectedSite = "Select a site" // Reset the dropdown
                }
            }

            // List of social media sites with toggle switches
            List {
                ForEach(Array(socialMediaSites.keys), id: \.self) { site in
                    HStack {
                        Text(site)
                        Spacer()
                        Toggle(isOn: Binding(
                            get: { socialMediaSites[site] ?? false },
                            set: { newValue in
                                socialMediaSites[site] = newValue
                                AppDataManager.shared.saveSocialMediaBlacklist(socialMediaSites) // Save updated states
                            }
                        )) {
                            Text("") // Empty label for the toggle
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                    }
                }
            }
        }
        .padding()
        .onAppear {
            // Load the blacklist when the view appears
            socialMediaSites = AppDataManager.shared.loadSocialMediaBlacklist()
        }
    }
}
