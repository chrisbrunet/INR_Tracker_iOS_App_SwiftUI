//
//  UpdateTestView.swift
//  INR_Tracker_iOS_App
//
//  Created by Chris Brunet on 2024-01-03.
//

import SwiftUI

struct UpdateTestView: View {
    
    @StateObject var viewModel = TestViewModel()
    
    @Binding var selectedTest: Test?
    
    @Environment(\.dismiss) var dismiss
    
    @State private var reading = ""
    @State private var notes = ""
    @State private var date = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Test Date")) {
                        HStack {
                            DatePicker("", selection: $date, displayedComponents: .date)
                                .labelsHidden()
                            Spacer()
                        }
                    }
                    
                    Section(header: Text("Reading")) {
                        TextField("ex. 2.5", text: $reading)
                            .keyboardType(.decimalPad)
                    }
                    
                    Section(header: Text("Notes")) {
                        TextField("Add notes here", text: $notes)
                    }
                    
                    Section {
                        Button(action: viewModel.updateTest) {
                            HStack {
                                Spacer()
                                Text("UPDATE TEST")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                        }
                        .listRowBackground(Color.blue)
                    }
                    
                    Section {
                        Button(action: viewModel.deleteTest) {
                            HStack {
                                Spacer()
                                Text("DELETE TEST")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                        }
                        .listRowBackground(Color.red)
                    }
                }
                .listStyle(GroupedListStyle())
            }
            .navigationBarTitle("New Test", displayMode: .inline)
            .navigationBarItems(leading:
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .fontWeight(.semibold)
                })
        }
    }
}

//struct UpdateTestView_Previews: PreviewProvider {
//    static var previews: some View {
//        UpdateTestView(selectedTest: <#T##Binding<Test?>#>)
//    }
//}
