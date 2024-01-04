//
//  ContentViewModel.swift
//  INR_Tracker_iOS_App
//
//  Created by Chris Brunet on 2024-01-03.
//

import Foundation
import Firebase
import Combine

class ContentViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        AuthService.shared.$userSession
            .assign(to: \.userSession, on: self)
            .store(in: &cancellables)
    }
}
