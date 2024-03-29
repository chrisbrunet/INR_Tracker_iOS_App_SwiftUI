//
//  TableViewModel.swift
//  INR_Tracker_iOS_App
//
//  Created by Chris Brunet on 2024-01-02.
//

import Foundation
import Firebase
import FirebaseFirestore
import Combine

@MainActor
class TableViewModel: ObservableObject {
    
    @Published var showNewView = false
    @Published var isUpdateView = false
    @Published var selectedTest: Test?
    
    @Published var tests: [Test]?
    @Published var currentUser: User?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        print("CONSOLE-DEBUG: TableViewModel init() called")
        
        Task {
            await DataService.shared.fetchTests()
            setupSubscribers()
        }
    }
    
    private func setupSubscribers() {
        DataService.shared.$tests
            .assign(to: \.tests, on: self)
            .store(in: &cancellables)
        
        AuthService.shared.$currentUser
            .assign(to: \.currentUser, on: self)
            .store(in: &cancellables)
    }
}
