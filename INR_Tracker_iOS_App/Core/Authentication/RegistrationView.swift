//
//  RegistrationView.swift
//  INR_Tracker_iOS_App
//
//  Created by Chris Brunet on 2024-01-02.
//

import SwiftUI

struct RegistrationView: View {
    
    @StateObject var viewModel = RegistrationViewModel()
    @State private var confirmPassword = ""
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Image("BloodDrop")
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 200)
                .padding(.vertical, 32)
            
            VStack(spacing: 24){
                InputView(text: $viewModel.email, title: "Email Address", placeholder: "name@example.com")
                    .autocapitalization(.none)
                
                InputView(text: $viewModel.fullname, title: "Full Name", placeholder: "John Doe")
                
                InputView(text: $viewModel.password, title: "Password", placeholder: "Enter Password", isSecureField: true)
                
                InputView(text: $confirmPassword, title: "Confirm Password", placeholder: "Enter Password", isSecureField: true)
            }
            .padding()
            
            Button {
                Task {
                    try await viewModel.createUser()
                }
            } label: {
                HStack {
                    Text("SIGN UP")
                        .fontWeight(.semibold)
                    
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            }
            .background(Color(.systemBlue))
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1.0 : 0.5)
            .cornerRadius(10)
            .padding(.top, 24)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                HStack{
                    Text("Already have an account?")
                    Text("Sign In")
                        .fontWeight(.bold)
                }
            }
            .font(.system(size: 14))
        }
    }
}

extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !viewModel.email.isEmpty
        && viewModel.email.contains("@")
        && !viewModel.password.isEmpty
        && viewModel.password.count > 5
        && confirmPassword == viewModel.password
        && !viewModel.fullname.isEmpty
    }
}

#Preview {
    RegistrationView()
}
