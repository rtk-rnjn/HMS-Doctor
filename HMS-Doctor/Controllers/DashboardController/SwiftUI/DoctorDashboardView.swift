import SwiftUI

struct DoctorDashboardView: View {

    var totalAppointments: Int = 0
    var completedAppointments: Int = 0
    var canceledAppointments: Int = 0
    var rating: Double = 0.0

    var todaysAppointments: [Appointment] = []

    var emergencyAlerts: [Announcement] = []

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
                        iconColor: Color("iconBlue")
                    )

                    // Completed Appointments Card
                    DashboardCard(
                        value: String(completedAppointments),
                        title: "Completed",
                        icon: "checkmark.circle.fill",
                        backgroundColor: Color(.systemBlue).opacity(0.12),
                        iconColor: Color("iconBlue")
                    )

                    // Canceled Appointments Card
                    DashboardCard(
                        value: String(canceledAppointments),
                        title: "Canceled",
                        icon: "xmark.circle.fill",
                        backgroundColor: Color(.systemBlue).opacity(0.12),
                        iconColor: Color("iconBlue")
                    )

                    // Rating Card
                    DashboardCard(
                        value: String(format: "%.1f", rating),
                        title: "Rating",
                        icon: "star.fill",
                        backgroundColor: Color(.systemBlue).opacity(0.12),
                        iconColor: Color("iconBlue")
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
                    .font(.footnote)
                    .foregroundColor(iconColor)
            }

            Spacer()
                .frame(height: 4)

            // Value - make it larger and more prominent
            Text(value)
                .font(.largeTitle.bold())
                .foregroundColor(.primary)

            // Title - smaller and lighter
            Text(title)
                .font(.caption)
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
                    .font(.footnote)
                    .foregroundColor(Color(.systemGray))

                Text(appointment.reference == nil ? "New Patient" : "Follow up")
                    .font(.body)
                    .foregroundColor(.primary)
            }

            Spacer()

            // Right side - Time and status
            VStack(alignment: .trailing, spacing: 8) {
                // Time with background
                Text(appointment.startDate.humanReadableString())
                    .font(.body)
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
                        .font(.caption2.weight(.medium))
                        .foregroundColor(.blue)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.12))
                        .clipShape(Capsule())
                } else if appointment.status == .confirmed {
                    Text("Confirmed")
                        .font(.caption2.weight(.medium))
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
                    .font(.body)
                    .foregroundColor(.primary)

                Text(alert.body)
                    .font(.footnote)
                    .foregroundColor(Color(.systemGray))
            }

            Spacer()

            // Right side - Time and priority
            VStack(alignment: .trailing, spacing: 8) {
                // Time with background
                Text(alert.createdAt.humanReadableString())
                    .font(.body)
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
            .font(.caption2.weight(.medium))
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
            .font(.caption2.weight(.medium))
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
