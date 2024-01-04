import SwiftUI

struct NewTestView: View {
    
    @StateObject var viewModel = NewTestViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Test Date")) {
                        HStack {
                            DatePicker("", selection: $viewModel.date, displayedComponents: .date)
                                .labelsHidden()
                            Spacer()
                        }
                    }
                    
                    Section(header: Text("Reading")) {
                        TextField("ex. 2.5", text: $viewModel.reading)
                            .keyboardType(.decimalPad)
                    }
                    
                    Section(header: Text("Notes")) {
                        TextField("Add notes here", text: $viewModel.notes)
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
                        .disabled(!formIsValid)
                    }
                    .opacity(formIsValid ? 1.0 : 0.5)
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
                }
            )
        }
    }
    
    func createTest() {
        Task {
            do {
                try await viewModel.createTest()
                dismiss()
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

extension NewTestView: TestFormProtocol {
    var formIsValid: Bool {
        return !viewModel.reading.isEmpty
    }
}

struct NewTestView_Previews: PreviewProvider {
    static var previews: some View {
        NewTestView()
    }
}
