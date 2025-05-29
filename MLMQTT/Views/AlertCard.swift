//
//  AlertCard.swift
//  MLMQTT
//
//  Created by Adnann Muratovic on 29.05.25.
//

import SwiftUI

/// ---------------------------------------------------------------------------
/// ALERT CARD
/// ---------------------------------------------------------------------------
struct AlertCard: View {
    let alert: Alert

    private let grid = [GridItem(.flexible()), GridItem(.flexible())]

    // Colour tied to **machine name** for card chrome
    private var accent: Color {
        let hue = Double(abs(alert.machine.hashValue % 256)) / 255.0
        return Color(hue: hue, saturation: 0.60, brightness: 0.90)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // ── Header ────────────────────────────────────────────────
            HStack {
                Text(alert.machine)
                    .font(.headline)
                Spacer()
                Text(alert.formattedTimestamp)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            // ── Risk level ────────────────────────────────────────────
            HStack {
                Text("Risk Level")
                    .font(.subheadline.bold())
                Spacer()
                Text("\(Int(alert.risk * 100))%")
                    .font(.headline.bold())
                    .foregroundStyle(riskColour)
            }

            Divider()

            // ── Metric grid ───────────────────────────────────────────
            LazyVGrid(columns: grid, alignment: .leading, spacing: 10) {
                ForEach(alert.features.keys.sorted(), id: \.self) { key in
                    if let value = alert.features[key] {
                        FeatureRow(
                            key: key,
                            value: value,
                            target: alert.target[key]
                        )
                    }
                }
            }

            // ── Error / overdue ───────────────────────────────────────
            if let error = alert.error {
                Label(error, systemImage: "exclamationmark.triangle.fill")
                    .font(.caption)
                    .foregroundStyle(.red)
            }
            if alert.overdue {
                Label("Maintenance Overdue", systemImage: "clock.fill")
                    .font(.caption)
                    .foregroundStyle(.orange)
            }

            // ── Charts nav link ───────────────────────────────────────
            NavigationLink {
                AlertChartsView(alert: alert)
            } label: {
                Label("Show Charts", systemImage: "chevron.right")
                    .font(.footnote.bold())
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(accent)
            .padding(.top, 4)

        }
        .padding()
        .background(accent.opacity(0.10))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(accent.opacity(0.50), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
        .padding(.horizontal)
    }

    private var riskColour: Color {
        switch alert.risk {
        case ..<0.3: return .green
        case ..<0.6: return .yellow
        case ..<0.8: return .orange
        default: return .red
        }
    }
}
