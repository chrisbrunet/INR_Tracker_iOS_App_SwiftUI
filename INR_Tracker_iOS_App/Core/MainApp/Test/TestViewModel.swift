//
//  TestViewModel.swift
//  INR_Tracker_iOS_App
//
//  Created by Chris Brunet on 2024-01-04.
//

import Foundation

class TestViewModel: ObservableObject {
    
    func createTest(date: Date, reading: Double, notes: String) async throws {
        try await DataService.shared.createTest(date: date, reading: reading, notes: notes)
    }
    
    func updateTest(){
        
    }
    
    func deleteTest(){
        
    }
}
