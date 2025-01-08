import SwiftUI

struct MainListView: View {
    @State private var isBlockingEnabled = AppDataManager.shared.loadBlockerStatus()
    @State private var blockAllPornEnabled = false
    @State private var removeVideos = AppDataManager.shared.loadRemoveVideos()
    @State private var removeImages = AppDataManager.shared.loadRemoveImages()
    @State private var removeGoogleAds = AppDataManager.shared.loadRemoveGoogleAds()
    @State private var timerState = AppDataManager.shared.loadTimerState()
    @State private var timeRemaining: Int = 0

    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                // Power button with animation
                Button(action: {
                    if !timerState.active {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isBlockingEnabled.toggle()
                            AppDataManager.shared.saveBlockerStatus(isBlockingEnabled)
                            print("Power button toggled: isBlockingEnabled = \(isBlockingEnabled)")
                        }
                    } else {
                        print("Power button press ignored: Timer is active")
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
                .disabled(timerState.active) // Disable if timer is active

                Text(isBlockingEnabled || timerState.active ? "Blocking Enabled" : "Blocking Disabled")
                    .font(.title2)
                    .bold()
                    .foregroundColor(isBlockingEnabled || timerState.active ? .green : .red)

                if timerState.active {
                    Text("Time Remaining: \(timeFormatted(timeRemaining))")
                        .font(.headline)
                        .onAppear {
                            startCountdown()
                        }
                }

                Spacer()

                // Schedule Blocker Button
                NavigationLink(destination: TimerView()) {
                    Text("Schedule Blocker")
                        .padding()
                        .background(timerState.active ? Color.gray : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(timerState.active)

                // "Block All Porn" toggle
                Toggle(isOn: $blockAllPornEnabled) {
                    Text("Block All Porn")
                }
                .onChange(of: blockAllPornEnabled) { newValue in
                    print("Block All Porn toggled: newValue = \(newValue)")
                    blockAllPorn(enabled: newValue)
                }
                .padding()

                // Toggles for individual features
                VStack(alignment: .leading, spacing: 20) {
                    Toggle(isOn: $removeVideos) {
                        Text("Remove Videos")
                    }
                    .onChange(of: removeVideos) { newValue in
                        AppDataManager.shared.saveRemoveVideos(newValue)
                        print("Remove Videos toggled: newValue = \(newValue)")
                    }

                    Toggle(isOn: $removeImages) {
                        Text("Remove Images")
                    }
                    .onChange(of: removeImages) { newValue in
                        AppDataManager.shared.saveRemoveImages(newValue)
                        print("Remove Images toggled: newValue = \(newValue)")
                    }

                    Toggle(isOn: $removeGoogleAds) {
                        Text("Remove Google Ads")
                    }
                    .onChange(of: removeGoogleAds) { newValue in
                        AppDataManager.shared.saveRemoveGoogleAds(newValue)
                        print("Remove Google Ads toggled: newValue = \(newValue)")
                    }
                }
                .padding()
                .font(.headline)

                Spacer()
            }
            .padding()
            .onAppear {
                timerState = AppDataManager.shared.loadTimerState()
                if timerState.active {
                    isBlockingEnabled = true
                    timeRemaining = Int(timerState.duration)
                }
                print("View appeared: timerState.active = \(timerState.active), isBlockingEnabled = \(isBlockingEnabled)")
            }
        }
    }

    // Function to handle countdown
    private func startCountdown() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 1
                AppDataManager.shared.saveTimerState(active: true, duration: Double(timeRemaining))
            } else {
                timer.invalidate()
                timerState.active = false
                isBlockingEnabled = false
                AppDataManager.shared.saveBlockerStatus(false)
                AppDataManager.shared.saveTimerState(active: false, duration: 0)
                print("Timer completed. Blocking disabled.")
            }
        }
    }

    // Helper: Format time as MM:SS
    private func timeFormatted(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func blockAllPorn(enabled: Bool) {
        print("blockAllPorn called with enabled: \(enabled)")
        DispatchQueue.global(qos: .background).async { // Perform file operations in the background
            if let filePath = Bundle.main.path(forResource: "porn-websites", ofType: "txt") {
                do {
                    let fileContents = try String(contentsOfFile: filePath)
                    let pornSites = fileContents.split(separator: "\n").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    var currentBlacklist = AppDataManager.shared.loadBlacklist()

                    if enabled {
                        for site in pornSites where !currentBlacklist.contains(site) {
                            currentBlacklist.append(site)
                        }
                        print("Added porn sites to blacklist.")
                    } else {
                        currentBlacklist.removeAll { pornSites.contains($0) }
                        print("Removed porn sites from blacklist.")
                    }

                    // Save the updated blacklist back on the main thread
                    DispatchQueue.main.async {
                        AppDataManager.shared.saveBlacklist(currentBlacklist)
                        print("Blacklist updated successfully.")
                    }
                } catch {
                    print("Error reading porn websites file: \(error)")
                }
            } else {
                print("Porn websites file not found.")
            }
        }
    }

}
