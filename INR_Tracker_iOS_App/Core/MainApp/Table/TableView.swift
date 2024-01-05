//
//  TableView.swift
//  INR_Tracker_iOS_App
//
//  Created by Chris Brunet on 2024-01-02.
//

import SwiftUI

struct TableView: View {
    
    @StateObject var viewModel = TableViewModel()
    
    @State var showNewView = false
    @State var isUpdateView = false
    @State var selectedTest: Test?

    var body: some View {
        NavigationStack{
            VStack {
                if let data = viewModel.tests {
                    List {
                        ForEach(data) { test in
                            let formattedDate = formattedDate(test.date)
                            TableRowView(reading: test.reading, date: formattedDate)
                                .onTapGesture {
                                    selectedTest = test
                                    isUpdateView = true
                                    showNewView.toggle()
                                }
                        }
                    }
                    .listStyle(PlainListStyle())
                } else {
                    Text("No Tests")
                }
            } // end scroll view
            .fullScreenCover(isPresented: $showNewView, content: {
                if (selectedTest != nil) && (isUpdateView == true) {
                    UpdateTestView(selectedTest: $selectedTest)
                } else if (selectedTest == nil) && (isUpdateView == false) {
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
                        selectedTest = nil
                        isUpdateView = false
                        showNewView.toggle()
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
