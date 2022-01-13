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
        if news.isEmpty {
            DispatchQueue.main.async {
                Wrapper.getNews { newsResponse in
                    switch newsResponse {
                    case let .success(news):
                        self.news = news
                    case let .failure(error):
                        self.error = error
                    }
                }
            }
        }
    }

    func clean() {
        news.removeAll()
    }
}
