import SwiftUI

class DoctorProfileHostingController: UIHostingController<DoctorProfileView> {
    required init?(coder: NSCoder) {
        let swiftUIView = DoctorProfileView()
        super.init(coder: coder, rootView: swiftUIView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Profile"
    }
} 