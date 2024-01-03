//
//  TableView.swift
//  INR_Tracker_iOS_App
//
//  Created by Chris Brunet on 2024-01-02.
//

import SwiftUI

struct TableView: View {
    
    @StateObject var viewModel = TableViewModel()
    @State private var showNewTestView = false

    var body: some View {
        NavigationStack{
            if viewModel.isLoading {
                ProgressView()
            } else {
                ScrollView {
                    if let tests = viewModel.tests {
                        List {
                            ForEach(tests) { test in
                                TableRowView(reading: String(test.reading), date: "date")
                            }
                        }
                        .listStyle(PlainListStyle())
                        .frame(height: UIScreen.main.bounds.height)
                    } else {
                        Text("No Tests")
                    }
                }
                .fullScreenCover(isPresented: $showNewTestView, onDismiss: {
                    Task {
                        do {
                            viewModel.tests = try await viewModel.fetchTests()
                        } catch {
                            print("Failed to fetch tests with error: \(error.localizedDescription)")
                        }
                    }
                }, content: {
                    NewTestView(viewModel: viewModel)
                })
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("INR Tests")
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showNewTestView.toggle()
                        } label: {
                            HStack{
                                Text("New Test")
                                
                                Image(systemName: "square.and.pencil.circle.fill")
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    TableView()
}
