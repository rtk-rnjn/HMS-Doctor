import SwiftUI

struct DoctorProfileView: View {
    var doctor: Staff?
    weak var delegate: DoctorProfileHostingController?

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.horizontalSizeClass) var sizeClass

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: sizeClass == .regular ? 140 : 120, height: sizeClass == .regular ? 140 : 120)
                        .foregroundColor(Color(.systemGray4))
                        .clipShape(Circle())

                    // Name with "Dr." prefix
                    Text("Dr. \(doctor?.fullName ?? "Name")")
                        .font(.title2.bold())

                    // Redesigned smaller status badge
                    Text(doctor?.onLeave ?? false ? "Inactive" : "Active")
                        .font(.caption.weight(.medium))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(doctor?.onLeave ?? false ? Color.orange : Color.green)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
                .padding(.top, 16)
                .padding(.bottom, 8)

                // Information Sections with adaptive layout
                LazyVGrid(columns: [GridItem(.adaptive(minimum: sizeClass == .regular ? 500 : 300))], spacing: 20) {
                    // Personal Information Section
                    InfoSectionCard(title: "Personal Information") {
                        InfoRow(icon: "person.fill", iconColor: .blue, label: "Full Name", value: doctor?.fullName)
                        Divider().padding(.leading, 40)
                        InfoRow(icon: "calendar", iconColor: .blue, label: "Date of Birth", value: formatDate(doctor?.dateOfBirth ?? Date()))
                        Divider().padding(.leading, 40)
                        InfoRow(icon: "person.2.fill", iconColor: .blue, label: "Gender", value: "Other")
                        Divider().padding(.leading, 40)
                        InfoRow(icon: "phone.fill", iconColor: .blue, label: "Contact Number", value: doctor?.contactNumber)
                        Divider().padding(.leading, 40)
                        InfoRow(icon: "envelope.fill", iconColor: .blue, label: "Email Address", value: doctor?.emailAddress)
                    }

                    // Professional Information Section
                    InfoSectionCard(title: "Professional Information") {
                        InfoRow(icon: "creditcard.fill", iconColor: .blue, label: "Medical License Number", value: doctor?.licenseId)
                        Divider().padding(.leading, 40)
                        InfoRow(icon: "cross.case.fill", iconColor: .blue, label: "Specialization", value: doctor?.specialization)
                        if doctor?.yearOfExperience ?? 1 > 0 {
                            Divider().padding(.leading, 40)
                            InfoRow(icon: "clock.fill", iconColor: .blue, label: "Years of Experience", value: "\(doctor?.yearOfExperience ?? 0) Years")
                        }
                    }

                    // Department Section
                    InfoSectionCard(title: "Department") {
                        InfoRow(icon: "building.2.fill", iconColor: .blue, label: "Department", value: doctor?.department)
                    }
                }

                // Bottom padding for scroll view
                Color.clear.frame(height: 20)

                // Change Password Button
                Button(action: {
                    delegate?.performSegue(withIdentifier: "segueShowChangePasswordTableViewController", sender: nil)
                }) {
                    Text("Change Password")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }

                // Logout Button
                Button(action: {
                    showAlert = true
                }) {
                    Text("Logout")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
            .padding(.horizontal)
        }
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        .navigationBarTitleDisplayMode(.inline)
        .alert("Are you sure?", isPresented: $showAlert)  {
            Button("Cancel", role: .cancel) {}
            Button("Logout", role: .destructive) {
                DataController.shared.logout()
                delegate?.performSegue(withIdentifier: "segueShowOnBoardingHostingController", sender: nil)
            }
        }
    }

    @State private var showAlert: Bool = false
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter.string(from: date)
    }
}

struct StatItem: View {
    let value: String
    let title: String
    let icon: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .padding(.bottom, 2)

            Text(value)
                .font(.title3)
                .fontWeight(.bold)

            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}

struct InfoSectionCard<Content: View>: View {

    // MARK: Lifecycle

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    // MARK: Internal

    let title: String
    let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.title3.bold())
                .padding(.leading, 8)

            VStack(spacing: 0) {
                content
            }
            .padding(16)
            .background(Color(.systemBackground))
            .cornerRadius(16)
        }
    }
}

struct InfoRow: View {
    let icon: String
    let iconColor: Color
    let label: String
    let value: String?

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .font(.title3)
                .frame(width: 24, height: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text(value ?? "Value")
                    .font(.body)
            }

            Spacer()
        }
    }
}

struct WorkingHourRow: View {
    let days: String
    let hours: String
    let isAvailable: Bool

    var body: some View {
        HStack {
            Circle()
                .fill(isAvailable ? Color.green : Color.red)
                .frame(width: 8, height: 8)

            Text(days)
                .frame(width: 120, alignment: .leading)

            Spacer()

            Text(hours)
                .foregroundColor(.gray)
        }
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
