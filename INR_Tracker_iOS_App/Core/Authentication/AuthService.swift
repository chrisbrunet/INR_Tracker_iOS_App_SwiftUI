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

@MainActor
class AuthService{
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    static let shared = AuthService()
    
    init(){
        self.userSession = Auth.auth().currentUser
        print("CONSOLE-DEBUG: AuthService Init() userSession id is \(String(describing: userSession?.uid))")
        
        Task {
            await fetchUser()
            print("CONSOLE-DEBUG: AuthService Init() currentUser id is \(String(describing: currentUser?.id))")
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            print("CONSOLE-DEBUG: AuthService signIn called. Email: \(email), Password: \(password)")
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            
            await fetchUser()
        } catch {
            print("CONSOLE-DEBUG: Failed to log in with error: \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            print("CONSOLE-DEBUG: AuthService createUser called. Email: \(email), Password: \(password)")
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            
            let user = User(fullName: fullname, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(self.userSession!.uid).setData(encodedUser)
            
            await fetchUser()
        } catch {
            print("CONSOLE-DEBUG: Failed to create user with error: \(error.localizedDescription)")
        }
    }
    
    func signOut(){
        do {
            print("CONSOLE-DEBUG: AuthService signOut called")
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("CONSOLE-DEBUG: Failed to sign out with error: \(error.localizedDescription)")
        }
    }
    
    func fetchUser() async {
        print("CONSOLE-DEBUG: AuthService fetchUser called")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore()
            .collection("users")
            .document(uid)
            .getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)

        print("CONSOLE-DEBUG: Setting currentUser to: \(String(describing: self.currentUser))")
    }
    
    func deleteAccount(){
        
    }
}
