//
//  ChatService.swift
//  Messenger
//
//  Created by Jannik Scheider on 25.09.24.
//

import Foundation
import Firebase
import FirebaseAuth

struct ChatService {
    let chatPartner: User
    
    func sendMessage(_ messageText: String) {
        guard let currentId = Auth.auth().currentUser?.uid else {return}
        let chatPartnerId = chatPartner.id
        
        let currentUserRef = FirestoreConstants.MessageCollection.document(currentId).collection(chatPartnerId).document()
        let chatPartnerRef = FirestoreConstants.MessageCollection.document(chatPartnerId).collection(currentId)
        
        let recentCurrentUserRef = FirestoreConstants.MessageCollection.document(currentId).collection("recent-messages").document(chatPartnerId)
        let recentPartnerRef = FirestoreConstants.MessageCollection.document(chatPartnerId).collection("recent-messages").document(currentId)
        let messageId = currentUserRef.documentID
        
        let message = Message (
            messageId: messageId,
            fromId: currentId,
            toId: chatPartnerId,
            messageText: messageText,
            timestamp: Timestamp()
        )
        
        guard let messageData = try? Firestore.Encoder().encode(message) else {return}
        
        currentUserRef.setData(messageData)
        chatPartnerRef.document(messageId).setData(messageData)
        
        recentCurrentUserRef.setData(messageData)
        recentPartnerRef.setData(messageData)
    }

    
    func observeMessages(completion: @escaping([Message]) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        let chatPartnerId = chatPartner.id
        
        let query = FirestoreConstants.MessageCollection
            .document(currentUid)
            .collection(chatPartnerId)
            .order(by: "timestamp", descending: false)
        
        query.addSnapshotListener { snapshot, _ in
            guard let changes = snapshot?.documentChanges.filter({ $0.type == .added }) else {return}
            var messages = changes.compactMap({try? $0.document.data(as: Message.self)} )
            
            for (index, message) in messages.enumerated() where message.fromId != currentUid {
                messages[index].user = chatPartner
            }
            
            completion(messages)
        }
    }
}
