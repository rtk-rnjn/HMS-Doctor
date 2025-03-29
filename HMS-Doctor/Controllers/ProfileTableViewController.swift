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

        Task {
            let loggedIn = await DataController.shared.autoLogin()
            if loggedIn {
                DispatchQueue.main.async {
                    self.staff = DataController.shared.staff
                    self.updateUI()
                }
            }

        }
    }

    // MARK: Private

    private func updateUI() {
        guard let staff else { return }

        staffNameLabel.text = staff.fullName
        staffSpecializationLabel.text = staff.specialization
    }

}
