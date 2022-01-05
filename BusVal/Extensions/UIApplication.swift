//
//  UIApplication.swift
//  BusVal
//
//  Created by Pablo on 30/12/21.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
