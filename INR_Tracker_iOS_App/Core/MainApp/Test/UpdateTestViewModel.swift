//
//  UpdateTestViewModel.swift
//  INR_Tracker_iOS_App
//
//  Created by Chris Brunet on 2024-01-04.
//

import Foundation

class UpdateTestViewModel: ObservableObject {
    
    func updateTest(test: Test) async throws {
        try await DataService.shared.updateTest(test: test)
    }
    
    func deleteTest(test: Test) async throws {
        try await DataService.shared.deleteTest(test: test)
    }
}
