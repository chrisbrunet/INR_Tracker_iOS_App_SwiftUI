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
        print("CONSOLE-DEBUG: AuthService Init() called. userSession id is \(String(describing: userSession?.uid))")
        
        Task {
            await fetchUser()
            print("CONSOLE-DEBUG: AuthService Init() Task { fetchUser } currentUser is \(String(describing: currentUser?.fullName))")
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            print("CONSOLE-DEBUG: AuthService signIn called. Email: \(email), Password: \(password)")
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            
            self.userSession = result.user
            print("CONSOLE-DEBUG: AuthService signIn completed. userSession id is \(String(describing: userSession?.uid))")
            
            print("CONSOLE-DEBUG: AuthService signIn now calling fetchUser")
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

        print("CONSOLE-DEBUG: AuthService fetchUser completed. currentUser set to: \(String(describing: self.currentUser?.fullName))")
    }
    
    func deleteAccount(email: String, password: String) async {
        print("CONSOLE-DEBUG: AuthService deleteAccount called")
        guard let user = Auth.auth().currentUser else { return }
        let uid = user.uid
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        do {
            try await user.reauthenticate(with: credential)
            print("CONSOLE-DEBUG: User successfully re-authenticated")
        } catch {
            print("CONSOLE-DEBUG: Error re-autenticating user: \(error.localizedDescription)")
            return
        }
        
        self.userSession = nil
        self.currentUser = nil
    
        let snapshot = try? await Firestore.firestore()
            .collection("tests")
            .whereField("userId", isEqualTo: uid)
            .getDocuments()
        
        let tests = snapshot!.documents.compactMap({ test in
            try? test.data(as: Test.self) })
        print("CONSOLE-DEBUG: \(tests.count) tests found")
        
        for test in tests {
            do {
                try await Firestore.firestore()
                    .collection("tests")
                    .document(test.id)
                    .delete()
            } catch {
                print("CONSOLE-DEBUG: Error deleting test: \(error.localizedDescription)")
            }
        }
        
        print("CONSOLE-DEBUG: \(tests.count) tests deleted from tests collection")
        
        do {
            try await Firestore.firestore()
                .collection("users")
                .document(uid)
                .delete()
            print("CONSOLE-DEBUG: User deleted from users collection")
        } catch {
            print("CONSOLE-DEBUG: Error deleting user: \(error.localizedDescription)")
        }
        
        do {
            try await user.delete()
            print("CONSOLE-DEBUG: User account deleted")
        } catch {
            print("CONSOLE-DEBUG: Error deleting user account: \(error.localizedDescription)")
        }
    }
    
    func setCurrentTR(min: Double, max: Double) async throws {
        do {
            print("CONSOLE-DEBUG: DataService setCurrentTR called")
            guard let uid = self.userSession?.uid else { return }
            try await Firestore.firestore()
                .collection("users")
                .document(uid)
                .updateData(["minTR": min,
                             "maxTR": max])
            print("CONSOLE-DEBUG: User Therapeutic Range Updated to \(min) - \(max)")
            
            await AuthService.shared.fetchUser()
        } catch {
            print("CONSOLE-DEBUG: Failed to update user therapeutic range with error: \(error.localizedDescription)")
        }
    }
    
    func setCurrentDose(dose: Double) async throws {
        do {
            print("CONSOLE-DEBUG: DataService setCurrentDose called")
            guard let uid = self.userSession?.uid else { return }
            try await Firestore.firestore()
                .collection("users")
                .document(uid)
                .updateData(["dose": dose])
            print("CONSOLE-DEBUG: User Current Dose Updated to \(dose)")
            
            await AuthService.shared.fetchUser()
        } catch {
            print("CONSOLE-DEBUG: Failed to update user therapeutic range with error: \(error.localizedDescription)")
        }
    }
}
