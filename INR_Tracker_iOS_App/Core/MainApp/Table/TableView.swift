//
//  TableView.swift
//  INR_Tracker_iOS_App
//
//  Created by Chris Brunet on 2024-01-02.
//

import SwiftUI

struct TableView: View {
    
    @StateObject var viewModel = TableViewModel()

    var body: some View {
        NavigationStack{
            VStack {
                if let data = viewModel.tests {
                    if data.count == 0 {
                        VStack {
                            Text("No Data")
                            Text("Select 'New Test' to add data")
                        }
                    } else {
                        if let user = viewModel.currentUser {
                            List {
                                ForEach(data) { test in
                                    let formattedDate = formattedDate(test.date)
                                    TableRowView(reading: test.reading, date: formattedDate, minTR: user.minTR, maxTR: user.maxTR)
                                        .onTapGesture {
                                            viewModel.selectedTest = test
                                            viewModel.isUpdateView = true
                                            viewModel.showNewView.toggle()
                                        }
                                }
                            }
                            .listStyle(PlainListStyle())
                        }
                    }
                } else {
                    ProgressView()
                }
            } // end scroll view
            .fullScreenCover(isPresented: $viewModel.showNewView, content: {
                if (viewModel.selectedTest != nil) && (viewModel.isUpdateView == true) {
                    UpdateTestView(selectedTest: $viewModel.selectedTest)
                } else if (viewModel.selectedTest == nil) && (viewModel.isUpdateView == false) {
                    NewTestView()
                }
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("INR Tests")
                        .font(.title)
                        .fontWeight(.semibold)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.selectedTest = nil
                        viewModel.isUpdateView = false
                        viewModel.showNewView.toggle()
                    } label: {
                        HStack{
                            Text("New Test")
                            
                            Image(systemName: "square.and.pencil.circle.fill")
                        }
                    }
                }
            }
        } // end nav stack
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
