import SwiftUI

struct MainListView: View {
    @State private var isBlockingEnabled = false // State for power button
    @State private var removeVideos = AppDataManager.shared.loadRemoveVideos()
    @State private var removeImages = AppDataManager.shared.loadRemoveImages()
    @State private var removeGoogleAds = AppDataManager.shared.loadRemoveGoogleAds()

    var body: some View {
        VStack {
            Spacer()

            // Power button with animation
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isBlockingEnabled.toggle()
                    AppDataManager.shared.saveBlockerStatus(isBlockingEnabled)
                }
            }) {
                ZStack {
                    Circle()
                        .fill(isBlockingEnabled ? Color.green : Color.red)
                        .frame(width: 100, height: 100)
                        .shadow(radius: 10)

                    Image(systemName: isBlockingEnabled ? "power" : "poweroff")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
            }
            .padding()

            Text(isBlockingEnabled ? "Blocking Enabled" : "Blocking Disabled")
                .font(.title2)
                .bold()
                .foregroundColor(isBlockingEnabled ? .green : .red)

            Spacer()

            // Toggles for individual features
            VStack(alignment: .leading, spacing: 20) {
                Toggle(isOn: $removeVideos) {
                    Text("Remove Videos")
                }
                .onChange(of: removeVideos) { newValue in
                    AppDataManager.shared.saveRemoveVideos(newValue)
                }

                Toggle(isOn: $removeImages) {
                    Text("Remove Images")
                }
                .onChange(of: removeImages) { newValue in
                    AppDataManager.shared.saveRemoveImages(newValue)
                }

                Toggle(isOn: $removeGoogleAds) {
                    Text("Remove Google Ads")
                }
                .onChange(of: removeGoogleAds) { newValue in
                    AppDataManager.shared.saveRemoveGoogleAds(newValue)
                }
            }
            .padding()
            .font(.headline)

            Spacer()
        }
        .padding()
    }
}
