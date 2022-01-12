//
//  Analytics.swift
//  BusVal
//
//  Created by Pablo on 12/1/22.
//

import Firebase
import SwiftUI

public func registerScreen(view: String) {
    Analytics.logEvent(
        AnalyticsEventScreenView,
        parameters: [
            AnalyticsParameterScreenName: "\(view)"
        ]
    )
}
