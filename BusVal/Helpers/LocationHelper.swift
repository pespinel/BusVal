//
//  LocationHelper.swift
//  BusVal
//
//  Created by Pablo on 24/12/21.
//

import MapKit

final class LocationHelper: NSObject, ObservableObject, CLLocationManagerDelegate {
    // MARK: Internal

    var locationManager: CLLocationManager?

    @Published var region = MKCoordinateRegion(center: Constants.Location.start, span: Constants.Location.zoomedSpan)

    func checkLocationStatus() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager = CLLocationManager()
                self.locationManager?.delegate = self
            }
        }
    }

    func updateLocation() {
        checkLocationStatus()
    }

    func locationManagerDidChangeAuthorization(_: CLLocationManager) {
        checkLocationAuthorization()
    }

    // MARK: Private

    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else {
            return
        }

        switch locationManager.authorizationStatus {
        case .denied, .notDetermined, .restricted:
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
}
