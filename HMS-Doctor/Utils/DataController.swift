//
//  DataController.swift
//  HMS-Doctor
//
//  Created by RITIK RANJAN on 20/03/25.
//

import Foundation

struct Token: Codable, Sendable {
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case user = "user"
    }

    var accessToken: String
    var tokenType: String = "bearer"
    var user: Staff?
}

struct HardPasswordReset: Codable {
    enum CodingKeys: String, CodingKey {
        case emailAddress = "email_address"
        case newPassword = "new_password"
    }

    var emailAddress: String
    var newPassword: String
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

struct RatingResponse: Codable, Sendable {
    enum CodingKeys: String, CodingKey {
        case rating
    }

    var rating: Double = 0.0
}

struct LeaveRequest: Codable, Sendable {
    enum CodingKeys: String, CodingKey {
        case id
        case doctorId = "doctor_id"
        case reason
        case approved
        case createdAt
        case dates
    }

    var id: String = UUID().uuidString
    var doctorId: String?
    var reason: String
    var approved: Bool = false
    var createdAt: Date = .init()
    var dates: [Date] = []
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
        UserDefaults.standard.removeObject(forKey: "emailAddress")
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.removeObject(forKey: "staffId")
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

    func hardPasswordReset(emailAddress: String, password: String) async -> Bool {
        let hardPasswordReset = HardPasswordReset(emailAddress: emailAddress, newPassword: password)
        guard let hardPasswordResetData = hardPasswordReset.toData() else {
            fatalError("Could not hard reset password")
        }

        let response: ServerResponse? = await MiddlewareManager.shared.patch(url: "/change-password", body: hardPasswordResetData)
        return response?.success ?? false
    }

    func requestOtp(emailAddress: String) async -> Bool {
        let response: ServerResponse? = await MiddlewareManager.shared.get(url: "/request-otp", queryParameters: ["to_email": emailAddress])
        return response?.success ?? false
    }

    func verifyOtp(emailAddress: String, otp: String) async -> Bool {
        let response: ServerResponse? = await MiddlewareManager.shared.get(url: "/verify-otp", queryParameters: ["to_email": emailAddress, "otp": otp])
        return response?.success ?? false
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

    func markAppointmentAsDone(_ appointment: Appointment?) async -> Bool {
        guard let appointment else {
            return false
        }
        let serverResponse: ServerResponse? = await MiddlewareManager.shared.patch(url: "/appointment/\(appointment.id)/mark-as-done", body: nil)
        return serverResponse?.success ?? false
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

    func fetchReview() async -> [Review]? {
        guard let id = UserDefaults.standard.string(forKey: "staffId") else {
            return []
        }

        return await MiddlewareManager.shared.get(url: "/doctor/\(id)/reviews")
    }

    func fetchAverageRating() async -> RatingResponse? {

        if staff == nil {
            let loggedIn = await autoLogin()
            if !loggedIn {
                return nil
            }
        }

        guard let staff else {
            fatalError()
        }

        return await MiddlewareManager.shared.get(url: "/staff/\(staff.id)/average-rating")
    }

    func requestForLeave(_ leaveRequest: LeaveRequest) async -> Bool {
        var newRequest = leaveRequest
        newRequest.doctorId = staff?.id

        guard let leaveRequestData = newRequest.toData() else {
            return false
        }

        guard let staff else {
            return false
        }

        let serverResponse: ServerResponse? = await MiddlewareManager.shared.post(url: "/staff/\(staff.id)/leave-request", body: leaveRequestData)
        return serverResponse?.success ?? false
    }

    func fetchDoctor(bySymptom symptom: String) async -> Staff? {
        return nil
    }

    // MARK: Private

    private var accessToken: String = ""

}
