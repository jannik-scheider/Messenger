//
//  SettingsOptionViewModel.swift
//  Messenger
//
//  Created by Jannik Scheider on 22.09.24.
//

import Foundation
import SwiftUI

enum SettingsOptionViewModel: Int, CaseIterable, Identifiable {
    case darkMode
    case activeStatus
    case acessability
    case privacy
    case notifications
    
    var title: String {
        switch self {
        case .darkMode: return "Dark Mode"
        case .activeStatus: return "Active Status"
        case .acessability: return "Acessability"
        case .privacy: return "Privacy"
        case .notifications: return "Notifications"
        }
    }
    
    var imageName: String {
        switch self {
        case .darkMode: return "moon.circle.fill"
        case .activeStatus: return "message.badge.circle.fill"
        case .acessability: return "person.circle.fill"
        case .privacy: return "lock.circle.fill"
        case .notifications: return "bell.circle.fill"
        }
    }
    
    var imageBackgroundColor: Color {
        switch self {
            
        case .darkMode: return .black
        case .activeStatus: return Color(.systemGreen)
        case .acessability: return .black
        case .privacy: return Color(.systemBlue)
        case .notifications: return Color(.systemPurple)
        }
    }
    
    var id: Int { return self.rawValue}
}
