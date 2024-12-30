import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var onboardingCompleted = false // Tracks if onboarding is complete

    let onboardingData = [
        OnboardingPage(imageName: "onboarding1", title: "Create a prototype in just a few minutes", description: "Enjoy these pre-made components and worry only about creating the best product ever."),
        OnboardingPage(imageName: "onboarding2", title: "Block distracting websites", description: "Use this app to add websites you want to block while working."),
        OnboardingPage(imageName: "onboarding3", title: "Stay focused and productive", description: "Set up your focus sessions and let the app handle distractions.")
    ]

    var body: some View {
        if onboardingCompleted {
            MainTabView() // Transition to the main app
        } else {
            VStack {
                TabView(selection: $currentPage) {
                    ForEach(0..<onboardingData.count, id: \.self) { index in
                        OnboardingPageView(page: onboardingData[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(.page(backgroundDisplayMode: .always)) // Dots below the TabView

                // "Next" button
                Button(action: {
                    if currentPage < onboardingData.count - 1 {
                        currentPage += 1
                    } else {
                        // Mark onboarding as complete
                        UserDefaults.standard.set(true, forKey: "onboardingComplete")
                        onboardingCompleted = true
                    }
                }) {
                    Text(currentPage == onboardingData.count - 1 ? "Get Started" : "Next")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
        }
    }
}

struct OnboardingPage {
    let imageName: String
    let title: String
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(page.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 300)

            Text(page.title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            Text(page.description)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding()

            Spacer()
        }
        .padding()
    }
}
