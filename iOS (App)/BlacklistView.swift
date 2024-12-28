//
//  BlacklistView.swift
//  ProcrastinationBlocker
//
//  Created by Daniel McKenzie on 12/28/24.
//             

import SwiftUI

struct BlacklistView: View {
    @State private var website = "" // Input field for a new website
    @State private var blacklist: [String] = AppDataManager.shared.loadBlacklist() // Load the saved blacklist

    var body: some View {
        VStack(spacing: 20) {
            Text("Website Blacklist")
                .font(.largeTitle)
                .bold()

            HStack {
                TextField("Add website (e.g., example.com)", text: $website)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    if !website.isEmpty {
                        blacklist.append(website) // Add the new website to the list
                        AppDataManager.shared.saveBlacklist(blacklist) // Save the updated blacklist
                        website = "" // Clear the input field
                    }
                }) {
                    Text("Add")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }

            List {
                ForEach(blacklist, id: \.self) { site in
                    HStack {
                        Text(site)
                        Spacer()
                        Button(action: {
                            if let index = blacklist.firstIndex(of: site) {
                                blacklist.remove(at: index) // Remove the website from the list
                                AppDataManager.shared.saveBlacklist(blacklist) // Save the updated blacklist
                            }
                        }) {
                            Text("Remove")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
        }
        .padding()
    }
}
