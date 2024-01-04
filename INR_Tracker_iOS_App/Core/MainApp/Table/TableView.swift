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
    @State private var showNewTestView = false
    @State private var showUpdateTestView = false
    @State var selectedTest: Test?

    var body: some View {
        NavigationStack{
            ScrollView {
                if let data = viewModel.tests {
                    List {
                        ForEach(data) { test in
                            let formattedDate = formattedDate(test.date)
                            TableRowView(reading: String(test.reading), date: formattedDate)
                                .onTapGesture {
                                    selectedTest = test
                                    showNewView.toggle() // Show the update view
                                    showUpdateTestView = true // Set update view mode
                                }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .frame(height: UIScreen.main.bounds.height)
                } else {
                    Text("No Tests")
                }
            }
            .fullScreenCover(isPresented: $showNewView, content: {
                if showUpdateTestView {
                    UpdateTestView(selectedTest: $selectedTest)
                } else {
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
                        showNewView.toggle()
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

func formattedDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM dd yyyy"
    return dateFormatter.string(from: date)
}

#Preview {
    TableView()
}
