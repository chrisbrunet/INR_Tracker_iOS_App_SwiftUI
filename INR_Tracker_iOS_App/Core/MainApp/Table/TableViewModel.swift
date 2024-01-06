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
    
    @Published var tests: [Test]?
    
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
    }
}
