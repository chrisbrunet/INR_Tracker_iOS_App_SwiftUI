//
//  ChartTest.swift
//  INR_Tracker_iOS_App
//
//  Created by Chris Brunet on 2024-01-03.
//

import Foundation

struct ChartPoint: Identifiable {
    var date: Date
    var reading: Double
    var dose: Double
    var animate: Bool = false
    
    var id: Date {return date}
}
