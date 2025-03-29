import SwiftUI

// MARK: - Models
struct PatientVitals {
    let bloodType: String
    let weight: String
    let height: String
}

struct MedicalRecord: Identifiable {
    let id = UUID()
    let date: Date
    let doctorName: String
    let diagnosis: String
    let recommendations: String
}

enum MedicalTab: String, CaseIterable {
    case records = "Records"
    case medications = "Medications"
    case labResults = "Lab Results"
    case notes = "Notes"
}

struct PatientProfileView: View {
    // MARK: - Properties
    let patient: Appointment
    @State private var selectedTab: MedicalTab = .records
    
    private let vitals = PatientVitals(
        bloodType: "A+",
        weight: "65 kg",
        height: "168 cm"
    )
    
    private let records = [
        MedicalRecord(
            date: Date().addingTimeInterval(-7*24*3600),
            doctorName: "Dr. Smith",
            diagnosis: "Common Cold",
            recommendations: "Rest and hydration"
        ),
        MedicalRecord(
            date: Date().addingTimeInterval(-14*24*3600),
            doctorName: "Dr. Johnson",
            diagnosis: "Annual Checkup",
            recommendations: "Continue current medications"
        )
    ]
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Profile Header
                VStack(spacing: 16) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                        .padding(.top)
                    
                    Text("Unknown Patient")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                
                // Patient Info Card
                VStack(spacing: 16) {
                    infoRow(title: "Age", value: "42 years")
                    Divider()
                    infoRow(title: "Gender", value: "Male")
                    Divider()
                    infoRow(title: "Phone", value: "+1 (555) 123-4567")
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                
                // Vitals Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Basic Info")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding(.horizontal)
                    
                    HStack(spacing: 12) {
                        // Blood Type Card
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 4) {
                                Image(systemName: "drop.fill")
                                    .font(.caption)
                                    .foregroundColor(.red)
                                Text("Blood Type")
                                    .font(.caption)
                                    .foregroundColor(Color(.systemGray))
                            }
                            Text(vitals.bloodType)
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 80)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                        
                        // Weight Card
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
                                Text("65")
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
                        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                        
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
                                Text("168")
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
                        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
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
                    case .medications:
                        emptyStateView(
                            icon: "pills",
                            message: "No medications available"
                        )
                    case .labResults:
                        emptyStateView(
                            icon: "flask",
                            message: "No lab results available"
                        )
                    case .notes:
                        emptyStateView(
                            icon: "note.text",
                            message: "No notes available"
                        )
                    }
                }
            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
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
    
    private func emptyStateView(icon: String, message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 36))
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
