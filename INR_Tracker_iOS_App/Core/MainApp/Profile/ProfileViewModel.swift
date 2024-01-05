//
//  ProfileViewModel.swift
//  INR_Tracker_iOS_App
//
//  Created by Chris Brunet on 2024-01-04.
//

import Foundation
import Firebase
import Combine

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var currentUser: User?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        print("CONSOLE-DEBUG: ProfileViewModel init() called")
        setupSubscribers()
        print("CONSOLE-DEBUG: ProfileViewModel init() completed, currentUser is \(String(describing: currentUser?.id))")
    }
    
    private func setupSubscribers() {
        print("CONSOLE-DEBUG: ProfileViewModel setUpSubscribers() called")
        AuthService.shared.$currentUser
            .assign(to: \.currentUser, on: self) 
            .store(in: &cancellables)
    }
    
    func signOut()  {
        AuthService.shared.signOut()
    }
}
