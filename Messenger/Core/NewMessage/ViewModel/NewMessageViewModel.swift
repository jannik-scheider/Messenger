//
//  NewMessageViewModel.swift
//  Messenger
//
//  Created by Jannik Scheider on 24.09.24.
//

import Foundation
import FirebaseAuth

@MainActor
class NewMessageViewModel: ObservableObject {
    @Published var users = [User]()
    
    init() {
        Task {try await fetchUsers()}
    }
    
    func fetchUsers() async throws {
        guard let currentId = Auth.auth().currentUser?.uid else {return}
        self.users = try await UserService.fetchAllUsers()
        self.users = users.filter({$0.id != currentId})
    }
}
