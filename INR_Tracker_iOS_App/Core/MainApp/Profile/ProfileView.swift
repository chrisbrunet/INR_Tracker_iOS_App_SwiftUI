//
//  ProfileView.swift
//  INR_Tracker_iOS_App
//
//  Created by Chris Brunet on 2024-01-02.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject var viewModel = ProfileViewModel()
    @State var currentMinTR = ""
    @State var currentMaxTR = ""
    @State var currentDose = ""
    
    var body: some View {
        NavigationStack {
            if let user = viewModel.currentUser {
                List {
                    Section{
                        HStack(spacing: 15){
                            
                            Text(user.initials)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 72, height: 72)
                                .background(Color(.systemGray3))
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4){
                                Text(user.fullName)
                                    .fontWeight(.semibold)
                                    .padding(.top, 4)
                                
                                Text(user.email)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                            
                        }
                    }
                    
                    Section("General"){
                        HStack{
                            SettingsRowView(imageName: "gear", title: "Version", tintColor: Color(.systemGray))
                            Spacer()
                            
                            Text("1.0.0")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                    }
                    
                    if let user = viewModel.currentUser {
                        let min = Double(round(100 * user.minTR) / 100)
                        let max = Double(round(100 * user.maxTR) / 100)
                        let dose = Double(round(100 * user.dose) / 100)
                        Section("Health"){
                            HStack{
                                SettingsRowView(imageName: "gauge.with.dots.needle.33percent", title: "Therapeutic Range", tintColor: Color(.systemGreen))
                                Spacer()
                                
                                Text("\(String(describing: min)) - \(String(describing: max))")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .onTapGesture {
                                viewModel.showTRAlert.toggle()
                            }
                            
                            HStack{
                                SettingsRowView(imageName: "pill.circle", title: "Current Dose", tintColor: Color(.systemGreen))
                                Spacer()
                                
                                
                                Text("\(String(describing: dose)) mg/week")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                                
                            }
                            .onTapGesture {
                                viewModel.showDoseAlert.toggle()
                            }
                            
                        }
                    } else {
                        Section("Health"){
                            HStack{
                                SettingsRowView(imageName: "gauge.with.dots.needle.33percent", title: "Therapeutic Range", tintColor: Color(.systemGreen))
                                Spacer()
                                
                                Text("none")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .onTapGesture {
                                viewModel.showTRAlert.toggle()
                            }
                            
                            HStack{
                                SettingsRowView(imageName: "pill.circle", title: "Current Dose", tintColor: Color(.systemGreen))
                                Spacer()
                                
                                
                                Text("none")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                                
                            }
                            .onTapGesture {
                                viewModel.showDoseAlert.toggle()
                            }
                            
                        }
                    }
                    
                    Section("Account"){
                        
                        Button {
                            viewModel.signOut()
                        } label: {
                            SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: Color(.red))
                        }
                        
                        Button {
                            print("Deleting account...")
                        } label: {
                            SettingsRowView(imageName: "xmark.circle.fill", title: "Delete Account", tintColor: Color(.red))
                        }
                        
                        
                    }
                    
                } // end of list
                .alert("Therapeutic Range", isPresented: $viewModel.showTRAlert, actions: {
                    TextField("Minimum INR", text: $currentMinTR)
                        .keyboardType(.decimalPad)
                    TextField("Maximum INR", text: $currentMaxTR)
                        .keyboardType(.decimalPad)
                    
                    Button("Submit", action: {
                        Task {
                            viewModel.minTR = currentMinTR
                            viewModel.maxTR = currentMaxTR
                            try await viewModel.setCurrentTR()
                            currentMinTR = ""
                            currentMaxTR = ""
                        }
                    })
                    Button("Cancel", role: .cancel, action: {})
                }, message: {
                    Text("Please enter your minimum and maximum INR range")
                })
                .alert("Current Dose", isPresented: $viewModel.showDoseAlert, actions: {
                    TextField("Dose (mg/week)", text: $currentDose)
                        .keyboardType(.decimalPad)
                    
                    Button("Submit", action: {
                        Task {
                            viewModel.dose = currentDose
                            try await viewModel.setCurrentDose()
                            currentDose = ""
                        }
                    })
                    Button("Cancel", role: .cancel, action: {})
                }, message: {
                    Text("Please enter your current weekly Warfarin dose")
                })
            } else {
                ProgressView()
            }
        }
    }
}

#Preview {
    ProfileView()
}
