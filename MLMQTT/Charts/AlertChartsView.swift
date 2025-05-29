//
//  AlertChartsView.swift
//  MLMQTT
//
//  Created by Adnann Muratovic on 29.05.25.
//

import Charts
import SwiftUI

/// ---------------------------------------------------------------------------
/// CHART SCREEN
/// ---------------------------------------------------------------------------
struct AlertChartsView: View {

    enum ChartKind: String, CaseIterable, Identifiable {
        case bar = "Bar"
        case line = "Line"
        case area = "Area"
        case scatter = "Scatter"
        case pie = "Pie"
        var id: Self { self }
    }

    let alert: Alert
    @State private var kind: ChartKind = .bar

    var body: some View {
        VStack {
            Picker("Chart Type", selection: $kind) {
                ForEach(ChartKind.allCases) { kind in
                    Text(kind.rawValue).tag(kind)
                }
            }
            .pickerStyle(.segmented)
            .padding([.horizontal, .top])

            // Chart switcher
            switch kind {
            case .bar: barChart
            case .line: lineChart
            case .area: areaChart
            case .scatter: scatterChart
            case .pie: pieChart
            }
        }
        .navigationTitle("\(alert.machine) Metrics")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Shared data sequence  (sorted to keep order stable)
    private var metrics: [(key: String, value: Double)] {
        alert.features.keys.sorted().compactMap { key in
            guard let v = alert.features[key] else { return nil }
            return (key, v)
        }
    }

    // MARK: - BAR
    private var barChart: some View {
        Chart {
            ForEach(metrics, id: \.key) { metric in
                BarMark(
                    x: .value("Metric", metric.key),
                    y: .value("Value", metric.value)
                )
                .foregroundStyle(Color.metricTint(for: metric.key))

                if let t = alert.target[metric.key] {
                    RuleMark(y: .value("Target", t))
                        .foregroundStyle(.red)
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [4]))
                }
            }
        }
        .chartYAxis { AxisMarks(position: .leading) }
        .padding()
    }

    // MARK: - LINE
    private var lineChart: some View {
        Chart {
            ForEach(metrics, id: \.key) { metric in
                LineMark(
                    x: .value("Metric", metric.key),
                    y: .value("Value", metric.value)
                )
                .foregroundStyle(Color.metricTint(for: metric.key))

                PointMark(
                    x: .value("Metric", metric.key),
                    y: .value("Value", metric.value)
                )
                .annotation(position: .top) {
                    Text(metric.key)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .chartXAxis(.hidden)
        .chartYAxis { AxisMarks(position: .leading) }
        .padding()
    }

    // MARK: - AREA
    private var areaChart: some View {
        Chart {
            ForEach(metrics, id: \.key) { metric in
                AreaMark(
                    x: .value("Metric", metric.key),
                    y: .value("Value", metric.value)
                )
                .foregroundStyle(Color.metricTint(for: metric.key).opacity(0.6))
            }
        }
        .chartXAxis(.hidden)
        .chartYAxis { AxisMarks(position: .leading) }
        .padding()
    }

    // MARK: - SCATTER
    private var scatterChart: some View {
        Chart {
            ForEach(metrics, id: \.key) { m in
                PointMark(
                    x: .value("Metric", m.key),
                    y: .value("Value", m.value)
                )
                .foregroundStyle(Color.metricTint(for: m.key))
                .symbolSize(80)
            }
        }
        .chartYAxis { AxisMarks(position: .leading) }
        .padding()
    }

    // MARK: - PIE (SectorMark) – iOS 17+
    @ViewBuilder
    private var pieChart: some View {
        if #available(iOS 17, *) {
            Chart {
                ForEach(alert.features.keys.sorted(), id: \.self) { key in
                    if let value = alert.features[key] {
                        SectorMark(
                            angle: .value("Value", value),
                            innerRadius: .ratio(0.50)
                        )
                        .foregroundStyle(by: .value("Metric", key))
                        .annotation(position: .overlay) {
                            Text(key)
                                .font(.caption2)
                                .foregroundStyle(.white)
                                .padding(2)
                        }
                    }
                }
            }
            .chartLegend(.visible)
            .padding()
        } else {
            Text("Pie charts require iOS 17 or later.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .padding()
        }
    }
}
