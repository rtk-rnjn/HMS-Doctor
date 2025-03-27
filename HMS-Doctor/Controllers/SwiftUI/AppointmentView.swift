import SwiftUI

struct AppointmentView: View {
    // MARK: - Properties
    @State private var selectedDate: Date = .init()
    @State private var showingAllAppointments = false
    private let appointments: [Appointment]
    
    // Date formatter for displaying dates
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter
    }()
    
    // MARK: - Computed Properties
    private var displayedAppointments: [Appointment] {
        if showingAllAppointments {
            return appointments.sorted { $0.date < $1.date }
        } else {
            return appointments.filter { appointment in
                Calendar.current.isDate(appointment.date, inSameDayAs: selectedDate)
            }
        }
    }

    // MARK: - Initialization
    init(appointments: [Appointment] = [
        Appointment(patientName: "John Doe", appointmentType: "Regular Checkup", time: "9:00 AM", date: Date(), status: .confirmed),
        Appointment(patientName: "Sarah Smith", appointmentType: "Follow-up", time: "10:30 AM", date: Date(), status: .confirmed),
        Appointment(patientName: "Mike Johnson", appointmentType: "Regular Checkup", time: "11:45 AM", date: Date(), status: .completed),
        Appointment(patientName: "Emily Wilson", appointmentType: "Regular Checkup", time: "2:15 PM", date: Date(), status: .pending)
    ]) {
        self.appointments = appointments
    }

    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Calendar View
                DatePicker("Select Date",
                          selection: $selectedDate,
                          displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .onChange(of: selectedDate) { _ in
                        if showingAllAppointments {
                            showingAllAppointments = false
                        }
                    }

                // Selected Date Header
                HStack {
                    Text(showingAllAppointments ? "All Appointments" : "Appointments")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)

                    Spacer()

                    Button(action: {
                        showingAllAppointments.toggle()
                    }) {
                        Text(showingAllAppointments ? "Filter by Date" : "See All")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
                .padding(.bottom, 4)

                // Appointments List
                LazyVStack(spacing: 12) {
                    if displayedAppointments.isEmpty {
                        noAppointmentsView
                    } else {
                        ForEach(displayedAppointments) { appointment in
                            AppointmentCard(appointment: appointment)
                        }
                    }
                }
                .padding()
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }

    // MARK: - Supporting Views
    private var noAppointmentsView: some View {
        VStack(spacing: 16) {
            Spacer()

            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 60))
                .foregroundColor(Color(.systemGray3))
                .padding(.bottom, 8)

            Text("No Appointments Found")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            Text(showingAllAppointments
                 ? "You don't have any appointments scheduled."
                 : "You don't have any appointments scheduled for \(dateFormatter.string(from: selectedDate)). Select a different date to view other appointments.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            if !showingAllAppointments {
                Button(action: {
                    selectedDate = Date()
                }) {
                    Text("Go to Today")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top, 8)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 60)
    }
}

// MARK: - Enhanced Appointment Card
struct EnhancedAppointmentCard: View {
    let appointment: Appointment
    
    var body: some View {
        NavigationLink(destination: PatientProfileView(patient: appointment)) {
            VStack(alignment: .leading, spacing: 12) {
                // Patient Info Row
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(appointment.patientName)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        Text(appointment.appointmentType)
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    // Time with background
                    Text(appointment.time)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.primary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemGray6))
                        )
                }
                
                // Status Badge
                HStack {
                    Spacer()
                    StatusBadge(status: appointment.status)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Status Badge
struct StatusBadge: View {
    let status: AppointmentStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.system(size: 13, weight: .medium))
            .foregroundColor(statusColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(statusColor.opacity(0.12))
            .clipShape(Capsule())
    }
    
    private var statusColor: Color {
        switch status {
        case .confirmed: return .blue
        case .completed: return .green
        case .pending: return .orange
        case .canceled: return .red
        }
    }
}
