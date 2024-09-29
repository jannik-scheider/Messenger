//
//  AuthService.swift
//  Messenger
//
//  Created by Jannik Scheider on 23.09.24.
//

import Foundation
import FirebaseAuth
import Firebase

class AuthService  {
    @Published var userSession: FirebaseAuth.User?
    
    static let shared = AuthService()
    
    init() {
        self.userSession = Auth.auth().currentUser
        loadCurrentUser()
        print("DEBUG: User session is \(userSession?.uid)")
    }
    
    @MainActor
    func login(withEmail email: String, password: String) async throws {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        self.userSession = result.user
        loadCurrentUser()
    }
    
    @MainActor
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        self.userSession = result.user
        try await self.uploadUserData(email: email, fullname: fullname, id: result.user.uid)
        loadCurrentUser()
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            UserService.shared.currentUser = nil
        } catch {
            print("DEBUG: failed to sign out \(error.localizedDescription)")
        }
    }
    
    private func uploadUserData(email: String, fullname: String, id: String) async throws {
        let user = User(fullname: fullname, email: email, profileImageUrl: nil)
        guard let encodedUser = try? Firestore.Encoder().encode(user) else {return}
        try await Firestore.firestore().collection("users").document(id).setData(encodedUser)
    }
    
    private func loadCurrentUser() {
        Task { try await UserService.shared.fetchCurrentUser() }
    }
}
