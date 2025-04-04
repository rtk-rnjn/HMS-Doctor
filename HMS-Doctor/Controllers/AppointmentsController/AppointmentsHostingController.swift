import SwiftUI

class AppointmentsHostingController: UIHostingController<AppointmentView>, UISearchResultsUpdating, UISearchBarDelegate {

    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: AppointmentView(appointments: appointments))
    }

    // MARK: Internal

    var appointments: [Appointment] = []
    var searchText: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareSearchController()

        rootView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        Task {
            appointments = await DataController.shared.fetchAppointments()
            self.rootView.appointments = appointments
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowPatientHostingController", let appointment = sender as? Appointment {
            let destination = segue.destination as? PatientHostingController
            destination?.appointment = appointment
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            self.rootView.appointments = appointments
            return
        }

        if searchText.isEmpty || searchText == "" {
            self.rootView.appointments = appointments
            return
        }

        self.searchText = searchText
        self.rootView.appointments = appointments.filter {
            $0.patient?.fullName?.contains(searchText) ?? false
        }
    }

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
