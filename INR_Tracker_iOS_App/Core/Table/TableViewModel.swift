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
    
    @Published var currentUser: User?
    @Published var isLoading = true
    
    @Published var tests: [Test]?
    @Published var chartData: [ChartPoint]?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        print("Initializing Table View Model")
        setupSubscribers()
        
        Task {
            try await fetchAndUpdateTests()
            prepareChartData()
        }
    }
    
    private func setupSubscribers(){
        AuthViewModel.shared.$currentUser.sink { [weak self] user in
            self?.currentUser = user
        }.store(in: &cancellables)
    }
    
    func fetchTests() async throws {
        print("fetch tests called")
        let uid = Auth.auth().currentUser?.uid
        let snapshot = try await Firestore.firestore()
            .collection("tests")
            .whereField("userId", isEqualTo: uid!)
            .getDocuments()
        var tests = snapshot.documents.compactMap({ try? $0.data(as: Test.self) })
        tests.sort { $0.date > $1.date }
        self.tests = tests
    }
    
    func fetchAndUpdateTests() async throws {
        do {
            try await fetchTests()
            prepareChartData()
            isLoading = false
        } catch {
            print("Failed to fetch tests with error: \(error.localizedDescription)")
        }
    }
    
    func createTest(date: Date, reading: Double, notes: String) async throws {
        do {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let test = Test(userId: uid, date: date, reading: reading, notes: notes)
            let encodedTest = try Firestore.Encoder().encode(test)
            try await Firestore.firestore().collection("tests").document(test.id).setData(encodedTest)
            print("Test Created: \(test)")
            try await fetchAndUpdateTests()
        } catch {
            print("DEBUG: Failed to create user with error: \(error.localizedDescription)")
        }
    }
    
    func updateTest(){
        
    }
    
    func deleteTest(){
        
    }
    
    func prepareChartData(){
        self.chartData = tests!.compactMap { test in
            return ChartPoint(date: test.date, reading: test.reading)
        }
    }
}
