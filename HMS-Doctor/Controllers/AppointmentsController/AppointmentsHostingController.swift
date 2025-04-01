import SwiftUI

class AppointmentsHostingController: UIHostingController<AppointmentView>, UISearchResultsUpdating, UISearchBarDelegate {

    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: AppointmentView(appointments: appointments))
    }

    // MARK: Internal

    var appointments: [Appointment] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareSearchController()
        Task {
            appointments = await DataController.shared.fetchAppointments()
            self.rootView.appointments = appointments
        }

        rootView.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowPatientHostingController", let appointment = sender as? Appointment {
            let destination = segue.destination as? PatientHostingController
            destination?.appointment = appointment
        }
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
