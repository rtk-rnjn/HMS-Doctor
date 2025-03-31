import SwiftUI

class DoctorProfileHostingController: UIHostingController<DoctorProfileView> {

    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        let swiftUIView = DoctorProfileView()
        super.init(coder: coder, rootView: swiftUIView)
    }

    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Profile"
        rootView.doctor = DataController.shared.staff
    }
}
