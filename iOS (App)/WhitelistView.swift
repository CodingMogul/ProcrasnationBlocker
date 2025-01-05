import SwiftUI

struct WhitelistView: View {
    @State private var website = "" // Input for a new website
    @State private var whitelist: [String] = AppDataManager.shared.loadWhitelist() // Load cached websites
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
                        whitelist.append(website) // Add new website to the list
                        AppDataManager.shared.saveWhitelist(whitelist) // Save updated whitelist
                        website = "" // Clear the input field
                        isFocused = false // Dismiss the keyboard
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundColor(.green)
                }
                .padding(.trailing)
            }

            // List of whitelisted websites
            if whitelist.isEmpty {
                VStack {
                    Spacer()
                    Text("Nothing here. For now.")
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)

                    Text("This is where you'll find your allowed websites.")
                        .font(.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            } else {
                List {
                    ForEach(whitelist, id: \.self) { site in
                        HStack {
                            Text(site)
                            Spacer()
                            Button(action: {
                                if let index = whitelist.firstIndex(of: site) {
                                    whitelist.remove(at: index) // Remove the website
                                    AppDataManager.shared.saveWhitelist(whitelist) // Save updated whitelist
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
        .navigationTitle("Whitelist")
        .navigationBarTitleDisplayMode(.inline)
    }
}
