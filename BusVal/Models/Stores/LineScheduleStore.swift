//
//  LineScheduleStore.swift
//  BusVal
//
//  Created by Pablo on 27/12/21.
//

import SwiftUI

class LineScheduleStore: ObservableObject {
    @Published var lineSchedule = LineSchedule(line: "", weekdays: "", saturdays: "", festive: "", note: "")
    @Published var error: Wrapper.APIError?

    func fetch(line: String) {
        DispatchQueue.main.async {
            Wrapper.getLineSchedule(line) { lineScheduleResponse in
                switch lineScheduleResponse {
                case .success(let data):
                    self.lineSchedule = data
                case .failure(let error):
                    self.error = error
                }
            }
        }
    }
}
