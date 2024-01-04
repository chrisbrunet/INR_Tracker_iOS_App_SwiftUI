//
//  AuthService.swift
//  INR_Tracker_iOS_App
//
//  Created by Chris Brunet on 2024-01-03.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

class AuthService{
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    static let shared = AuthService()
    
    init(){
        self.userSession = Auth.auth().currentUser
        print("DEBUG: User session id is \(userSession?.uid)")
        
        Task {
            await fetchUser()
            print("DEBUG: currentUser is \(currentUser?.fullName)")
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            
            await fetchUser()
        } catch {
            print("DEBUG: Failed to log in with error: \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            
            let user = User(fullName: fullname, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            
            await fetchUser()
        } catch {
            print("DEBUG: Failed to create user with error: \(error.localizedDescription)")
        }
    }
    
    func signOut(){
        do {
            try Auth.auth().signOut()
            self.userSession = nil
        } catch {
            print("DEBUG: Failed to sign out with error: \(error.localizedDescription)")
        }
    }
    
    func fetchUser() async {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
            self.currentUser = try? snapshot.data(as: User.self)
    
            print("DEBUG: fetchUSer setting currentUser to: \(self.currentUser)")
        }
    
    func deleteAccount(){
        
    }
}
