//
//  LocationHelper.swift
//  BusVal
//
//  Created by Pablo on 24/12/21.
//

import MapKit

final class LocationHelper: NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?

    @Published var region = MKCoordinateRegion(center: Constants.Location.start, span: Constants.Location.zoomedSpan)

    func checkLocationStatus() {
        DispatchQueue.main.async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager = CLLocationManager()
                self.locationManager?.delegate = self
            } else {
                print("Location disabled")
            }
        }
    }

    func updateLocation() {
        self.checkLocationStatus()
    }

    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }

        switch locationManager.authorizationStatus {
        case .notDetermined, .restricted, .denied:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(
                center: locationManager.location!.coordinate,
                span: Constants.Location.span
            )
        @unknown default:
            break
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
 }
