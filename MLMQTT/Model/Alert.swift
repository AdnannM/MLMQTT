//
//  Alert.swift
//  MLMQTT
//
//  Created by Adnann Muratovic on 29.05.25.
//

import Foundation

struct Alert: Identifiable, Codable {
    let id = UUID()
    let timestamp: String
    let machine: String
    let risk: Double
    let threshold: Double
    let overdue: Bool
    let features: [String: Double]
    let target: [String: Double]
    let error: String?
    
    var formattedTimestamp: String {
        let dateFormatter = ISO8601DateFormatter()
        if let date = dateFormatter.date(from: timestamp) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.timeStyle = .medium
            return displayFormatter.string(from: date)
        }
        return timestamp
    }
}
