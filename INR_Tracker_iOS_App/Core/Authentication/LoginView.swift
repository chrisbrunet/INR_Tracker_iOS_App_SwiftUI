//
//  LoginView.swift
//  INR_Tracker_iOS_App
//
//  Created by Chris Brunet on 2024-01-02.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack{
            VStack{
                Image("BloodDrop")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 200)
                    .padding(.vertical, 32)
                
                VStack(spacing: 24){
                    InputView(text: $viewModel.email, title: "Email Address", placeholder: "name@example.com")
                        .autocapitalization(.none)
                    
                    InputView(text: $viewModel.password, title: "Password", placeholder: "Enter Password", isSecureField: true)
                }
                .padding()
                
                Button {
                    Task {
                        try await viewModel.signIn()
                    }
                } label: {
                    HStack {
                        Text("SIGN IN")
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
                
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden()
                } label: {
                    HStack{
                        Text("Don't have an account?")
                        Text("Sign Up")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }

            }
        }
    }
}

extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !viewModel.email.isEmpty
        && viewModel.email.contains("@")
        && !viewModel.password.isEmpty
        && viewModel.password.count > 5
    }
}

#Preview {
    LoginView()
}
