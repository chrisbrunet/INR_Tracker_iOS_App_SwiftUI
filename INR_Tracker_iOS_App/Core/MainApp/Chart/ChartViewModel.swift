//
//  ChartViewModel.swift
//  INR_Tracker_iOS_App
//
//  Created by Chris Brunet on 2024-01-04.
//

import Foundation
import Firebase
import FirebaseFirestore
import Combine

@MainActor
class ChartViewModel: ObservableObject {
    
    @Published var chartData: [ChartPoint]?
    
    @Published var ninetyDaysData: [ChartPoint]?
    @Published var oneYearData: [ChartPoint]?
        
    @Published var chartMin: Double?
    @Published var chartMax: Double?
    
    @Published var currentUser: User?

    private var cancellables = Set<AnyCancellable>()
    
    init() {
        print("CONSOLE-DEBUG: ChartViewModel init() called")
        print("CONSOLE-DEBUG: ChartViewModel init() calling setupSubscribers")
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        print("CONSOLE-DEBUG: ChartViewModel setupSubscribers() called")
        DataService.shared.$chartData
            .assign(to: \.chartData, on: self)
            .store(in: &cancellables)
        
        DataService.shared.$ninetyDaysData
            .assign(to: \.ninetyDaysData, on: self)
            .store(in: &cancellables)
        
        DataService.shared.$oneYearData
            .assign(to: \.oneYearData, on: self)
            .store(in: &cancellables)
        
        DataService.shared.$chartMin
            .assign(to: \.chartMin, on: self)
            .store(in: &cancellables)
        
        DataService.shared.$chartMax
            .assign(to: \.chartMax, on: self)
            .store(in: &cancellables)
        
        AuthService.shared.$currentUser
            .assign(to: \.currentUser, on: self)
            .store(in: &cancellables)
    }
}

