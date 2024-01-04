//
//  TableRowView.swift
//  INR_Tracker_iOS_App
//
//  Created by Chris Brunet on 2024-01-03.
//

import SwiftUI

struct TableRowView: View {
    let reading: Double
    let date: String
    
    var body: some View {
        HStack{
            if reading < 2.0 || reading > 3.5 {
                Text(String(reading))
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 72, height: 72)
                    .background(.red)
                    .clipShape(Circle())
                
                Text("Outside of therapeutic range")
                    .font(.subheadline)
                
            } else if reading >= 2.5 && reading <= 3 {
                Text(String(reading))
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 72, height: 72)
                    .background(.green)
                    .clipShape(Circle())
                
                Text("Well within therepeutic range")
                    .font(.subheadline)
            } else if (reading >= 2 && reading < 2.5) ||
                    (reading > 3 && reading <= 3.5) {
                Text(String(reading))
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 72, height: 72)
                    .background(.yellow)
                    .clipShape(Circle())
                
                Text("Inside therepeutic range")
                    .font(.subheadline)
            }
            
            Spacer()
            
            Text(date)
            
            Image(systemName: "chevron.right")
        }
        .frame(height: 72)
        .padding()
    }
}

#Preview {
    TableRowView(reading: 3.1, date: "2023-12-11")
}
