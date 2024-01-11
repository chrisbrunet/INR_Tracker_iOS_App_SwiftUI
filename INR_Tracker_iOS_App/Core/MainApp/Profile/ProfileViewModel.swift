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
    
    @Published var showTRAlert = false
    @Published var minTR = "0"
    @Published var maxTR = "0"
    
    @Published var showDoseAlert = false
    @Published var dose = "0"
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        print("CONSOLE-DEBUG: ProfileViewModel init() called")
        setupSubscribers()
        minTR = "\(String(describing: currentUser?.minTR))"
        maxTR = "\(String(describing: currentUser?.maxTR))"
        dose = "\(String(describing: currentUser?.dose))"
        print("CONSOLE-DEBUG: ProfileViewModel init() completed, currentUser is \(String(describing: currentUser?.id)), dose is \(dose)")

    }
    
    private func setupSubscribers() {
        print("CONSOLE-DEBUG: ProfileViewModel setUpSubscribers() called")
        AuthService.shared.$currentUser
            .assign(to: \.currentUser, on: self) 
            .store(in: &cancellables)
    }
    
    func signOut() {
        AuthService.shared.signOut()
    }
    
    func setCurrentDose() async throws {
        try await AuthService.shared.setCurrentDose(dose: Double(dose)!)
    }
    
    func setCurrentTR() async throws {
        try await AuthService.shared.setCurrentTR(min: Double(minTR)!, max: Double(maxTR)!)
    }
}
