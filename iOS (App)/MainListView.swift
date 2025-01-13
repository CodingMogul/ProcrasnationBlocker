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
                    
                    // Recalculate remaining time if app was in background
                    if let startTime = UserDefaults.standard.object(forKey: "timerStartTime") as? Date {
                        let elapsedTime = Int(Date().timeIntervalSince(startTime))
                        timeRemaining = max(0, Int(timerState.duration) - elapsedTime)
                        
                        if timeRemaining > 0 {
                            startCountdown()
                        } else {
                            // Timer expired while in background
                            timerState.active = false
                            isBlockingEnabled = false
                            AppDataManager.shared.saveBlockerStatus(false)
                            AppDataManager.shared.saveTimerState(active: false, duration: 0)
                            UserDefaults.standard.removeObject(forKey: "timerStartTime")
                        }
                    }
                }
                print("View appeared: timerState.active = \(timerState.active), isBlockingEnabled = \(isBlockingEnabled)")
            }
        }
    }

    // Function to handle countdown
    private func startCountdown() {
        var timerReference: Timer?
        timerReference = Timer(timeInterval: 1.0, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
                AppDataManager.shared.saveTimerState(active: true, duration: Double(self.timeRemaining))
                
                // Post local notification when timer is about to expire
                if self.timeRemaining == 300 { // 5 minutes remaining
                    self.scheduleTimerNotification(minutes: 5)
                }
            } else {
                timerReference?.invalidate()
                self.timerState.active = false
                self.isBlockingEnabled = false
                AppDataManager.shared.saveBlockerStatus(false)
                AppDataManager.shared.saveTimerState(active: false, duration: 0)
                print("Timer completed. Blocking disabled.")
                
                // Notify user that timer has completed
                self.scheduleTimerCompletedNotification()
            }
        }
        
        // Add the timer to RunLoop for background execution
        RunLoop.main.add(timerReference!, forMode: .common)
        
        // Store the start time in UserDefaults for background tracking
        let startTime = Date()
        UserDefaults.standard.set(startTime, forKey: "timerStartTime")
        UserDefaults.standard.synchronize()
    }

    // Add these helper functions for notifications
    private func scheduleTimerNotification(minutes: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Timer Update"
        content.body = "\(minutes) minutes remaining in your blocking session"
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "timerWarning",
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request)
    }

    private func scheduleTimerCompletedNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Timer Completed"
        content.body = "Your blocking session has ended"
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "timerCompleted",
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request)
    }

    // Helper: Format time as MM:SS
    private func timeFormatted(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func blockAllPorn(enabled: Bool) {
        print("blockAllPorn called with enabled: \(enabled)")

        // Get the file path
        if let filePath = Bundle.main.path(forResource: "porn-websites", ofType: "txt") {
            print("File found at: \(filePath)")
            
            do {
                // Read the file content
                let fileContents = try String(contentsOfFile: filePath)
                print("File contents:\n\(fileContents)")

                // Split content into an array of websites
                let pornSites = fileContents.split(separator: "\n").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                print("Parsed websites:\n\(pornSites)")

                // Load the current blacklist
                var currentBlacklist = AppDataManager.shared.loadBlacklist()
                print("Current blacklist before update:\n\(currentBlacklist)")

                if enabled {
                    // Add porn sites to the blacklist
                    for site in pornSites where !currentBlacklist.contains(site) {
                        currentBlacklist.append(site)
                    }
                    print("Updated blacklist with porn sites:\n\(currentBlacklist)")
                } else {
                    // Remove porn sites from the blacklist
                    currentBlacklist.removeAll { pornSites.contains($0) }
                    print("Updated blacklist after removing porn sites:\n\(currentBlacklist)")
                }

                // Save the updated blacklist
                AppDataManager.shared.saveBlacklist(currentBlacklist)
                print("Blacklist saved successfully.")
            } catch {
                print("Error reading porn websites file: \(error)")
            }
        } else {
            print("Porn websites file not found.")
        }
    }

}
