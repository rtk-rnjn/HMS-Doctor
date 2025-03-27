import SwiftUI

struct DoctorDashboardView: View {

    // MARK: Lifecycle

    // Initializer with default values for preview and testing
    init(
        totalAppointments: Int = 10,
        completedAppointments: Int = 8,
        canceledAppointments: Int = 2,
        rating: Double = 4.8,
        todaysAppointments: [Appointment] = [
            Appointment(patientName: "John Doe", appointmentType: "Regular Checkup", time: "9:00 AM", date: Date(), status: .confirmed),
            Appointment(patientName: "Sarah Smith", appointmentType: "Follow-up", time: "10:30 AM", date: Date(), status: .confirmed),
            Appointment(patientName: "Mike Johnson", appointmentType: "Regular Checkup", time: "11:45 AM", date: Date(), status: .completed)
        ],
        emergencyAlerts: [EmergencyAlert] = [
            EmergencyAlert(title: "Urgent Care Required", details: "Patient with severe chest pain", timeAgo: "10 mins ago", priority: .urgent),
            EmergencyAlert(title: "Lab Results", details: "Critical test results available", timeAgo: "30 mins ago", priority: .normal)
        ]
    ) {
        self.totalAppointments = totalAppointments
        self.completedAppointments = completedAppointments
        self.canceledAppointments = canceledAppointments
        self.rating = rating
        self.todaysAppointments = todaysAppointments
        self.emergencyAlerts = emergencyAlerts
    }

    // MARK: Internal

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                // Monthly Overview Title
                Text("Monthly Overview")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .padding(.horizontal)
                    .padding(.top, 16)
                    .padding(.bottom, 12)

                // Overview Grid
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    // Total Appointments Card
                    DashboardCard(
                        value: String(totalAppointments),
                        title: "Total Appointments",
                        icon: "calendar",
                        backgroundColor: Color(.systemBlue).opacity(0.12),
                        iconColor: .blue
                    )

                    // Completed Appointments Card
                    DashboardCard(
                        value: String(completedAppointments),
                        title: "Completed",
                        icon: "checkmark.circle.fill",
                        backgroundColor: Color.green.opacity(0.12),
                        iconColor: .green
                    )

                    // Canceled Appointments Card
                    DashboardCard(
                        value: String(canceledAppointments),
                        title: "Canceled",
                        icon: "xmark.circle.fill",
                        backgroundColor: Color.red.opacity(0.12),
                        iconColor: .red
                    )

                    // Rating Card
                    DashboardCard(
                        value: String(format: "%.1f", rating),
                        title: "Rating",
                        icon: "star.fill",
                        backgroundColor: Color.orange.opacity(0.12),
                        iconColor: .orange
                    )
                }
                .padding(.horizontal)

                // Today's Appointments Section
                HStack {
                    Text("Today's Appointments")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)

                    Spacer()

                    Button(action: {
                        // Action to see all appointments
                    }) {
                        Text("See All")
                            .font(.system(size: 16))
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 32)
                .padding(.bottom, 12)

                // Appointments List
                VStack(spacing: 12) {
                    ForEach(todaysAppointments) { appointment in
                        AppointmentCard(appointment: appointment)
                    }
                }
                .padding(.horizontal)

                // Emergency Alerts Section
                HStack {
                    Text("Emergency Alerts")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)

                    Spacer()

                    Button(action: {
                        // Action to see all alerts
                    }) {
                        Text("See All")
                            .font(.system(size: 16))
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 32)
                .padding(.bottom, 12)

                // Alerts List
                VStack(spacing: 12) {
                    ForEach(emergencyAlerts) { alert in
                        AlertCard(alert: alert)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 20)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }

    // MARK: Private

    // Sample data - replace with actual data from your model
    private let totalAppointments: Int
    private let completedAppointments: Int
    private let canceledAppointments: Int
    private let rating: Double

    // Sample appointments data
    private let todaysAppointments: [Appointment]

    // Sample alerts data
    private let emergencyAlerts: [EmergencyAlert]

}

