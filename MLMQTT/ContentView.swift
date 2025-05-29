//
//  ContentView.swift
//  MLMQTT
//
//  Created by Adnann Muratovic on 29.05.25.
//

import SwiftUI

/// ---------------------------------------------------------------------------
/// MAIN VIEW
/// ---------------------------------------------------------------------------
struct ContentView: View {
    @StateObject private var mqttManager = MQTTManager()

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {

                // ── Connection indicator ─────────────────────────────────
                HStack(spacing: 6) {
                    Circle()
                        .fill(
                            mqttManager.connectionStatus.contains("Connected")
                                ? .green : .red
                        )
                        .frame(width: 10, height: 10)

                    Text(mqttManager.connectionStatus)
                        .font(.caption)
                        .foregroundStyle(
                            mqttManager.connectionStatus.contains("Connected")
                                ? .green : .red)

                    Spacer()

                    Text("Alerts: \(mqttManager.alerts.count)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)

                // ── Alerts list ──────────────────────────────────────────
                List {
                    ForEach(mqttManager.alerts) { alert in
                        AlertCard(alert: alert)
                            .listRowSeparator(.hidden)
                            .listRowInsets(
                                .init(
                                    top: 8, leading: 0, bottom: 8, trailing: 0))
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Machine Monitor")
        }
    }
}

#Preview {
    ContentView()
}
