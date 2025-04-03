//
//  AppointmentStatus.swift
//  HMS-Doctor
//
//  Created by Dhruvi on 30/03/25.
//

import Foundation

enum AppointmentStatus: String, Codable {
    case confirmed = "Confirmed"
    case completed = "Completed"
    case cancelled = "Cancelled"
    case onGoing = "On going"
}

struct Appointment: Codable, Identifiable, Hashable, Sendable {
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case patientId = "patient_id"
        case doctorId = "doctor_id"
        case startDate = "start_date"
        case endDate = "end_date"
        case prescription
        case notes
        case reference
        case cancelled
        case createdAt = "created_at"
    }

    var id: String = UUID().uuidString

    var patientId: String
    var patient: Patient?

    var doctorId: String
    var doctor: Staff?

    var startDate: Date
    var endDate: Date
    var prescription: String?
    var notes: String?

    var reference: String?
    var cancelled: Bool = false
    var createdAt: Date = .init()

    var status: AppointmentStatus {
        let now = Date()

        if startDate < now && now < endDate {
            return .onGoing
        } else if endDate < now {
            return .completed
        } else {
            return .confirmed
        }
    }

}
