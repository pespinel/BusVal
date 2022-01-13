//
//  UIColor.swift
//  BusVal
//
//  Created by Pablo on 02/03/2020.
//

import UIKit

extension UIColor {
    static func random() -> UIColor {
        func random() -> Double { .random(in: 0 ... 1) }

        return UIColor(red: random(), green: random(), blue: random(), alpha: 1.0)
    }

    static func randomPalette() -> UIColor {
        func random() -> Int { .random(in: 0 ..< paletteColors.count) }

        let paletteColors = [
            UIColor(red: 64 / 255, green: 64 / 255, blue: 122 / 255, alpha: 1.0),
            UIColor(red: 112 / 255, green: 111 / 255, blue: 211 / 255, alpha: 1.0),
            UIColor(red: 51 / 255, green: 217 / 255, blue: 178 / 255, alpha: 1.0),
            UIColor(red: 247 / 255, green: 241 / 255, blue: 227 / 255, alpha: 1.0),
            UIColor(red: 52 / 255, green: 172 / 255, blue: 224 / 255, alpha: 1.0),
            UIColor(red: 44 / 255, green: 44 / 255, blue: 84 / 255, alpha: 1.0),
            UIColor(red: 71 / 255, green: 71 / 255, blue: 135 / 255, alpha: 1.0),
            UIColor(red: 170 / 255, green: 166 / 255, blue: 157 / 255, alpha: 1.0),
            UIColor(red: 34 / 255, green: 112 / 255, blue: 147 / 255, alpha: 1.0),
            UIColor(red: 33 / 255, green: 140 / 255, blue: 116 / 255, alpha: 1.0),
            UIColor(red: 255 / 255, green: 82 / 255, blue: 82 / 255, alpha: 1.0),
            UIColor(red: 255 / 255, green: 121 / 255, blue: 63 / 255, alpha: 1.0),
            UIColor(red: 209 / 255, green: 204 / 255, blue: 192 / 255, alpha: 1.0),
            UIColor(red: 255 / 255, green: 177 / 255, blue: 66 / 255, alpha: 1.0),
            UIColor(red: 255 / 255, green: 218 / 255, blue: 121 / 255, alpha: 1.0)
        ]

        return paletteColors[random()]
    }
}
