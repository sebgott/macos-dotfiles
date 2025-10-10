#!/usr/bin/swift

import Foundation
import CoreWLAN
import CoreLocation

// Location manager to request permissions
class LocationManager: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var permissionGranted = false
    
    override init() {
        super.init()
        manager.delegate = self
        
        // Check current status
        let status = manager.authorizationStatus
        if status == .notDetermined {
            // Request permission (macOS only supports authorizedAlways)
            manager.requestAlwaysAuthorization()
            // Wait for response
            RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.5))
        }
        permissionGranted = (status == .authorizedAlways)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        permissionGranted = (status == .authorizedAlways)
    }
}

// Initialize location manager for permissions
let locationManager = LocationManager()

// Get WiFi information using CoreWLAN framework
let client = CWWiFiClient.shared()

guard let interface = client.interface() else {
    print("NO_INTERFACE")
    exit(1)
}

let command = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "info"

switch command {
case "info":
    // Get current SSID
    if let ssid = interface.ssid() {
        print(ssid)
    } else {
        print("NOT_CONNECTED")
    }
    
case "scan":
    // Scan for networks
    do {
        let networks = try interface.scanForNetworks(withName: nil)
        for network in networks.prefix(15) {
            let ssid = network.ssid ?? "Unknown"
            let rssi = network.rssiValue
            print("\(ssid)|\(rssi)")
        }
    } catch {
        print("SCAN_ERROR")
    }
    
default:
    print("UNKNOWN_COMMAND")
}
