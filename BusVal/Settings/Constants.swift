// swiftlint:disable nesting number_separator

//
// Constants.swift
// BusVal
//
// Created by Pablo Espinel on 26/12/21.
//

import MapKit
import SFSafeSymbols
import SwiftUI

struct Constants {
    struct Tabs {
        static let names = ["Líneas", "Noticias", "Buscar", "Tarjeta", "Favoritos"]
        static let icons = [
            UIImage(systemSymbol: .bus),
            UIImage(systemSymbol: .newspaper),
            UIImage(systemSymbol: .docTextMagnifyingglass),
            UIImage(systemSymbol: .creditcard),
            UIImage(systemSymbol: .staroflife)
        ]
    }

    struct SearchTabs {
        static let names = ["Líneas", "Paradas"]
    }

    struct Lines {
        struct Segments {
            static let names = ["#", "B", "P", "M", "F", "C", "H", "U"]
            static let images = [
                "number.square.fill",
                "b.square.fill",
                "p.square.fill",
                "m.square.fill",
                "f.square.fill",
                "c.square.fill",
                "h.square.fill",
                "u.square.fill"
            ]
        }
    }

    struct LineDetailsTabs {
        static let names = ["Ida", "Vuelta"]
    }

    struct Location {
        static let start = CLLocationCoordinate2D(latitude: 41.65518, longitude: -4.72372)
        static let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        static let zoomedSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    }
}
