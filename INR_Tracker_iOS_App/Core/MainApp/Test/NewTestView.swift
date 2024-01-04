import SwiftUI

struct NewTestView: View {
    
    @StateObject var viewModel = TestViewModel()
    
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
                        Button(action: createTest) {
                            HStack {
                                Spacer()
                                Text("CREATE TEST")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                        }
                        .listRowBackground(Color.blue)
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
    
    func createTest() {
        Task {
            do {
                try await viewModel.createTest(date: date, reading: Double(reading)!, notes: notes)
                dismiss()
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

struct NewTestView_Previews: PreviewProvider {
    static var previews: some View {
        NewTestView()
    }
}
