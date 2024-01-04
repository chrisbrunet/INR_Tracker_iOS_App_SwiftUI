//
//  ProfileViewModel.swift
//  INR_Tracker_iOS_App
//
//  Created by Chris Brunet on 2024-01-04.
//

import Foundation
import Firebase
import Combine

class ProfileViewModel: ObservableObject {
    @Published var currentUser: User?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscribers()
        print("CONSOLE-DEBUG: ProfileViewModel init() currentUser on is \(String(describing: currentUser?.id))")
    }
    
    private func setupSubscribers() {
        AuthService.shared.$currentUser
            .assign(to: \.currentUser, on: self) 
            .store(in: &cancellables)
    }
    
    func signOut()  {
        AuthService.shared.signOut()
    }
}
