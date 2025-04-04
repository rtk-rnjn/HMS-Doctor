import SwiftUI

struct DoctorProfileView: View {
    var doctor: Staff?
    weak var delegate: DoctorProfileHostingController?
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.colorScheme) private var colorScheme
    @State private var showAlert: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Profile Header
                VStack(spacing: 20) {
                    // Profile Image
                    ZStack {
                        Circle()
                            .fill(Color(.tertiarySystemGroupedBackground))
                            .frame(width: sizeClass == .regular ? 160 : 140)
                        
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: sizeClass == .regular ? 140 : 120)
                            .foregroundColor(Color(.systemGray3))
                    }
                    
                    // Name and Status
                    VStack(spacing: 12) {
                        Text("Dr. \(doctor?.fullName ?? "Name")")
                            .font(.title.bold())
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                        
                        StatusBadge(status: doctor?.onLeave ?? false ? .onLeave : .active)
                    }
                }
                .padding(.top, 20)
                
                // Information Cards
                VStack(spacing: 24) {
                    // Personal Information
                    InfoCard(title: "Personal Information") {
                        InfoItem(icon: "person.fill", label: "Full Name", value: doctor?.fullName)
                        InfoItem(icon: "calendar", label: "Date of Birth", value: formatDate(doctor?.dateOfBirth ?? Date()))
                        InfoItem(icon: "person.2.fill", label: "Gender", value: doctor?.gender.rawValue ?? "N/A")
                        InfoItem(icon: "phone.fill", label: "Contact Number", value: doctor?.contactNumber)
                        InfoItem(icon: "envelope.fill", label: "Email Address", value: doctor?.emailAddress)
                    }
                    
                    // Professional Information
                    InfoCard(title: "Professional Information") {
                        InfoItem(icon: "creditcard.fill", label: "Medical License", value: doctor?.licenseId)
                        InfoItem(icon: "cross.case.fill", label: "Specialization", value: doctor?.specialization)
                        if doctor?.yearOfExperience ?? 1 > 0 {
                            InfoItem(icon: "clock.fill", label: "Experience", value: "\(doctor?.yearOfExperience ?? 0) Years")
                        }
                    }
                    
                    // Department Information
                    InfoCard(title: "Department") {
                        InfoItem(icon: "building.2.fill", label: "Department", value: doctor?.department)
                    }
                }
                
                // Action Buttons
                VStack(spacing: 16) {
                    Button(action: {
                        delegate?.performSegue(withIdentifier: "segueShowChangePasswordTableViewController", sender: nil)
                    }) {
                        HStack {
                            Image(systemName: "lock.fill")
                            Text("Change Password")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(12)
                    }
                    
                    Button(action: { showAlert = true }) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Logout")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .foregroundColor(.red)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 32)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .alert("Are you sure?", isPresented: $showAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Logout", role: .destructive) {
                DataController.shared.logout()
                delegate?.performSegue(withIdentifier: "segueShowOnBoardingHostingController", sender: nil)
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter.string(from: date)
    }
}

// MARK: - Supporting Views
struct InfoCard<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(title)
                .font(.title3.bold())
                .foregroundColor(.primary)
                .padding(.horizontal)
            
            VStack(spacing: 0) {
                content
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(16)
        }
        .padding(.horizontal)
    }
}

struct InfoItem: View {
    let icon: String
    let label: String
    let value: String?
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(value ?? "Not provided")
                    .font(.body)
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
        .padding(.vertical, 12)
    }
}

// UIKit Image Picker Integration
struct ImagePicker: UIViewControllerRepresentable {

    // MARK: Internal

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        // MARK: Lifecycle

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        // MARK: Internal

        let parent: ImagePicker

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    @Binding var image: UIImage?

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // MARK: Private

    @Environment(\.presentationMode) private var presentationMode

}
