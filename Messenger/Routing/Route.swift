//
//  Route.swift
//  Messenger
//
//  Created by Jannik Scheider on 25.09.24.
//

import Foundation

enum Route: Hashable {
    case profile(User)
    case chatView(User)
}
