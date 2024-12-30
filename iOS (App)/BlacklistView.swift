import SwiftUI

struct BlacklistView: View {
    @State private var website = "" // Input for a new website
    @State private var blacklist: [String] = AppDataManager.shared.loadBlacklist() // Load cached websites
    @FocusState private var isFocused: Bool // Focus for the input field

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
                        blacklist.append(website) // Add new website to the list
                        AppDataManager.shared.saveBlacklist(blacklist) // Save updated blacklist
                        website = "" // Clear the input field
                        isFocused = false // Dismiss the keyboard
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
        }
        .navigationTitle("Blacklist")
        .navigationBarTitleDisplayMode(.inline)
    }
}
