//
//  InboxViewModel.swift
//  Messenger
//
//  Created by Jannik Scheider on 24.09.24.
//

import Foundation
import Combine
import Firebase

class InboxViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var recentMessages = [Message]()
    
    private var cancellables = Set<AnyCancellable>()
    private let service = InboxService()
    
    init() {
        setupSubsribers()
        service.observeRecentMessages()
    }
    private func setupSubsribers() {
        UserService.shared.$currentUser.sink { [weak self] user in
            self?.currentUser = user
        }.store(in: &cancellables)
        
        service.$documentChange.sink { [weak self] changes in
            self?.loadInitialMessages(fromChanges: changes)
        }.store(in: &cancellables)
    }
    
    private func loadInitialMessages(fromChanges changes: [DocumentChange]) {
        var messages = changes.compactMap({ try? $0.document.data(as: Message.self) })
        
        for i in 0 ..< messages.count {
            let message = messages[i]
            
            UserService.fetchUser(withUid: message.chatPartnerId) { user in
                messages[i].user = user
                self.recentMessages.append(messages[i])
            }
        }
    }
}
