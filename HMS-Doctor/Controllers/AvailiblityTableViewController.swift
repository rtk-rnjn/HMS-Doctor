//
//  AvailiblityTableViewController.swift
//  HMS-Doctor
//
//  Created by Shivam Kumar on 27/03/25.
//

import UIKit
import FSCalendar

class AvailiblityTableViewController: UITableViewController {
    
    
    @IBOutlet weak var calendarView: UIView!
    var calendar = FSCalendar()
    var sectionVisibility = [true, true, true, true]  // Boolean array to track visibility of each section
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.frame = calendarView.bounds
        calendarView.addSubview(calendar)
        
        calendar.scope = .month
        
        
        
    }
    
        
        
    @IBAction func onLeaveToggleButtonPressed(_ sender: UISwitch) {
        
    }
    
}
