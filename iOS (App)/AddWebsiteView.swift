import SwiftUI
struct AddWebsiteView: View {
    @Binding var isPresented: Bool // Binding to dismiss the modal
    @State private var website = "" // Input for website
    var onAdd: (String) -> Void // Callback for adding website

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter website (e.g., example.com)", text: $website)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    if !website.isEmpty {
                        onAdd(website)
                        website = ""
                        isPresented = false
                    }
                }) {
                    Text("Add Website")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }

                Spacer()
            }
            .navigationTitle("Add Website")
            .navigationBarItems(trailing: Button("Cancel") {
                isPresented = false
            })
        }
    }
}
