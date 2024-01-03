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
    
    var tests: [Test]?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscribers()
        
        Task {
            try await fetchAndUpdateTests()
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
        let tests = snapshot.documents.compactMap({ try? $0.data(as: Test.self) })
        self.tests = tests
    }
    
    func fetchAndUpdateTests() async throws {
        do {
            try await fetchTests() // Fetch tests
            isLoading = false // Update loading state
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
}
