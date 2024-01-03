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
                            ForEach(tests, id: \.id) { test in
                                let formatted = formattedDate(test.date)
                                TableRowView(reading: String(test.reading), date: formatted)
                            }
                        }
                        .listStyle(PlainListStyle())
                        .frame(height: UIScreen.main.bounds.height)
                    } else {
                        Text("No Tests")
                    }
                }
                .fullScreenCover(isPresented: $showNewTestView, content: {
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

func formattedDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM dd yyyy"
    return dateFormatter.string(from: date)
}

#Preview {
    TableView()
}
