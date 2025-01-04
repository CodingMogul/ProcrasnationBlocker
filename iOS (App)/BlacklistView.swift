import SwiftUI

struct BlacklistView: View {
    @State private var website = "" // Input for a new website
    @State private var blacklist: [String] = [] // Load cached websites
    @FocusState private var isFocused: Bool // Focus for the input field
    
    init() {
        // Test UserDefaults access when view is created
        AppDataManager.shared.testUserDefaultsAccess()
        // Load initial blacklist
        _blacklist = State(initialValue: AppDataManager.shared.loadBlacklist())
    }
    
    var body: some View {
        VStack {
            // Input field for adding a website
            HStack {
                TextField("Add website (e.g., example.com)", text: $website)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .focused($isFocused)

                Button(action: {
                    if !website.isEmpty {
                        blacklist.append(website)
                        AppDataManager.shared.saveBlacklist(blacklist)
                        website = ""
                        isFocused = false
                        
                        // Debug: Print all data after saving
                        AppDataManager.shared.debugPrintAllData()
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                }
                .padding(.trailing)
            }

            // List of blacklisted websites
            if blacklist.isEmpty {
                VStack {
                    Spacer()
                    Text("Nothing here. For now.")
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)

                    Text("This is where you'll find your blocked websites.")
                        .font(.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            } else {
                List {
                    ForEach(blacklist, id: \.self) { site in
                        HStack {
                            Text(site)
                            Spacer()
                            Button(action: {
                                if let index = blacklist.firstIndex(of: site) {
                                    blacklist.remove(at: index) // Remove the website
                                    AppDataManager.shared.saveBlacklist(blacklist) // Save updated blacklist
                                }
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
            }

            // Add a debug button
            Button("Test UserDefaults") {
                AppDataManager.shared.testUserDefaultsAccess()
            }
            .padding()
        }
        .navigationTitle("Blacklist")
        .navigationBarTitleDisplayMode(.inline)
    }
}
