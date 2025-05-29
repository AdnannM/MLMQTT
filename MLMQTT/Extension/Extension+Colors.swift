//
//  Extension+Colors.swift
//  MLMQTT
//
//  Created by Adnann Muratovic on 29.05.25.
//

import SwiftUI

/// ---------------------------------------------------------------------------
/// HELPER: Colour mapping for individual metrics
/// ---------------------------------------------------------------------------
extension Color {
    static func metricTint(for key: String) -> Color {
        switch key.lowercased() {
        case "hydraulicpressure", "pressure", "coolantflow":
            return Color.cyan
        case "oee":
            return Color.orange
        case "availability":
            return Color.green
        case "performance":
            return Color.pink
        case "quality":
            return Color.teal
        case "temperature":
            return Color.red.opacity(0.8)
        case "downtime":
            return Color.yellow
        default:
            return Color.gray
        }
    }
}
