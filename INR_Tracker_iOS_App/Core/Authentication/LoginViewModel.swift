//
//  LoginViewModel.swift
//  INR_Tracker_iOS_App
//
//  Created by Chris Brunet on 2024-01-03.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    
    func signIn() async throws {
        try await AuthService.shared.signIn(withEmail: email, password: password)
    }
}
