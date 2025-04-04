//
//  AnnouncementView.swift
//  HMS-Doctor
//
//  Created by RITIK RANJAN on 31/03/25.
//

import SwiftUI

struct AnnouncementView: View {

    // MARK: Internal

    var announcements: [Announcement] = []

    var body: some View {
        List {
            ForEach(groupedAnnouncements, id: \.date) { section in
                Section(header: Text(dateFormatter.string(from: section.date))) {
                    ForEach(section.announcements, id: \.title) { announcement in
                        HStack(spacing: 12) {
                            categoryIcon(for: announcement.category)
                                .foregroundColor(categoryColor(for: announcement.category))
                                .font(.title2)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(announcement.title)
                                    .font(.headline)
                                Text(announcement.body)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(announcement.createdAt, style: .time)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(4)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    // MARK: Private

    @Environment(\.dismiss) private var dismiss

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    private var groupedAnnouncements: [(date: Date, announcements: [Announcement])] {
        let grouped = Dictionary(grouping: announcements) { announcement in
            Calendar.current.startOfDay(for: announcement.createdAt)
        }
        return grouped.map { (date: $0.key, announcements: $0.value.sorted { $0.createdAt > $1.createdAt }) }
            .sorted { $0.date > $1.date }
    }

    private func categoryIcon(for category: AnnouncementCategory) -> Image {
        switch category {
        case .general: return Image(systemName: "megaphone.fill")
        case .emergency: return Image(systemName: "exclamationmark.triangle.fill")
        case .appointment: return Image(systemName: "calendar.badge.clock")
        case .holiday: return Image(systemName: "gift.fill")
        }
    }

    private func categoryColor(for category: AnnouncementCategory) -> Color {
        switch category {
        case .general: return .blue
        case .emergency: return .red
        case .appointment: return .green
        case .holiday: return .orange
        }
    }
}
