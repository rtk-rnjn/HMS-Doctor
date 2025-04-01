//
//  Prescription.swift
//  HMS-Doctor
//
//  Created by RITIK RANJAN on 31/03/25.
//

import Foundation

struct Medicine: Codable, Hashable, Identifiable {
    var id: String = UUID().uuidString

    var name: String
    var dosage: String
    var frequency: Frequency
}

struct Prescription: Codable, Hashable, Identifiable {
    var id: String = UUID().uuidString
    var diagnosis: String
    var medicines: [Medicine] = []
}

enum Frequency: Codable, Hashable {
    case interval(hours: Int)
    case daily(times: [DateComponents])
    case weekly(days: [Int], time: DateComponents)
    case custom(DateComponents)

    var description: String {
        switch self {
        case .interval(let hours):
            return "Every \(hours) Hours"
        case .daily(let times):
            let formattedTimes = times.map { "\($0.hour ?? 0):\($0.minute ?? 0)" }
            return "Daily (\(formattedTimes.joined(separator: ", ")))"
        case .weekly(let days, let time):
            let daysString = days.map { ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"][$0 % 7] }.joined(separator: ", ")
            return "Weekly (\(daysString) at \(time.hour ?? 0):\(time.minute ?? 0))"
        case .custom(let time):
            return "Custom (\(time.hour ?? 0):\(time.minute ?? 0))"
        }
    }
}
