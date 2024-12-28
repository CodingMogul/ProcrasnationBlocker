//
//  MainTabView.swift
//  ProcrastinationBlocker
//
//  Created by Daniel McKenzie on 12/28/24.
//
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            PornBlockerView()
                .tabItem {
                    Image(systemName: "shield.fill")
                    Text("Blocker")
                }
            BlacklistView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Blacklist")
                }
            SocialMediaBlacklistView()
                .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("Social Media")
                }
            WhitelistView()
                .tabItem {
                    Image(systemName: "checkmark.circle")
                    Text("Whitelist")
                }
        }
    }
}

