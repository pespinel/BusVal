//
//  LineImageHelper.swift
//  BusVal
//
//  Created by Pablo on 27/12/21.
//

import SwiftUI
import UIKit

final class LineHelper {
    // MARK: Internal

    func getColor(line: String?, scheme: ColorScheme) -> UIColor {
        if line != nil {
            if line!.rangeOfCharacter(from: CharacterSet(charactersIn: "BCFHMPU")) != nil {
                return getNumericLineColor(line: line!, scheme: scheme)
            } else {
                return getAlphabeticLineColor(line: line!)
            }
        }
        return UIColor(.accentColor)
    }

    func getImage(line: String?) -> String {
        if line != nil {
            if line!.rangeOfCharacter(from: CharacterSet(charactersIn: "BCFHMPU")) != nil {
                return "\(line![0].lowercased()).square.fill"
            } else {
                return "\(line!).square.fill"
            }
        }
        return "o.square.fill"
    }

    func getDetails(tab: Int, store: LineDetailsStore) -> [LineDetails] {
        if tab == 0 {
            return store.lineDetails
        } else {
            return store.lineReturnDetails
        }
    }

    // MARK: Private

    private func getNumericLineColor(line: String, scheme: ColorScheme) -> UIColor {
        switch line {
        case "C1",
             "C2":
            return UIColor(red: 140 / 255, green: 140 / 255, blue: 132 / 255, alpha: 1.0)
        case "H":
            return UIColor(red: 228 / 255, green: 47 / 255, blue: 47 / 255, alpha: 1.0)
        case "P1", "P2", "P3", "P6", "P7", "P13", "PSC1", "PSC2", "PSC3":
            return UIColor(red: 109 / 255, green: 73 / 255, blue: 41 / 255, alpha: 1.0)
        case "M1", "M2", "M3", "M4", "M5", "M6", "M7":
            return UIColor(red: 111 / 255, green: 34 / 255, blue: 179 / 255, alpha: 1.0)
        case "F1", "F2", "F3", "F4", "F5", "F6", "F7":
            return UIColor(red: 75 / 255, green: 119 / 255, blue: 92 / 255, alpha: 1.0)
        case "U1", "U8":
            return UIColor(red: 228 / 255, green: 100 / 255, blue: 100 / 255, alpha: 1.0)
        case "B1", "B2", "B3", "B4", "B5":
            if scheme == .light {
                return UIColor(.black)
            } else {
                return UIColor(red: 140 / 255, green: 140 / 255, blue: 132 / 255, alpha: 1.0)
            }
        default:
            return UIColor(.accentColor)
        }
    }

    // swiftlint:disable cyclomatic_complexity function_body_length
    private func getAlphabeticLineColor(line: String) -> UIColor {
        switch line {
        case "1":
            return UIColor(red: 39 / 255, green: 174 / 255, blue: 96 / 255, alpha: 1.0)
        case "2":
            return UIColor(red: 243 / 255, green: 156 / 255, blue: 18 / 255, alpha: 1.0)
        case "3":
            return UIColor(red: 232 / 255, green: 67 / 255, blue: 147 / 255, alpha: 1.0)
        case "4":
            return UIColor(red: 167 / 255, green: 123 / 255, blue: 6 / 255, alpha: 1.0)
        case "5":
            return UIColor(red: 18 / 255, green: 176 / 255, blue: 232 / 255, alpha: 1.0)
        case "6":
            return UIColor(red: 248 / 255, green: 165 / 255, blue: 194 / 255, alpha: 1.0)
        case "7":
            return UIColor(red: 105 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1.0)
        case "8":
            return UIColor(red: 255 / 255, green: 165 / 255, blue: 0 / 255, alpha: 1.0)
        case "9":
            return UIColor(red: 10 / 255, green: 117 / 255, blue: 173 / 255, alpha: 1.0)
        case "10":
            return UIColor(red: 153 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1.0)
        case "13":
            return UIColor(red: 0 / 255, green: 0 / 255, blue: 255 / 255, alpha: 1.0)
        case "14":
            return UIColor(red: 0 / 255, green: 0 / 255, blue: 128 / 255, alpha: 1.0)
        case "16":
            return UIColor(red: 180 / 255, green: 230 / 255, blue: 255 / 255, alpha: 1.0)
        case "17":
            return UIColor(red: 179 / 255, green: 230 / 255, blue: 45 / 255, alpha: 1.0)
        case "18":
            return UIColor(red: 221 / 255, green: 224 / 255, blue: 229 / 255, alpha: 1.0)
        case "19":
            return UIColor(red: 251 / 255, green: 140 / 255, blue: 33 / 255, alpha: 1.0)
        case "23":
            return UIColor(red: 246 / 255, green: 211 / 255, blue: 71 / 255, alpha: 1.0)
        case "24":
            return UIColor(red: 20 / 255, green: 74 / 255, blue: 108 / 255, alpha: 1.0)
        case "26":
            return UIColor(red: 180 / 255, green: 230 / 255, blue: 255 / 255, alpha: 1.0)
        case "33":
            return UIColor(red: 53 / 255, green: 113 / 255, blue: 89 / 255, alpha: 1.0)
        default:
            return UIColor(.accentColor)
        }
    }
}
