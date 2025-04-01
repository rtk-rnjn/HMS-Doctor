//
//  PatientHostingController.swift
//  HMS-Doctor
//
//  Created by RITIK RANJAN on 31/03/25.
//

import SwiftUI

class PatientHostingController: UIHostingController<PatientProfileView> {

    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: PatientProfileView())
    }

    // MARK: Internal

    var appointment: Appointment?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        rootView.patient = appointment?.patient
        rootView.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowPrescriptionHostingController", let destination = segue.destination as? UINavigationController, let prescriptionHostingController = destination.viewControllers.first as? PrescriptionHostingController {
            prescriptionHostingController.patient = appointment?.patient
        }
    }
}
