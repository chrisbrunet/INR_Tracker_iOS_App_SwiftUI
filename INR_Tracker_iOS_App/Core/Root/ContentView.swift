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
                TabView(selection: $viewModel.selectedTab){
                    ChartView()
                        .tabItem() {
                            Image(systemName: "chart.bar")
                            Text("Chart")
                        }
                        .tag(0)
                    TableView()
                        .tabItem() {
                            Image(systemName: "list.bullet")
                            Text("Table")
                        }
                        .tag(1)
                    ProfileView()
                        .tabItem() {
                            Image(systemName: "person.fill")
                            Text("Profile")
                        }
                        .tag(2)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
