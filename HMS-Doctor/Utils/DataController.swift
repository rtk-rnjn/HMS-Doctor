//
//  DataController.swift
//  HMS-Doctor
//
//  Created by RITIK RANJAN on 20/03/25.
//

import Foundation

struct UpdateResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case success
        case modifiedCount = "modified_count"
        case detail
    }

    let success: Bool
    let modifiedCount: Int
    let detail: String?
}

class DataController {
    @MainActor static let shared: DataController = .init()

    func fetchStaff(email: String, password: String) async -> Staff? {
        return await MiddlewareManager.shared.get(url: "/admin/staff", queryParameters: ["email_address": email, "password": password])
    }

    func updateStaff(_ newStaff: Staff) async -> Bool {
        guard let body = newStaff.toData() else { return false }
        let response: UpdateResponse? = await MiddlewareManager.shared.patch(url: "/admin/staff/\(newStaff.id)", body: body)
        return response?.success ?? false
    }
}
