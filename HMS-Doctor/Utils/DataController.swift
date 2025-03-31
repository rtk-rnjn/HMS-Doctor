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
        let appointments: [Appointment]? = await MiddlewareManager.shared.get(url: "/appointments/\(staff?.id ?? "")")
        guard var appointments else {
            return []
        }

        for i in 0..<appointments.count {
            appointments[i].doctor = staff
            appointments[i].patient = await MiddlewareManager.shared.get(url: "/patient/\(appointments[i].patientId)")
        }
        return appointments
    }

    // MARK: Private

    private var accessToken: String = ""

}
