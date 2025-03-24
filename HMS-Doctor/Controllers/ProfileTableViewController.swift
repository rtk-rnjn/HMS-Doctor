//
//  ProfileTableViewController.swift
//  HMS-Doctor
//
//  Created by RITIK RANJAN on 24/03/25.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    // MARK: Internal

    var staff: Staff?

    @IBOutlet var staffNameLabel: UILabel!
    @IBOutlet var staffSpecializationLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        staff = DataController.shared.staff
        updateUI()
    }

    // MARK: Private

    private func updateUI() {
        guard let staff else { return }

        staffNameLabel.text = staff.fullName
        staffSpecializationLabel.text = staff.specializations.joined(separator: ", ")
    }

}
