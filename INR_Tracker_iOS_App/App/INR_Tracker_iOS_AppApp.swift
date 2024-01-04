//
//  INR_Tracker_iOS_AppApp.swift
//  INR_Tracker_iOS_App
//
//  Created by Chris Brunet on 2024-01-02.
//

import SwiftUI
import FirebaseCore

//class AppDelegate: NSObject, UIApplicationDelegate {
//    func applicationWillTerminate(_ application: UIApplication, didFinishWithLaunchingOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        FirebaseApp.configure()
//        return true
//    }
//}

@main
struct INR_Tracker_iOS_AppApp: App {
    
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
//                .environmentObject(viewModel)
        }
    }
}
