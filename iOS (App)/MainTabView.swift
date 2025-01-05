import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            MainListView() // Main screen with power button
                .tabItem {
                    Image(systemName: "shield.fill")
                    Text("Blocker")
                }
            BlacklistView() // Updated Blacklist view
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Blacklist")
                }
            WhitelistView() // Updated Whitelist view
                .tabItem {
                    Image(systemName: "checkmark.circle")
                    Text("Whitelist")
                }
        }
    }
}
