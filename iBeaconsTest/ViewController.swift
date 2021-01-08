//
//  ViewController.swift
//  iBeaconsTest
//
//  Created by Tal talspektor on 08/01/2021.
//
import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var distanceReading: UILabel!
    private var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways,
           CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self),
           CLLocationManager.isRangingAvailable() {
            startScanning()
        }
    }

    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-AB14-092E77F6B7E5")!
        let beaconeRegion = CLBeaconRegion(proximityUUID: uuid,
                                           major: 123,
                                           minor: 456,
                                           identifier: "MyBeacone")
        locationManager?.startMonitoring(for: beaconeRegion)
        locationManager?.startRangingBeacons(in: beaconeRegion)
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "FAR"
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
            case .immediate:
                self.view.backgroundColor = .red
                self.distanceReading.text = "IMMEDIATE"
            default:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacons = beacons.first {
            update(distance: beacons.proximity)
        } else {
            update(distance: .unknown)
        }
    }
}

