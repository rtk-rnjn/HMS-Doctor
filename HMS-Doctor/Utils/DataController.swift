//
//  DataController.swift
//  HMS-Doctor
//
//  Created by RITIK RANJAN on 20/03/25.
//

import Foundation

struct Token: Codable {
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case user = "user"
    }

    var accessToken: String
    var tokenType: String = "bearer"
    var user: Staff?
}

struct UserLogin: Codable {
    enum CodingKeys: String, CodingKey {
        case emailAddress = "email_address"
        case password
    }

    var emailAddress: String
    var password: String
}

struct ServerResponse: Codable {
    var success: Bool
}

struct ChangePassword: Codable {
    enum CodingKeys: String, CodingKey {
        case oldPassword = "old_password"
        case newPassword = "new_password"
    }

    var oldPassword: String
    var newPassword: String
}

class DataController: ObservableObject {

    // MARK: Public

    @Published public private(set) var staff: Staff?

    // MARK: Internal

    @MainActor static let shared: DataController = .init()

    func login(emailAddress: String, password: String) async -> Bool {
        let userLogin = UserLogin(emailAddress: emailAddress, password: password)
        guard let userLoginData = userLogin.toData() else {
            fatalError("Something fucked up")
        }

        let token: Token? = await MiddlewareManager.shared.post(url: "/doctor/login", body: userLoginData)
        guard let accessToken = token?.accessToken, let staff = token?.user else {
            return false
        }
        self.accessToken = accessToken
        self.staff = staff

        UserDefaults.standard.set(accessToken, forKey: "accessToken")
        UserDefaults.standard.set(emailAddress, forKey: "emailAddress")
        UserDefaults.standard.set(password, forKey: "password")
        UserDefaults.standard.set(staff.id, forKey: "staffId")

        return true
    }

    func autoLogin() async -> Bool {
        guard let email = UserDefaults.standard.string(forKey: "emailAddress"),
              let password = UserDefaults.standard.string(forKey: "password") else {
            return false
        }

        return await login(emailAddress: email, password: password)
    }

    func logout() {
        UserDefaults.standard.removeObject(forKey: "accessToken")
    }

    func changePassword(oldPassword: String, newPassword: String) async -> Bool {
        let changePassword = ChangePassword(oldPassword: oldPassword, newPassword: newPassword)
        guard let changePasswordData = changePassword.toData() else {
            fatalError("Something fucked up again...")
        }

        let response: ServerResponse? = await MiddlewareManager.shared.patch(url: "/doctor/change-password", body: changePasswordData)
        let success = response?.success ?? false

        if success {
            UserDefaults.standard.set(newPassword, forKey: "password")
        }
        return success
    }

    func fetchAppointments() async -> [Appointment] {
        guard let id = UserDefaults.standard.string(forKey: "staffId") else {
            return []
        }

        let appointments: [Appointment]? = await MiddlewareManager.shared.get(url: "/appointments/\(id)")
        guard var appointments else {
            return []
        }

        for i in 0..<appointments.count {
            appointments[i].doctor = staff
            let patient: Patient? = await MiddlewareManager.shared.get(url: "/patient/\(appointments[i].patientId)")

            appointments[i].patient = patient
            appointments[i].patient?.prescriptions = await fetchPrescriptions(for: patient)
            appointments[i].patient?.medicalRecords = await fetchMedicalReport(for: patient)
        }
        return appointments
    }

    func fetchAnnouncements() async -> [Announcement]? {
        if staff == nil {
            guard await autoLogin() else { fatalError() }
        }

        guard let staff else {
            fatalError("Staff is nil")
        }

        return await MiddlewareManager.shared.get(url: "/hospital/\(staff.hospitalId)/doctors/announcements")
    }

    func addPrescription(_ prescription: Prescription, to patient: Patient?) async -> Bool {
        guard let patient else {
            return false
        }

        guard let prescriptionData = prescription.toData() else {
            fatalError("Could not add prescription: Invalid data")
        }

        let serverResponse: ServerResponse? = await MiddlewareManager.shared.post(url: "/patient/\(patient.id)/prescription", body: prescriptionData)
        return serverResponse?.success ?? false
    }

    func fetchPrescriptions(for patient: Patient?) async -> [Prescription]? {
        guard let patient else {
            return nil
        }
        return await MiddlewareManager.shared.get(url: "/patient/\(patient.id)/prescription")
    }

    func fetchMedicalReport(for patient: Patient?) async -> [MedicalReport] {
        guard let patient else {
            return []
        }
        let reports: [MedicalReport]? = await MiddlewareManager.shared.get(url: "/patient/\(patient.id)/medical-reports")
        return reports ?? []
    }

    // MARK: Private

    private var accessToken: String = ""

}
