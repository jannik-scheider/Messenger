//
//  ContentView.swift
//  Messenger
//
//  Created by Jannik Scheider on 15.09.24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                InboxView()
            } else {
                LoginView()
            }
        }
    }
}



#Preview {
    ContentView()
}
