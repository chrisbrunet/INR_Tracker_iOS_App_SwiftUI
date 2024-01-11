//
//  TestViewModel.swift
//  INR_Tracker_iOS_App
//
//  Created by Chris Brunet on 2024-01-04.
//

import Foundation
import Combine

protocol TestFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class NewTestViewModel: ObservableObject {
    
    @Published var currentUser: User?
    
    @Published var reading = ""
    @Published var notes = ""
    @Published var date = Date()
    @Published var dose = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        print("CONSOLE-DEBUG: NewTestViewModel init() called")
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        print("CONSOLE-DEBUG: NewTestViewModel setupSubscribers() called")
        AuthService.shared.$currentUser
            .assign(to: \.currentUser, on: self)
            .store(in: &cancellables)
    }
    
    func createTest() async throws {
        try await DataService.shared.createTest(date: date, reading: Double(reading)!, notes: notes, dose: Double(dose)!)
    }
}
