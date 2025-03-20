//
//  ViewController.swift
//  HMS-Doctor
//
//  Created by RITIK RANJAN on 18/03/25.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let doctorOnboardingWalkthroughSwiftUI = DoctorOnboardingWalkthroughView()
        let hostingController = UIHostingController(rootView: doctorOnboardingWalkthroughSwiftUI)
        addChild(hostingController)
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
}
