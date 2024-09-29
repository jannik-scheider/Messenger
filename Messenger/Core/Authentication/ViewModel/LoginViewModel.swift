//
//  LoginViewModel.swift
//  Messenger
//
//  Created by Jannik Scheider on 23.09.24.
//

import Foundation
import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var showAlert = false
    @Published var errorMessage = ""

    @MainActor
    func login() async {
        do {
            try await AuthService.shared.login(withEmail: email, password: password)
        } catch {
            self.errorMessage = parseError(error)
            self.showAlert = true
        }
    }
    
    private func parseError(_ error: Error) -> String {
        if let errorCode = AuthErrorCode(rawValue: (error as NSError).code) {
            print("DEBUG: AuthErrorCode: \(errorCode)")
            switch errorCode {
            case .invalidCredential:
                return "Incorrect password, please try again."
            case .invalidEmail:
                return "Invalid email address."
            case .userNotFound:
                return "User not found."
            default:
                return error.localizedDescription
            }
        }
        return "An unknown error has occurred."
    }
}

