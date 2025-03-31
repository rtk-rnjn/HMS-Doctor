import SwiftUI

class DoctorDashboardHostingController: UIHostingController<DoctorDashboardView> {

    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        let swiftUIView = DoctorDashboardView()
        super.init(coder: coder, rootView: swiftUIView)
    }

    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Dashboard"

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always

        Task {
            let appointments = await DataController.shared.fetchAppointments()
            rootView.todaysAppointments = appointments.filter { $0.startDate.isToday() }
        }
    }
}
