import SwiftUI

struct DoctorProfileView: View {

    // MARK: Internal

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Profile Header Card
                VStack(spacing: 12) {
                    Button(action: { showingImagePicker = true }) {
                        if let image = profileImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.blue.opacity(0.3), lineWidth: 2)
                                )
                        } else {
                            Circle()
                                .fill(Color.gray.opacity(0.7))
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .padding(24)
                                        .foregroundColor(.white)
                                )
                                .overlay(
                                    Circle()
                                        .stroke(Color.blue.opacity(0.3), lineWidth: 2)
                                )
                        }
                    }
                    .overlay(
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 30, height: 30)
                            .overlay(
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                            )
                            .offset(x: 35, y: 35),
                        alignment: .center
                    )

                    Text(dataController.staff?.fullName ?? "Amit Kumar")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text(dataController.staff?.specializations.first ?? "Cardiologist")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                .padding(.vertical, 24)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                )

                // Statistics Section
                HStack(spacing: 0) {
                    StatItem(value: patientCount, title: "Patients", icon: "person.3.fill")
                    Divider().frame(height: 40)
                    StatItem(value: "\(experience) yrs", title: "Experience", icon: "clock.fill")
                    Divider().frame(height: 40)
                    StatItem(value: rating, title: "Rating", icon: "star.fill")
                }
                .padding(.vertical, 20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                )

                // Professional Information Section
                VStack(alignment: .leading, spacing: 20) {
                    Text("Professional Information")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.bottom, 4)

                    InfoRow(icon: "creditcard.fill", iconColor: .blue, title: "License", value: dataController.staff?.licenseId ?? "I421")

                    InfoRow(icon: "stethoscope", iconColor: .blue, title: "Specializations", value: dataController.staff?.specializations.joined(separator: ", ") ?? "Cardiologist")
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                )

                // Hospital Information Section
                VStack(alignment: .leading, spacing: 20) {
                    Text("Hospital Information")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.bottom, 4)

                    InfoRow(icon: "building.2", iconColor: .blue, title: "Hospital", value: "Mayo Clinic")

                    InfoRow(icon: "mappin.and.ellipse", iconColor: .blue, title: "Address", value: "200 First St. SW, Rochester, MN 55905")
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                )

                // Working Hours
                VStack(alignment: .leading, spacing: 16) {
                    Text("Working Hours")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.bottom, 4)

                    WorkingHourRow(days: "Monday-Friday", hours: "9:00 AM - 5:00 PM", isAvailable: true)
                    WorkingHourRow(days: "Saturday", hours: "9:00 AM - 1:00 PM", isAvailable: true)
                    WorkingHourRow(days: "Sunday", hours: "Closed", isAvailable: false)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                )

                // Contact Details
                VStack(alignment: .leading, spacing: 16) {
                    Text("Contact Details")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.bottom, 4)

                    Button(action: { UIPasteboard.general.string = dataController.staff?.emailAddress ?? "" }) {
                        InfoRow(icon: "envelope.fill", iconColor: .blue, title: "Email", value: dataController.staff?.emailAddress ?? "dr.kumar@mayoclinic.com")
                    }

                    Button(action: {
                        guard let phone = dataController.staff?.contactNumber,
                              let url = URL(string: "tel://\(phone.replacingOccurrences(of: " ", with: ""))")
                        else { return }
                        UIApplication.shared.open(url)
                    }) {
                        InfoRow(icon: "phone.fill", iconColor: .blue, title: "Phone", value: dataController.staff?.contactNumber ?? "(555) 123-4567")
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                )
            }
            .padding(.horizontal)
            .padding(.bottom, 16)
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $profileImage)
        }
    }

    // MARK: Private

    @ObservedObject private var dataController: DataController = .shared
    @State private var showingImagePicker = false
    @State private var profileImage: UIImage?

    // Sample data - replace with actual data from your model
    private let patientCount = "1.2k"
    private let experience = "8+"
    private let rating = "4.8"

}

struct StatItem: View {
    let value: String
    let title: String
    let icon: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 24))
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

struct InfoRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .font(.system(size: 20))
                .frame(width: 24, height: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text(value)
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

// Preview Provider
struct DoctorProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DoctorProfileView()
        }
    }
}
