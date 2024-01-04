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
    @Published var userSession: FirebaseAuth.User?
    
    static let shared = DataService()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        print("CONSOLE-DEBUG: DataService init() called")
        setupSubscribers()
        Task {
            await fetchTests()
        }
    }
    
    private func setupSubscribers() {
        AuthService.shared.$userSession
            .assign(to: \.userSession, on: self)
            .store(in: &cancellables)
    }
    
    func fetchTests() async {
        print("CONSOLE-DEBUG: DataService fetchTests called")
//        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let uid = self.userSession?.uid else { return }
        guard let snapshot = try? await Firestore.firestore()
            .collection("tests")
            .whereField("userId", isEqualTo: uid)
            .getDocuments() else { return }
        
        var tests = snapshot.documents.compactMap({ try? $0.data(as: Test.self) })
        tests.sort { $0.date > $1.date }
        
        self.tests = tests
        print("CONSOLE-DEBUG: \(tests.count) tests found")
    }
    
    func createTest(date: Date, reading: Double, notes: String) async throws {
        do {
            print("CONSOLE-DEBUG: DataService createTest called")
//            guard let uid = Auth.auth().currentUser?.uid else { return }
            guard let uid = self.userSession?.uid else { return }
            let test = Test(userId: uid, date: date, reading: reading, notes: notes)
            let encodedTest = try Firestore.Encoder().encode(test)
            try await Firestore.firestore().collection("tests").document(test.id).setData(encodedTest)
            print("CONSOLE-DEBUG: Test Created: \(test)")
            
            await fetchTests()
        } catch {
            print("CONSOLE-DEBUG: Failed to create user with error: \(error.localizedDescription)")
        }
    }
    
    func updateTest(){
        
    }
    
    func deleteTest(){
        
    }
}
