//
//  ContentView.swift
//  INR_Tracker_iOS_App
//
//  Created by Chris Brunet on 2024-01-02.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        Group {
            if viewModel.userSession == nil {
                LoginView()
            } else {
                TabView(){
                    TableView()
                        .tabItem() {
                            Image(systemName: "list.bullet")
                            Text("Table")
                        }
                    ChartView()
                        .tabItem() {
                            Image(systemName: "chart.bar")
                            Text("Chart")
                        }
                    ProfileView()
                        .tabItem() {
                            Image(systemName: "person.fill")
                            Text("Profile")
                        }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
