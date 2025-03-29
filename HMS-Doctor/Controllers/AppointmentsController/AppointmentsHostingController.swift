import SwiftUI

class AppointmentsHostingController: UIHostingController<AppointmentView>, UISearchResultsUpdating, UISearchBarDelegate {

    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: AppointmentView(appointments: appointments))
    }

    // MARK: Internal

    let appointments: [Appointment] = []

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
