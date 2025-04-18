import SwiftUI

// MARK: - Models
struct PatientVitals {
    let bloodType: String
    let weight: String
    let height: String
}

struct MedicalRecord: Identifiable {
    let id: UUID = .init()
    let date: Date
    let doctorName: String
    let diagnosis: String
    let recommendations: String
}

enum MedicalTab: String, CaseIterable {
    case records = "Records"
    case prescription = "Prescriptions"
}

struct PatientProfileView: View {

    // MARK: Internal

    weak var delegate: PatientHostingController?
    var patient: Patient?

    // @State private var appointments: Appointment

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                        .padding(.top)

                    Text(patient?.fullName ?? "Unknown Patient")
                        .font(.title2)
                        .fontWeight(.semibold)
                }

                VStack(spacing: 16) {
                    infoRow(title: "Age", value: String(patient?.age ?? 0))
                    Divider()
                    infoRow(title: "Gender", value: patient?.gender.rawValue ?? "Other")
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)

                VStack(alignment: .leading, spacing: 16) {
                    Text("Basic Info")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding(.horizontal)

                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 4) {
                                Image(systemName: "drop.fill")
                                    .font(.caption)
                                    .foregroundColor(.red)

                                Text("Blood Type")
                                    .font(.caption)
                                    .foregroundColor(Color(.systemGray))
                            }
                            Text(patient?.bloodGroup.rawValue ?? "O+")
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 80)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color(.systemBackground))
                        .cornerRadius(12)

                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 4) {
                                Image(systemName: "scalemass.fill")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                Text("Weight")
                                    .font(.caption)
                                    .foregroundColor(Color(.systemGray))
                            }
                            HStack(alignment: .firstTextBaseline, spacing: 2) {
                                Text(String(patient?.weight ?? 0))
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Text("kg")
                                    .font(.footnote)
                                    .foregroundColor(Color(.systemGray))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 80)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color(.systemBackground))
                        .cornerRadius(12)

                        // Height Card
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 4) {
                                Image(systemName: "ruler.fill")
                                    .font(.caption)
                                    .foregroundColor(.green)
                                Text("Height")
                                    .font(.caption)
                                    .foregroundColor(Color(.systemGray))
                            }
                            HStack(alignment: .firstTextBaseline, spacing: 2) {
                                Text(String(patient?.height ?? 0))
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Text("cm")
                                    .font(.footnote)
                                    .foregroundColor(Color(.systemGray))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 80)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }

                // Medical History Tabs
                VStack(spacing: 16) {
                    Picker("Medical History", selection: $selectedTab) {
                        ForEach(MedicalTab.allCases, id: \.self) { tab in
                            Text(tab.rawValue).tag(tab)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    // Tab Content
                    switch selectedTab {
                    case .records:
                        if records.isEmpty {
                            emptyStateView(
                                icon: "clipboard",
                                message: "No medical records available"
                            )
                        } else {
                            recordsList
                        }

                    case .prescription:
                        if let prescriptions = patient?.prescriptions as? [Prescription] {
                            ForEach(prescriptions) { prescription in
                                PrescriptionCardView(prescription: prescription)
                            }
                        } else {
                            emptyStateView(
                                icon: "pills",
                                message: "No medications available"
                            )
                        }
                    }
                }
            }
            .padding(.vertical)
            Button(action: {
                delegate?.performSegue(withIdentifier: "segueShowPrescriptionHostingController", sender: patient)
            }) {
                Text("Add Prescription")
            }
            .disabled(delegate?.appointment?.status == .completed || delegate?.appointment?.status == .cancelled || delegate?.appointment?.status == .confirmed)

            if !isMarkedComplete {
                Button(action: {
                    showConfirmation = true
                }) {
                    Text("Mark For Complete")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .disabled(delegate?.appointment?.status == .completed || delegate?.appointment?.status == .cancelled || delegate?.appointment?.status == .confirmed)
                .alert("Are you sure you want to complete the record?", isPresented: $showConfirmation) {
                    Button("Cancel", role: .cancel) {}
                    Button("OK", role: .destructive) {
                        Task {
                            let marked = await DataController.shared.markAppointmentAsDone(delegate?.appointment)
                            if marked {
                                DispatchQueue.main.async {
                                    isMarkedComplete = true
                                }
                            }
                        }
                    }
                }
            }
        }

        .background(Color(.systemGroupedBackground).ignoresSafeArea())

    }

    // MARK: Private

    @State private var showConfirmation = false

    @State private var isMarkedComplete = false

    @State private var selectedTab: MedicalTab = .records

    private let records: [MedicalRecord] = []

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    private var recordsList: some View {
        VStack(spacing: 12) {
            ForEach(records) { record in
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(dateFormatter.string(from: record.date))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(record.doctorName)
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }

                    Text(record.diagnosis)
                        .font(.headline)

                    Text(record.recommendations)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Supporting Views
    private func infoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .foregroundColor(.primary)
        }
    }

    private func emptyStateView(icon: String, message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(Color(.systemGray3))

            Text(message)
                .font(.body)
                .foregroundColor(Color(.systemGray))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 200)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

// MARK: - Vital Card View
struct VitalCard: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Text(value)
                .font(.headline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}
