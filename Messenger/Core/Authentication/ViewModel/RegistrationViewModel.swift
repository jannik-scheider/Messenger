//
//  RegistrationViewModel.swift
//  Messenger
//
//  Created by Jannik Scheider on 23.09.24.
//

import Foundation
import FirebaseAuth

class RegistrationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var fullname = ""
    @Published var showAlert = false
    @Published var errorMessage = ""

    @MainActor
    func createUser() async {
        do {
            try await AuthService.shared.createUser(withEmail: email, password: password, fullname: fullname)
        } catch {
            self.errorMessage = parseError(error)
            self.showAlert = true
        }
    }

    private func parseError(_ error: Error) -> String {
        let nsError = error as NSError
        if let errorCode = AuthErrorCode(rawValue: nsError.code) {
            switch errorCode {
            case .emailAlreadyInUse:
                return "This email address is already in use."
            case .weakPassword:
                return "The password is too weak."
            default:
                return error.localizedDescription
            }
        }
        return "An unknown error has occurred."
    }
}
