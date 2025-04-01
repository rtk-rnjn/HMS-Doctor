//
//  PrescriptionHostingController.swift
//  HMS-Doctor
//
//  Created by RITIK RANJAN on 31/03/25.
//

import SwiftUI

class PrescriptionHostingController: UIHostingController<PrescriptionFormView> {

    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: PrescriptionFormView())
    }

    // MARK: Internal

    var medicines: [Medicine] = []
    var patient: Patient?

    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.delegate = self
    }
}
