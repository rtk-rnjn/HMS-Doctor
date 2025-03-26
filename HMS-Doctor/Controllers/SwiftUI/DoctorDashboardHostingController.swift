import SwiftUI

class DoctorDashboardHostingController: UIHostingController<DoctorDashboardView> {
    required init?(coder: NSCoder) {
        let swiftUIView = DoctorDashboardView()
        super.init(coder: coder, rootView: swiftUIView)
    }
}
