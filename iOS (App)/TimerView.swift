import SwiftUI

struct TimerView: View {
    @State private var timerDuration: Double = 60 // Default: 1 minute
    @State private var timerActive = AppDataManager.shared.loadTimerState().active
    let maxDuration: Double = 12 * 60 * 60 // 12 hours in seconds

    var body: some View {
        VStack(spacing: 20) {
            Text("Schedule Blocker")
                .font(.largeTitle)
                .bold()

            if timerActive {
                Text("A timer is already active.")
                    .font(.headline)
                    .foregroundColor(.red)
                Text("Remaining Time: \(timeFormatted(AppDataManager.shared.loadTimerState().duration))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            } else {
                VStack {
                    Text("Set Timer Duration")
                        .font(.headline)

                    Slider(value: $timerDuration, in: 60...maxDuration, step: 60)
                        .padding()
                    Text("\(Int(timerDuration) / 60) minutes")
                        .font(.subheadline)
                }

                Button(action: startTimer) {
                    Text("Start Timer")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .onAppear {
            timerActive = AppDataManager.shared.loadTimerState().active
        }
    }

    private func startTimer() {
        AppDataManager.shared.saveBlockerStatus(true)
        AppDataManager.shared.saveTimerState(active: true, duration: timerDuration)
        timerActive = true
        print("Timer started for \(timeFormatted(timerDuration))")
    }

    private func timeFormatted(_ totalSeconds: Double) -> String {
        let minutes = Int(totalSeconds) / 60
        let seconds = Int(totalSeconds) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
