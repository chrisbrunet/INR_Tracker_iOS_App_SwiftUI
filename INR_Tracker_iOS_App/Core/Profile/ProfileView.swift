//
//  ProfileView.swift
//  INR_Tracker_iOS_App
//
//  Created by Chris Brunet on 2024-01-02.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject var viewModel = ProfileViewModel()
    
    var body: some View {
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
                
            }
        } else {
            Text("Profile Not loading")
        }
    }
}

#Preview {
    ProfileView()
}
