//
//  TestViewModel.swift
//  INR_Tracker_iOS_App
//
//  Created by Chris Brunet on 2024-01-04.
//

import Foundation

protocol TestFormProtocol {
    var formIsValid: Bool { get }
}

class NewTestViewModel: ObservableObject {
    
    @Published var reading = ""
    @Published var notes = ""
    @Published var date = Date()
    
    func createTest() async throws {
        try await DataService.shared.createTest(date: date, reading: Double(reading)!, notes: notes)
    }
}
