//
//  MQTTManager.swift
//  MLMQTT
//
//  Created by Adnann Muratovic on 29.05.25.
//

import CocoaMQTT
import Foundation

final class MQTTManager: ObservableObject, CocoaMQTTDelegate {
    private var mqtt: CocoaMQTT?
    @Published var alerts: [Alert] = []
    @Published var connectionStatus: String = "Disconnected"

    // MQTT Configuration
    private let mqttHost = "192.168.1.6"
    private let mqttPort: UInt16 = 1883
    private let mqttMaintenanceTopic = "alerts/machine_maintenance"
    private let mqttErrorTopic = "alerts/machine_errors"

    init() {
        print("MQTTManager initialized")
        setupMQTT()
    }

    private func setupMQTT() {
        let clientID = "iOS_\(UUID().uuidString)"
        mqtt = CocoaMQTT(clientID: clientID, host: mqttHost, port: mqttPort)

        // Configure MQTT client
        mqtt?.keepAlive = 60
        mqtt?.delegate = self
        mqtt?.autoReconnect = true
        mqtt?.cleanSession = true
        mqtt?.logLevel = .debug  // Enable debug logging

        // Connect to broker
        if let mqtt = mqtt {
            print(
                "Attempting to connect to MQTT broker at \(mqttHost):\(mqttPort)"
            )
            _ = mqtt.connect()
        }
    }

    // MARK: - CocoaMQTTDelegate

    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        switch ack {
        case .accept:
            print("Connected to MQTT broker")
            connectionStatus = "Connected"

            // Subscribe to topics
            print("Subscribing to topics...")
            mqtt.subscribe(mqttMaintenanceTopic)
            mqtt.subscribe(mqttErrorTopic)
        case .unacceptableProtocolVersion:
            print("Error: Unacceptable protocol version")
            connectionStatus = "Error: Unacceptable protocol version"
        case .identifierRejected:
            print("Error: Identifier rejected")
            connectionStatus = "Error: Identifier rejected"
        case .serverUnavailable:
            print("Error: Server unavailable")
            connectionStatus = "Error: Server unavailable"
        case .badUsernameOrPassword:
            print("Error: Bad username or password")
            connectionStatus = "Error: Bad username or password"
        case .notAuthorized:
            print("Error: Not authorized")
            connectionStatus = "Error: Not authorized"
        default:
            print("Error: Unknown connection error")
            connectionStatus = "Error: Unknown connection error"
        }
    }

    func mqtt(
        _ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage,
        id: UInt16
    ) {
        print("Received message on topic: \(message.topic)")
        print("Message payload length: \(message.payload.count)")

        let payload = message.payload
        if let jsonString = String(bytes: payload, encoding: .utf8) {
            print("Received JSON string: \(jsonString)")
            if let jsonData = jsonString.data(using: .utf8) {
                do {
                    let alert = try JSONDecoder().decode(
                        Alert.self, from: jsonData)
                    print("Successfully decoded alert: \(alert)")
                    DispatchQueue.main.async {
                        self.alerts.insert(alert, at: 0)
                        if self.alerts.count > 100 {
                            self.alerts.removeLast()
                        }
                        print(
                            "Updated alerts array, count: \(self.alerts.count)")
                    }
                } catch {
                    print("Error decoding message: \(error)")
                    print("Raw message: \(jsonString)")
                }
            }
        } else {
            print("Error converting message payload to string")
        }
    }

    func mqtt(
        _ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary,
        failed: [String]
    ) {
        print("Subscribed to topics: \(success)")
        if !failed.isEmpty {
            print("Failed to subscribe to topics: \(failed)")
        }
    }

    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        print(
            "Disconnected from MQTT broker: \(err?.localizedDescription ?? "No error")"
        )
        connectionStatus =
            "Disconnected: \(err?.localizedDescription ?? "No error")"

        // Attempt to reconnect after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            print("Attempting to reconnect...")
            _ = mqtt.connect()
        }
    }

    // Required delegate methods
    func mqtt(
        _ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage,
        id: UInt16
    ) {}
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {}
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {}
    func mqttDidPing(_ mqtt: CocoaMQTT) {}
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {}
}
