//
//  MKMapView.swift
//  BusVal
//
//  Created by Pablo on 07/03/2021.
//

import MapKit

extension MKMapView {
    func fitAll() {
        var zoomRect = MKMapRect.null

        for annotation in annotations {
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect = MKMapRect(
                x: annotationPoint.x,
                y: annotationPoint.y,
                width: 0.01,
                height: 0.01
            )
            zoomRect = zoomRect.union(pointRect)
        }
        setVisibleMapRect(
            zoomRect,
            edgePadding: UIEdgeInsets(
                top: 100, left: 100, bottom: 100, right: 100
            ),
            animated: true
        )
    }

    func fitAll(in annotations: [MKAnnotation], andShow show: Bool) {
        var zoomRect = MKMapRect.null

        for annotation in annotations {
            let aPoint = MKMapPoint(annotation.coordinate)
            let rect = MKMapRect(
                x: aPoint.x,
                y: aPoint.y,
                width: 0.1,
                height: 0.1
            )

            if zoomRect.isNull {
                zoomRect = rect
            } else {
                zoomRect = zoomRect.union(rect)
            }
        }
        if show {
            addAnnotations(annotations)
        }
        setVisibleMapRect(
            zoomRect,
            edgePadding: UIEdgeInsets(
                top: 100, left: 100, bottom: 100, right: 100
            ),
            animated: false
        )
    }
}
