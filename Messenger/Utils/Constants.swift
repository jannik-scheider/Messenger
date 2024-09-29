//
//  Constants.swift
//  Messenger
//
//  Created by Jannik Scheider on 25.09.24.
//

import Foundation
import Firebase

struct FirestoreConstants {
    static let UserCollection = Firestore.firestore().collection("users")
    static let MessageCollection = Firestore.firestore().collection("messages")
}
