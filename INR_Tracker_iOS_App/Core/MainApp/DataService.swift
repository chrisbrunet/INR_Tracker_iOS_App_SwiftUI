//
//  DataService.swift
//  INR_Tracker_iOS_App
//
//  Created by Chris Brunet on 2024-01-04.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import Combine

@MainActor
class DataService: ObservableObject {
    
    @Published var tests: [Test]?
    @Published var chartData: [ChartPoint]?
    @Published var userSession: FirebaseAuth.User?
    
    @Published var ninetyDaysData: [ChartPoint]?
    @Published var oneYearData: [ChartPoint]?
    @Published var chartMin: Double?
    @Published var chartMax: Double?
    
    static let shared = DataService()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        print("CONSOLE-DEBUG: DataService init() called")
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        print("CONSOLE-DEBUG: DataService setupSubscribers() called")
        AuthService.shared.$userSession
            .assign(to: \.userSession, on: self)
            .store(in: &cancellables)
    }
    
    func fetchTests() async {
        print("CONSOLE-DEBUG: DataService fetchTests called")
        guard let uid = self.userSession?.uid else { return }
        print("CONSOLE-DEBUG: DataService fetchTests userSession is \(uid)")
        guard let snapshot = try? await Firestore.firestore()
            .collection("tests")
            .whereField("userId", isEqualTo: uid)
            .getDocuments() else { return }
        
        var tests = snapshot.documents.compactMap({ try? $0.data(as: Test.self) })
        tests.sort { $0.date > $1.date }
        
        self.tests = tests
        
        self.chartData = tests.compactMap { test in
            return ChartPoint(date: test.date, reading: test.reading)
        }
        
        if self.tests!.count > 0 {
            prepareChartData()
        }
        print("CONSOLE-DEBUG: DataService fetchTests completed. \(tests.count) tests found")
    }
    
    func createTest(date: Date, reading: Double, notes: String) async throws {
        do {
            print("CONSOLE-DEBUG: DataService createTest called")
            guard let uid = self.userSession?.uid else { return }
            let test = Test(userId: uid, date: date, reading: reading, notes: notes)
            let encodedTest = try Firestore.Encoder().encode(test)
            try await Firestore.firestore().collection("tests").document(test.id).setData(encodedTest)
            print("CONSOLE-DEBUG: Test Created: \(test)")
            
            print("CONSOLE-DEBUG: DataService create test calling fetchTests")
            await fetchTests()
        } catch {
            print("CONSOLE-DEBUG: Failed to create test with error: \(error.localizedDescription)")
        }
    }
    
    func updateTest(test: Test) async throws {
        do {
            print("CONSOLE-DEBUG: DataService updateTest called")
            try await Firestore.firestore()
                .collection("tests")
                .document(test.id)
                .updateData(["reading": test.reading,
                             "notes": test.notes,
                             "date": test.date])
            print("CONSOLE-DEBUG: Test Updated: \(test)")
            
            await fetchTests()
        } catch {
            print("CONSOLE-DEBUG: Failed to update test with error: \(error.localizedDescription)")
        }
    }
    
    func deleteTest(test: Test) async throws {
        do {
            print("CONSOLE-DEBUG: DataService deleteTest called")
            try await Firestore.firestore()
                .collection("tests")
                .document(test.id)
                .delete()
            print("CONSOLE-DEBUG: Test Deleted: \(test)")
            
            await fetchTests()
        } catch {
            print("CONSOLE-DEBUG: Failed to delete test with error: \(error.localizedDescription)")
        }
    }
    
    func prepareChartData(){
        print("CONSOLE-DEBUG: Dataservice prepareCharData called")
        self.ninetyDaysData = filterTestsLastNDays(days: 90, tests: chartData!)
        self.oneYearData = filterTestsLastNDays(days: 365, tests: chartData!)

        let readings = chartData!.map { $0.reading }
        let minINRidx = chartData!.firstIndex { $0.reading == readings.min() } ?? 0
        let maxINRidx = chartData!.firstIndex { $0.reading == readings.max() } ?? 0

        self.chartMin = chartData![minINRidx].reading
        self.chartMax = chartData![maxINRidx].reading

        print("CONSOLE-DEBUG: PrepareChartData completed. chartData: \(chartData!.count), oneYearData: \(oneYearData!.count), ninetyDaysData: \(ninetyDaysData!.count)")
    }
    
    func filterTestsLastNDays(days: Int, tests: [ChartPoint]) -> [ChartPoint] {
        let currentDate = Date()
        let nDaysAgo = Calendar.current.date(byAdding: .day, value: -(days), to: currentDate)!
        let filteredTests = tests.filter { $0.date >= nDaysAgo && $0.date <= currentDate }
        return filteredTests
    }
    
}
