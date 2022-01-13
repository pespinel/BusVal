//
//  Checkpoint.swift
//  BusVal
//
//  Created by Pablo on 07/03/2020.
//

import MapKit

final class Checkpoint: NSObject, MKAnnotation, Identifiable {
    var clusteringIdentifier: String?
    var glyphImage: UIImage?
    var tintColor: UIColor?

    let id = UUID()
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    let stop: Stop?
    let stopCode: String?

    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D, stop: Stop?) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.stop = stop
        stopCode = nil
    }

    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D, stopCode: String?) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        stop = nil
        self.stopCode = stopCode
    }
}
