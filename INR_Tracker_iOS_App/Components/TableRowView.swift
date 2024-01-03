//
//  TableRowView.swift
//  INR_Tracker_iOS_App
//
//  Created by Chris Brunet on 2024-01-03.
//

import SwiftUI

struct TableRowView: View {
    let reading: String
    let date: String
    
    var body: some View {
        HStack{
            Text(reading)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(width: 72, height: 72)
                .background(Color(.systemGray3))
                .clipShape(Circle())
            
            Spacer()
            
            Text(date)
            
            Image(systemName: "chevron.right")
        }
        .frame(height: 72)
        .padding()
    }
}

#Preview {
    TableRowView(reading: "2.5", date: "2023-12-11")
}
