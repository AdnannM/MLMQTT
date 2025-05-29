//
//  FeatureRow.swift
//  MLMQTT
//
//  Created by Adnann Muratovic on 29.05.25.
//

import SwiftUI

/// ---------------------------------------------------------------------------
/// FEATURE ROW
/// ---------------------------------------------------------------------------
struct FeatureRow: View {
    let key: String
    let value: Double
    let target: Double?

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            // Key capsule
            Text(key)
                .font(.caption2.bold())
                .foregroundStyle(.white)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color.metricTint(for: key), in: Capsule())

            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value, format: .number.precision(.fractionLength(2)))
                    .font(.subheadline)

                if let target {
                    Spacer(minLength: 2)
                    Text("T")
                        .font(.caption2.bold())
                        .foregroundStyle(.secondary)
                    Text(target, format: .number.precision(.fractionLength(2)))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
