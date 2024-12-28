//
//  WhitelistView.swift
//  ProcrastinationBlocker
//
//  Created by Daniel McKenzie on 12/28/24.
//

import SwiftUI

struct WhitelistView: View {
    @State private var whitelist: [String] = ["example.org", "goodwebsite.com"]

    var body: some View {
        VStack(spacing: 20) {
            Text("Whitelist")
                .font(.largeTitle)
                .bold()

            List {
                ForEach(whitelist, id: \.self) { site in
                    HStack {
                        Text(site)
                        Spacer()
                        Button(action: {
                            if let index = whitelist.firstIndex(of: site) {
                                whitelist.remove(at: index)
                            }
                        }) {
                            Text("Remove")
                                .foregroundColor(.red)
                        }
                    }
                }
            }

            Spacer()
        }
        .padding()
    }
}
