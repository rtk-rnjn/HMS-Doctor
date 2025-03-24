//
//  SetAvailablityTableViewController.swift
//  HMS-Doctor
//
//  Created by RITIK RANJAN on 24/03/25.
//

import UIKit

class SetAvailablityTableViewController: UITableViewController {

    // MARK: Internal

    @IBOutlet var datePicker: UIDatePicker!
    var unavailableDates: [Date: UnavailablePeriod] = [:]
    private var isAvailabilityHidden: Bool = false

    @IBOutlet var startDatePicker: UIDatePicker!
    @IBOutlet var endDatePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }

    @IBAction func dateChanged(_ sender: UIDatePicker) {
        let date = sender.date
        if unavailableDates[date] != nil {
            unavailableDates.removeValue(forKey: date)
        } else {
            let period = UnavailablePeriod(startDate: date, endDate: date)
            unavailableDates[date] = period
        }
        print(unavailableDates)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
           return isAvailabilityHidden ? 2 : 3  
       }
    
    @IBAction func availabilityToggleButtonOn(_ sender: UISwitch) {
        isAvailabilityHidden = sender.isOn
        tableView.reloadData()
        }
    
    // MARK: Private

    private func updateUI() {
        datePicker.minimumDate = Date()
        startDatePicker.minimumDate = Date()
        endDatePicker.minimumDate = Date()
    }

}
