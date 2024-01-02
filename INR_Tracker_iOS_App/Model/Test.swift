//
//  Test.swift
//  INR_Tracker_iOS_App
//
//  Created by Chris Brunet on 2024-01-02.
//

import Foundation

struct Test: Codable, Identifiable {
    let id: String
    let userId: String
    let date: Date
    let reading: Double
    let notes: String
}
