import SwiftUI

struct DoctorDashboardView: View {

    // MARK: Lifecycle

    // Initializer with default values for preview and testing
    init(
        totalAppointments: Int = 10,
        completedAppointments: Int = 8,
        canceledAppointments: Int = 2,
        rating: Double = 0,
        todaysAppointments: [Appointment] = [],
        emergencyAlerts: [Announcement] = []
    ) {
        self.totalAppointments = totalAppointments
        self.completedAppointments = completedAppointments
        self.canceledAppointments = canceledAppointments
        self.rating = rating
        self.todaysAppointments = todaysAppointments
        self.emergencyAlerts = emergencyAlerts
    }

    // MARK: Internal

    var todaysAppointments: [Appointment]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Overview")
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
                }
                .padding(.horizontal)
                .padding(.top, 32)
                .padding(.bottom, 12)

                VStack(spacing: 12) {
                    ForEach(todaysAppointments) { appointment in
                        AppointmentCard(appointment: appointment)
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

    private let emergencyAlerts: [Announcement]

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

struct AppointmentCard: View {
    let appointment: Appointment
    weak var delegate: AppointmentsHostingController?

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(appointment.patient?.fullName ?? "Unknown Patient")
                    .font(.system(size: 14))
                    .foregroundColor(Color(.systemGray))

                Text(appointment.reference == nil ? "New Patient" : "Follow up")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
            }

            Spacer()

            // Right side - Time and status
            VStack(alignment: .trailing, spacing: 8) {
                // Time with background
                Text(appointment.startDate.humanReadableString())
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
        .onTapGesture {
            delegate?.performSegue(withIdentifier: "segueShowPatientHostingController", sender: appointment)
        }
    }
}

// Alert Card Component
struct AlertCard: View {
    let alert: Announcement

    var body: some View {
        HStack(spacing: 12) {
            // Left side - Alert info
            VStack(alignment: .leading, spacing: 4) {
                Text(alert.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)

                Text(alert.body)
                    .font(.system(size: 14))
                    .foregroundColor(Color(.systemGray))
            }

            Spacer()

            // Right side - Time and priority
            VStack(alignment: .trailing, spacing: 8) {
                // Time with background
                Text(alert.createdAt.humanReadableString())
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemGray6))
                    )

                PriorityTag(category: alert.category)
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

    let category: AnnouncementCategory

    var body: some View {
        Text(category.rawValue)
            .font(.system(size: 11, weight: .medium))
            .foregroundColor(categoryColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(categoryColor.opacity(0.12))
            .clipShape(Capsule())
    }

    // MARK: Private

    private var categoryColor: Color {
        switch category {
        case .appointment: return .blue
        case .emergency: return .red
        case .general: return .gray
        case .holiday: return .yellow
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
        case .confirmed: return .blue
        case .cancelled: return .red
        case .completed: return .gray
        case .onGoing: return .green
        }
    }
}
