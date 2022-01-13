//
//  LinesStore.swift
//  BusVal
//
//  Created by Pablo on 23/12/21.
//

import SwiftUI

class LinesStore: ObservableObject {
    @Published var lines = [Line]()
    @Published var error: Wrapper.APIError?

    func fetch() {
        if lines.isEmpty {
            DispatchQueue.main.async {
                Wrapper.getLines { linesResponse in
                    switch linesResponse {
                    case let .success(data):
                        self.lines = data
                    case let .failure(error):
                        self.error = error
                    }
                }
            }
        }
    }
}
