//
//  TableView.swift
//  INR_Tracker_iOS_App
//
//  Created by Chris Brunet on 2024-01-02.
//

import SwiftUI

struct TableView: View {
    
    @StateObject var viewModel = TableViewModel()

    var body: some View {
        Button {
            
        } label: {
            Text("Fetch Tests")
        }
    }
}

#Preview {
    TableView()
}
