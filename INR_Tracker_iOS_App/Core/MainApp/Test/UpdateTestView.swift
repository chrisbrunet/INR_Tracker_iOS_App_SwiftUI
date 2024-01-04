//
//  UpdateTestView.swift
//  INR_Tracker_iOS_App
//
//  Created by Chris Brunet on 2024-01-03.
//

import SwiftUI

struct UpdateTestView: View {
    
    @StateObject var viewModel = UpdateTestViewModel()
    
    @Binding var selectedTest: Test?
    
    // States to hold values
    @State private var testDate = Date()
    @State private var reading = ""
    @State private var notes = ""
        
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Test Date")) {
                        HStack {
                            DatePicker("", selection: $testDate, displayedComponents: .date)
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
                        Button(action: updateTest) {
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
                        Button(action: deleteTest) {
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
            .navigationBarTitle("Update Test", displayMode: .inline)
            .navigationBarItems(leading:
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .fontWeight(.semibold)
                }
            )
            .onAppear {
                if let selectedTest = selectedTest {
                    testDate = selectedTest.date
                    reading = String(selectedTest.reading)
                    notes = selectedTest.notes
                }
            }
        }
    }
    
    func updateTest() {
        guard var updatedTest = selectedTest else { return }
        updatedTest.date = testDate
        updatedTest.reading = Double(reading) ?? 0.0
        updatedTest.notes = notes
        
        Task {
            do {
                try await viewModel.updateTest(test: updatedTest)
                dismiss()
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteTest() {
        guard let deletedTest = selectedTest else { return }
        
        Task {
            do {
                try await viewModel.deleteTest(test: deletedTest)
                dismiss()
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

//struct UpdateTestView_Previews: PreviewProvider {
//    static var previews: some View {
//        UpdateTestView(selectedTest: <#T##Binding<Test?>#>)
//    }
//}
