import UIKit
import SwiftUI

class AppointmentsViewController: UIViewController {
    
    // MARK: Internal
    
    let appointments: [Appointment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setupAppointmentView()
    }
    
    // MARK: Private
    
    private func configureNavigationBar() {
        // Set the title
        title = "Appointments"
        
        // Configure navigation bar appearance
        if let navigationController {
            // Enable large titles
            navigationController.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always
            
            // Configure navigation bar appearance for both normal and large title states
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemBackground
            
            // Large title attributes
            appearance.largeTitleTextAttributes = [
                .foregroundColor: UIColor.label,
                .font: UIFont.systemFont(ofSize: 34, weight: .bold)
            ]
            
            // Normal title attributes
            appearance.titleTextAttributes = [
                .foregroundColor: UIColor.label,
                .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
            ]
            
            // Apply the appearance to all navigation bar states
            navigationController.navigationBar.standardAppearance = appearance
            navigationController.navigationBar.scrollEdgeAppearance = appearance
            navigationController.navigationBar.compactAppearance = appearance
            
            // Ensure the navigation bar is not translucent
            navigationController.navigationBar.isTranslucent = false
        }
    }
    
    private func setupAppointmentView() {
        
        // Create a calendar for date manipulation
        let calendar = Calendar.current
        
        // Get today's date
        let today = Date()
        
        // Create sample appointments with different dates
        let appointments: [Appointment] = []
        
        // Create the SwiftUI view
        let appointmentView = AppointmentView(appointments: appointments)
        let hostingController = UIHostingController(rootView: appointmentView)
        
        addChild(hostingController)
        
        // Add the hosting controller's view as a subview
        view.addSubview(hostingController.view)
        
        // Configure the hosting controller's view constraints
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Notify the hosting controller that it was moved to this parent
        hostingController.didMove(toParent: self)
    }
}
