//
//  Test.swift
//  INR_Tracker_iOS_App
//
//  Created by Chris Brunet on 2024-01-02.
//

import Foundation
import FirebaseFirestoreSwift

struct Test: Codable, Identifiable {
    @DocumentID var testId: String?
    let userId: String
    var date: Date
    var reading: Double
    var notes: String
    var dose: Double
    
    var id: String {
        return testId ?? NSUUID().uuidString
    }
}
