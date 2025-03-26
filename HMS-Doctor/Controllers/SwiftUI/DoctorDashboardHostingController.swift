import SwiftUI

class DoctorDashboardHostingController: UIHostingController<DoctorDashboardView> {
    required init?(coder: NSCoder) {
        let swiftUIView = DoctorDashboardView()
        super.init(coder: coder, rootView: swiftUIView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Dashboard"
        
        // Enable large titles
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
} 