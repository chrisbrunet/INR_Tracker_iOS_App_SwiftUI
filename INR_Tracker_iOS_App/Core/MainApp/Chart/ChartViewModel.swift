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
    @Published var allTimeData: [ChartPoint]?
        
    @Published var chartMin: Double?
    @Published var chartMax: Double?

    private var cancellables = Set<AnyCancellable>()
    
    init() {
        print("CONSOLE-DEBUG: ChartViewModel init() called")
        Task {
            print("CONSOLE-DEBUG: ChartViewModel init() calling DataService fetchTests")
            await DataService.shared.fetchTests()
            print("CONSOLE-DEBUG: ChartViewModel init() calling setupSubscribers")
            setupSubscribers()
            print("CONSOLE-DEBUG: ChartViewModel init() calling prepareChartData")
            prepareChartData()
        }
    }
    
    private func setupSubscribers() {
        print("CONSOLE-DEBUG: ChartViewModel setupSubscribers() called")
        DataService.shared.$chartData
            .assign(to: \.chartData, on: self)
            .store(in: &cancellables)
    }
    
    func prepareChartData(){
        print("CONSOLE-DEBUG: ChartViewModel prepareCharData called")
        self.ninetyDaysData = filterTestsLastNDays(days: 90, tests: chartData!)
        self.oneYearData = filterTestsLastNDays(days: 365, tests: chartData!)
        
        let readings = chartData!.map { $0.reading }
        let minINRidx = chartData!.firstIndex { $0.reading == readings.min() } ?? 0
        let maxINRidx = chartData!.firstIndex { $0.reading == readings.max() } ?? 0

        self.chartMin = chartData![minINRidx].reading
        self.chartMax = chartData![maxINRidx].reading
        
        print("CONSOLE-DEBUG: PrePareChartData completed. chartData: \(chartData!.count), oneYearData: \(oneYearData!.count), ninetyDaysData: \(ninetyDaysData!.count)")
    }
    
    func filterTestsLastNDays(days: Int, tests: [ChartPoint]) -> [ChartPoint] {
        let currentDate = Date()
        let nDaysAgo = Calendar.current.date(byAdding: .day, value: -(days), to: currentDate)!
        let filteredTests = tests.filter { $0.date >= nDaysAgo && $0.date <= currentDate }
        return filteredTests
    }
}

