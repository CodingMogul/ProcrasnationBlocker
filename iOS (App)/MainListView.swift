import SwiftUI

struct MainListView: View {
    @State private var isBlockingEnabled = false // State for power button

    var body: some View {
        VStack {
            Spacer()

            // Power button with animation
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isBlockingEnabled.toggle()
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
        }
        .padding()
    }
}
