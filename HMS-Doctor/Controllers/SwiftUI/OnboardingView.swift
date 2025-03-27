//
//  OnboardingView.swift
//  HMS-Doctor
//
//  Created by Dhruvi on 20/03/25.
//
import Foundation
import SwiftUI

struct OnboardingItem {
    var imageName: String
    var title: String?
    var description: String
}

struct OnboardingView: View {
    weak var delegate: OnBoardingHostingController?

    private let onboardingData: [OnboardingItem] = [
        .init(imageName: "doctorWelcomeImage", title: "Welcome, Doctor!", description: "Your Smart Medical Assistant Awaits"),
        .init(imageName: "doctorAppointmentsImage", title: nil, description: "View Your Appointments At A Glance!"),
        .init(imageName: "doctorPrescriptionsImage", title: nil, description: "Prescribe Paper-free Instantly!"),
        .init(imageName: "doctorReportsImage", title: nil, description: "Patient Records, One Tap Away!"),
        .init(imageName: "doctorAlertsImage", description: "Stay Up-to-Date With All Alerts!")
    ]
    @State private var currentPageIndex: Int = 0
    @State var isOnboardingComplete: Bool = false

    private var isLastPage: Bool {
        currentPageIndex == onboardingData.count - 1
    }

    var body: some View {
        NavigationStack {
            VStack {
                TabView(selection: $currentPageIndex) {
                    ForEach(onboardingData.indices, id: \.self) { index in
                        VStack {
                            Spacer()
                            if let title = onboardingData[index].title {
                                Text(title)
                                    .font(.title)
                                    .fontWeight(.bold)
                            }
                            Text(onboardingData[index].description)
                                .font(.title3)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.bottom, 20)

                            Image(onboardingData[index].imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)

                           .padding(.top, 10)
                           .allowsHitTesting(false)
                            Spacer()
                        }
                        .padding()
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))

                HStack {
                   ForEach(0..<onboardingData.count, id: \.self) { i in
                       Circle()
                           .frame(width: 8, height: 8)
                           .foregroundColor(i == currentPageIndex ? .blue : .gray.opacity(0.5))
                   }
               }.padding(.bottom)
            }
            // MARK: - Next and Get Started Button
            Button(action: {
                if isLastPage {
                    isOnboardingComplete = true
                    delegate?.onboardingComplete()
                } else {
                    withAnimation {
                        currentPageIndex += 1
                    }
                }
            }) {
                Text(isLastPage ? "Get Started!" : "Next")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.bottom, 40)
        }
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if !isLastPage {
                    Button(action: {
                        isOnboardingComplete = true
                        delegate?.onboardingComplete()
                    }) {
                        Text("Skip")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .navigationDestination(isPresented: $isOnboardingComplete) {}
    }
}

#Preview {
    OnboardingView()
}
