import SwiftUI

class AppointmentsHostingController: UIHostingController<AppointmentView>, UISearchResultsUpdating, UISearchBarDelegate {

    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: AppointmentView(appointments: appointments))
    }

    // MARK: Internal

    let appointments = [
        Appointment(
            patientName: "John Doe",
            appointmentType: "Regular Checkup",
            time: "9:00 AM",
            date: Date(),
            status: .confirmed
        ),

        Appointment(
            patientName: "Sarah Smith",
            appointmentType: "Follow-up",
            time: "10:30 AM",
            date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
            status: .confirmed
        ),

        // Day after tomorrow
        Appointment(
            patientName: "Mike Johnson",
            appointmentType: "Consultation",
            time: "11:45 AM",
            date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
            status: .completed
        ),

        // Next week
        Appointment(
            patientName: "Emily Wilson",
            appointmentType: "Emergency",
            time: "2:15 PM",
            date: Calendar.current.date(byAdding: .day, value: 7, to: Date())!,
            status: .pending
        ),

        // Next month
        Appointment(
            patientName: "David Brown",
            appointmentType: "Follow-up",
            time: "3:30 PM",
            date: Calendar.current.date(byAdding: .month, value: 1, to: Date())!,
            status: .canceled
        )
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareSearchController()
    }

    func updateSearchResults(for searchController: UISearchController) {}

    // MARK: Private

    private var searchController: UISearchController = .init()

    private func prepareSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Appointments"

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

}
