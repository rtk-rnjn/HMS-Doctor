//
//  AvailabilityHostingViewController.swift
//  HMS-Doctor
//
//  Created by Shivam Kumar on 27/03/25.
//

import UIKit
import SwiftUI

class AvailabilityHostingViewController: UIHostingController<AvailabilityView> {
    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: AvailabilityView())
    }

    var previousLeaveRequest: LeaveRequest?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.previousLeaveRequest = DataController.shared.fetchStoredLeaveRequest()

        Task {
            let appointments: [Appointment] = await DataController.shared.fetchAppointments()
            DispatchQueue.main.async {
                self.rootView.appointments = appointments
                self.rootView.previousLeaveRequest = self.previousLeaveRequest
            }
        }
    }
}
