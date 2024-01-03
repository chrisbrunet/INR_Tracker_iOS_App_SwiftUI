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
    
    var tests: [Test]?
    var testSnapshot: QuerySnapshot?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscribers()
        
        Task {
            await fetchTests()
        }
    }
    
    private func setupSubscribers(){
        AuthViewModel.shared.$currentUser.sink { [weak self] user in
            self?.currentUser = user
        }.store(in: &cancellables)
    }
    
    func fetchTests() async {
        print("fetch tests called")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("tests").getDocuments() else { return }
        testSnapshot = snapshot
        print(snapshot)
    }
    
    func createTest(date: Date, reading: Double, notes: String) async throws {
        do {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let test = Test(userId: uid, date: date, reading: reading, notes: notes)
            let encodedUser = try Firestore.Encoder().encode(test)
            try await Firestore.firestore().collection("tests").document(test.id).setData(encodedUser)
        } catch {
            print("DEBUG: Failed to create user with error: \(error.localizedDescription)")
        }
    }
    
    func updateTest(){
        
    }
    
    func deleteTest(){
        
    }
}
