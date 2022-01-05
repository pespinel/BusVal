//
//  String.swift
//  BusVal
//
//  Created by Pablo on 06/03/2021.
//

import UIKit

extension String {
    subscript(index: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: index)]
    }

    subscript(range: Range<Int>) -> Substring {
        let start = self.index(self.startIndex, offsetBy: range.lowerBound)
        let end = self.index(self.startIndex, offsetBy: range.upperBound)
        return self[start..<end]
    }

    subscript(range: ClosedRange<Int>) -> Substring {
        let start = self.index(self.startIndex, offsetBy: range.lowerBound)
        let end = self.index(self.startIndex, offsetBy: range.upperBound)
        return self[start...end]
    }

    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }

    func utf8DecodedString() -> String {
         let data = self.data(using: .utf8)
         if let message = String(data: data!, encoding: .nonLossyASCII) {
                return message
          }
          return ""
    }

    func utf8EncodedString() -> String {
        let messageData = self.data(using: .nonLossyASCII)
        let text = String(data: messageData!, encoding: .utf8)
        return text!
    }

    func condenseWhitespace() -> String {
        let components = self.components(separatedBy: .whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
}