// Dashboard Card Component
struct DashboardCard: View {
    let value: String
    let title: String
    let icon: String
    let backgroundColor: Color
    let iconColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Icon at top
            ZStack {
                Circle()
                    .fill(backgroundColor)
                    .frame(width: 34, height: 34)

                Image(systemName: icon)
                    .font(.system(size: 15))
                    .foregroundColor(iconColor)
            }

            Spacer()
                .frame(height: 4)

            // Value - make it larger and more prominent
            Text(value)
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.primary)

            // Title - smaller and lighter
            Text(title)
                .font(.system(size: 13))
                .foregroundColor(Color(.systemGray))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 14)
        .padding(.horizontal, 14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.04), radius: 2, x: 0, y: 1)
        )
    }
}

// Appointment Card Component
struct AppointmentCard: View {
    let appointment: Appointment

    var body: some View {
        HStack(spacing: 12) {
            // Left side - Patient info
            VStack(alignment: .leading, spacing: 4) {
                Text(appointment.patientName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)

                Text(appointment.appointmentType)
                    .font(.system(size: 14))
                    .foregroundColor(Color(.systemGray))
            }

            Spacer()

            // Right side - Time and status
            VStack(alignment: .trailing, spacing: 8) {
                // Time with background
                Text(appointment.time)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemGray6))
                    )

                // Status tag
                if appointment.status == .completed {
                    Text("Completed")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.blue)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.12))
                        .clipShape(Capsule())
                } else if appointment.status == .confirmed {
                    Text("Confirmed")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.blue)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.12))
                        .clipShape(Capsule())
                } else {
                    StatusTag(status: appointment.status)
                }
            }
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.04), radius: 2, x: 0, y: 1)
        )
    }
}

// Alert Card Component
struct AlertCard: View {
    let alert: EmergencyAlert

    var body: some View {
        HStack(spacing: 12) {
            // Left side - Alert info
            VStack(alignment: .leading, spacing: 4) {
                Text(alert.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)

                Text(alert.details)
                    .font(.system(size: 14))
                    .foregroundColor(Color(.systemGray))
            }

            Spacer()

            // Right side - Time and priority
            VStack(alignment: .trailing, spacing: 8) {
                // Time with background
                Text(alert.timeAgo)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemGray6))
                    )

                PriorityTag(priority: alert.priority)
            }
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.04), radius: 2, x: 0, y: 1)
        )
    }
}

// Priority Tag Component
struct PriorityTag: View {

    // MARK: Internal

    let priority: AlertPriority

    var body: some View {
        Text(priority.rawValue)
            .font(.system(size: 11, weight: .medium))
            .foregroundColor(priorityColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(priorityColor.opacity(0.12))
            .clipShape(Capsule())
    }

    // MARK: Private

    private var priorityColor: Color {
        switch priority {
        case .urgent: return .red
        case .normal: return .green
        case .low: return .blue
        }
    }
}

// Status Tag Component
struct StatusTag: View {

    // MARK: Internal

    let status: AppointmentStatus

    var body: some View {
        // Text label for statuses
        Text(status.rawValue)
            .font(.system(size: 11, weight: .medium))
            .foregroundColor(statusColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(statusColor.opacity(0.12))
            .clipShape(Capsule())
    }

    // MARK: Private

    private var statusColor: Color {
        switch status {
        case .confirmed: return .green
        case .pending: return .orange
        case .canceled: return .red
        case .completed: return .blue
        }
    }
}

// Appointment Model
struct Appointment: Identifiable {
    let id: UUID = .init()
    let patientName: String
    let appointmentType: String
    let time: String
    let date: Date
    let status: AppointmentStatus
}

// Emergency Alert Model
struct EmergencyAlert: Identifiable {
    let id: UUID = .init()
    let title: String
    let details: String
    let timeAgo: String
    let priority: AlertPriority
}

enum AppointmentStatus: String {
    case confirmed = "Confirmed"
    case pending = "Pending"
    case canceled = "Canceled"
    case completed = "Completed"
}

enum AlertPriority: String {
    case urgent = "Urgent"
    case normal = "Normal"
    case low = "Low"
}

// Preview
struct DoctorDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DoctorDashboardView()
                .preferredColorScheme(.light)

            DoctorDashboardView()
                .preferredColorScheme(.dark)
        }
    }
}
