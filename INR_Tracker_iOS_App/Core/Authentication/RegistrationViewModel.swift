//
//  RegistrationViewModel.swift
//  INR_Tracker_iOS_App
//
//  Created by Chris Brunet on 2024-01-03.
//

import Foundation

class RegistrationViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var fullname = ""
    
    func createUser() async throws {
        try await AuthService.shared.createUser(withEmail: email, password: password, fullname: fullname)
    }
}
