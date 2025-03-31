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

        let appointment: [Appointment] = [
            .init(patientId: "", doctorId: "", startDate: Date(), endDate: Date())
        ]
        self.rootView.todaysAppointments = appointment
    }
}
