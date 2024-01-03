//
//  NewTestView.swift
//  INR_Tracker_iOS_App
//
//  Created by Chris Brunet on 2024-01-03.
//

import SwiftUI

struct NewTestView: View {
    
    @ObservedObject var viewModel: TableViewModel
    
    @Environment(\.dismiss) var dismiss
    @State private var reading = ""
    @State private var notes = ""
    
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack (alignment: .center, spacing: 24){
                    
                    DatePicker(selection: /*@START_MENU_TOKEN@*/.constant(Date())/*@END_MENU_TOKEN@*/, label: { /*@START_MENU_TOKEN@*/Text("Date")/*@END_MENU_TOKEN@*/ })
                        .padding()
                    
                    HStack {
                        Text("Reading")
                        
                        Spacer()
                        
                        TextField("ex. 2.5", text: $reading)
                            .border(Color.black)
                    }
                    .padding()
                    
                    HStack {
                        Text("Notes")
                        
                        Spacer()
                        
                        TextField("", text: $notes)
                            .border(Color.black)
                    }
                    .padding()
                    
                    Button {
                        Task {
                            try await viewModel.createTest(date: Date(), reading: Double(reading)!, notes: notes)
                            dismiss()
                        }
                    } label: {
                        HStack {
                            Text("CREATE TEST")
                                .fontWeight(.semibold)
                            
                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                    }
                    .background(Color(.systemBlue))
                    .cornerRadius(10)
                    .padding(.top, 24)

                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                }
            }
        }
    }
}

#Preview {
    NewTestView(viewModel: TableViewModel())
}
