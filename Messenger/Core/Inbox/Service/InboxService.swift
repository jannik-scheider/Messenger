//
//  InboxService.swift
//  Messenger
//
//  Created by Jannik Scheider on 25.09.24.
//

import Foundation
import Firebase
import FirebaseAuth

class InboxService {
    @Published var documentChange = [DocumentChange]()
    
    func observeRecentMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let query = FirestoreConstants
            .MessageCollection
            .document(uid)
            .collection("recent-messages")
            .order(by: "timestamp", descending: true)
        
        query.addSnapshotListener { snapshot, _ in
            guard let changes = snapshot?.documentChanges.filter({
                $0.type == .added || $0.type == .modified
            }) else {return}
            
            self.documentChange = changes
        }
        
    }
}
