//
//  ChartTest.swift
//  INR_Tracker_iOS_App
//
//  Created by Chris Brunet on 2024-01-03.
//

import Foundation

struct FormattedTest: Identifiable {
    var date: Date
    var reading: Double
    var animate: Bool = false
    
    var id: Date {return date}
}
