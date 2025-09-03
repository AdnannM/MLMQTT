# Machine Monitor iOS Application

## Description

This iOS application serves as a real-time Machine Monitor, designed to visualize critical operational data streamed from a Python Machine Learning backend project. The communication between the backend and the iOS app is established using the **Message Queuing Telemetry Transport (MQTT)** protocol, which is ideal for efficient, lightweight messaging in IoT and M2M scenarios.

The application provides an intuitive user interface built with SwiftUI, following the **Model-View-ViewModel (MVVM)** architectural pattern for robust structure and maintainability. It displays key machine metrics and alerts, giving users insights into machine health and performance.

## Features

*   **Real-time Data Monitoring:** Visualizes live data streamed from the backend.
*   **Key Machine Metrics:** Displays essential operational data points such as:
    *   Risk Level
    *   Availability
    *   Coolant Flow
    *   Current Draw
    *   Downtime
    *   Humidity
    *   Hydraulic Pressure
    *   Last Service Days
    *   Minor Alarms
    *   Motor Load
    *   OEE (Overall Equipment Effectiveness)
    *   Performance
    *   Quality
    *   Temperature
    *   Vibration RMS
*   **Alerts:** Notifies users of critical events, such as "Maintenance overdue".
*   **Data Visualization:** Provides interactive charts (Bar, Line, Area, Scatter, Pie) to visualize historical and current data trends for the monitored metrics.

## Architecture

The application is built using the **MVVM (Model-View-ViewModel)** architectural pattern to ensure a clear separation of concerns, enhance testability, and improve maintainability.

## Data Communication

Data is received from a backend Python Machine Learning project using the **Message Queuing Telemetry Transport (MQTT)** protocol. MQTT is a lightweight, publish-subscribe network protocol that transports messages between devices. It is ideal for IoT and M2M (machine-to-machine) communication due to its efficiency and low bandwidth requirements. The application utilizes the **CocoaMQTT** Swift Package Manager library for handling the MQTT connection and message processing.

## Visuals

Includes various chart types implemented with SwiftUI to provide comprehensive data visualization.

## Visuals

Adnan Muratovic



