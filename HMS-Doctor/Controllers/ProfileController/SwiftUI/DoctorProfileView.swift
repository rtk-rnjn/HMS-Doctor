import SwiftUI

struct DoctorProfileView: View {
    var doctor: Staff?
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.horizontalSizeClass) var sizeClass

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Profile Header
                VStack(spacing: 16) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: sizeClass == .regular ? 140 : 120, height: sizeClass == .regular ? 140 : 120)
                        .foregroundColor(.blue.opacity(0.7))
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 4)
                        )

                    // Name with "Dr." prefix
                    Text("Dr. \(doctor?.fullName ?? "Name")")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)

                    // Redesigned status badge
                    Text(doctor?.onLeave ?? false ? "Inactive" : "Active")
                        .font(.system(.caption, design: .rounded).weight(.semibold))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(doctor?.onLeave ?? false ? Color.orange.opacity(0.9) : Color.green.opacity(0.9))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                       
                }
                .padding(.top, 20)
                .padding(.bottom, 12)

                // Information Sections with adaptive layout
                LazyVGrid(columns: [GridItem(.adaptive(minimum: sizeClass == .regular ? 500 : 300))], spacing: 24) {
                    // Personal Information Section
                    InfoSectionCard(title: "Personal Information", systemImage: "person.text.rectangle.fill") {
                        InfoRow(icon: "person.fill", iconColor: .blue, label: "Full Name", value: doctor?.fullName)
                        Divider().padding(.leading, 40).padding(.vertical, 6)
                        InfoRow(icon: "calendar", iconColor: .blue, label: "Date of Birth", value: formatDate(doctor?.dateOfBirth ?? Date()))
                        Divider().padding(.leading, 40).padding(.vertical, 6)
                        InfoRow(icon: "person.2.fill", iconColor: .blue, label: "Gender", value: "Other")
                        Divider().padding(.leading, 40).padding(.vertical, 6)
                        InfoRow(icon: "phone.fill", iconColor: .blue, label: "Contact Number", value: doctor?.contactNumber)
                        Divider().padding(.leading, 40).padding(.vertical, 6)
                        InfoRow(icon: "envelope.fill", iconColor: .blue, label: "Email Address", value: doctor?.emailAddress)
                    }

                    // Professional Information Section
                    InfoSectionCard(title: "Professional Information", systemImage: "stethoscope") {
                        InfoRow(icon: "creditcard.fill", iconColor: .blue, label: "Medical License Number", value: doctor?.licenseId)
                        Divider().padding(.leading, 40).padding(.vertical, 6)
                        InfoRow(icon: "cross.case.fill", iconColor: .blue, label: "Specialization", value: doctor?.specialization)
                        if doctor?.yearOfExperience ?? 1 > 0 {
                            Divider().padding(.leading, 40).padding(.vertical, 6)
                            InfoRow(icon: "clock.fill", iconColor: .blue, label: "Years of Experience", value: "\(doctor?.yearOfExperience ?? 0) Years")
                        }
                    }

                    // Department Section
                    InfoSectionCard(title: "Department", systemImage: "building.2.fill") {
                        InfoRow(icon: "building.2.fill", iconColor: .blue, label: "Department", value: doctor?.department)
                    }
                }

                // Bottom padding for scroll view
                Color.clear.frame(height: 20)

                // Action Buttons
                VStack(spacing: 16) {
                    // Change Password Button
                    Button(action: {
                        // Navigate to Change Password View
                    }) {
                        HStack {
                            Image(systemName: "lock.rotation")
                                .font(.headline)
                            Text("Change Password")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blue.gradient)
                        )
                        .padding(.horizontal)
                    }

                    // Logout Button
                    Button(action: {
                        // Show Logout Confirmation Alert
                    }) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(.headline)
                            Text("Logout")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.red.gradient)
                        )
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical, 8)
            }
            .padding(.horizontal)
        }
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        .navigationBarTitleDisplayMode(.inline)
    }

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
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .padding(.bottom, 4)

            Text(value)
                .font(.title3)
                .fontWeight(.bold)

            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
        )
    }
}

struct InfoSectionCard<Content: View>: View {
    // MARK: Lifecycle
    init(title: String, systemImage: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.systemImage = systemImage
        self.content = content()
    }

    // MARK: Internal
    let title: String
    let systemImage: String?
    let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                if let systemImage = systemImage {
                    Image(systemName: systemImage)
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                
                Text(title)
                    .font(.system(.title3, design: .rounded).weight(.bold))
            }
            .padding(.leading, 8)

            VStack(spacing: 0) {
                content
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
            )
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
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.1))
                    .frame(width: 36, height: 36)
                
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .font(.system(size: 16, weight: .medium))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text(value ?? "Not provided")
                    .font(.system(.body, design: .rounded).weight(.medium))
            }

            Spacer()
        }
        .padding(.vertical, 4)
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
                .frame(width: 10, height: 10)

            Text(days)
                .font(.system(.subheadline, design: .rounded).weight(.medium))
                .frame(width: 120, alignment: .leading)

            Spacer()

            Text(hours)
                .font(.system(.subheadline, design: .rounded))
                .foregroundColor(.gray)
        }
        .padding(.vertical, 6)
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
