//
//  NewsStore.swift
//  BusVal
//
//  Created by Pablo on 23/12/21.
//

import SwiftUI

class NewsStore: ObservableObject {
    @Published var news = [New]()
    @Published var error: Wrapper.APIError?

    func fetch() {
        if self.news.isEmpty {
            DispatchQueue.main.async {
                Wrapper.getNews { newsResponse in
                    switch newsResponse {
                    case .success(let news):
                        self.news = news
                    case .failure(let error):
                        self.error = error
                    }
                }
            }
        }
    }

    func clean() {
        self.news.removeAll()
    }
}
