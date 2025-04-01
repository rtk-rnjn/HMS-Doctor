//
//  PrescriptionHostingController.swift
//  HMS-Doctor
//
//  Created by RITIK RANJAN on 31/03/25.
//

import SwiftUI

class PrescriptionHostingController: UIHostingController<PrescriptionFormView> {
    var medicines: [Medicine] = []
    var patient: Patient?

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: PrescriptionFormView())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.delegate = self
    }
}
