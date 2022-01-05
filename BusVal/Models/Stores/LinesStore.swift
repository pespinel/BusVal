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
        if self.lines.isEmpty {
            DispatchQueue.main.async {
                Wrapper.getLines { linesResponse in
                    switch linesResponse {
                    case .success(let data):
                        self.lines = data
                    case .failure(let error):
                        self.error = error
                    }
                }
            }
        }
    }
}
