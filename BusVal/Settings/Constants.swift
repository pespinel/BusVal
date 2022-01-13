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
    enum Tabs {
        static let names = ["Líneas", "Noticias", "Buscar", "Tarjeta", "Favoritos"]
        static let icons = [
            UIImage(systemSymbol: .bus),
            UIImage(systemSymbol: .newspaper),
            UIImage(systemSymbol: .docTextMagnifyingglass),
            UIImage(systemSymbol: .creditcard),
            UIImage(systemSymbol: .staroflife)
        ]
    }

    enum SearchTabs {
        static let names = ["Líneas", "Paradas"]
    }

    enum Lines {
        enum Segments {
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

    enum LineDetailsTabs {
        static let names = ["Ida", "Vuelta"]
    }

    enum Location {
        static let start = CLLocationCoordinate2D(latitude: 41.65518, longitude: -4.72372)
        static let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        static let zoomedSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    }
}
