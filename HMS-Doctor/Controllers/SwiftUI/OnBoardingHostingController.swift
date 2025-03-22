//
//  OnBoardingHostingController.swift
//  HMS-Doctor
//
//  Created by RITIK RANJAN on 18/03/25.
//

import SwiftUI

class OnBoardingHostingController: UIHostingController<OnboardingView> {

    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        let swiftUIView = OnboardingView()
        super.init(coder: coder, rootView: swiftUIView)
    }

    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.delegate = self
    }

    func onboardingComplete() {
        performSegue(withIdentifier: "segueShowSignInViewController", sender: self)
    }
}
