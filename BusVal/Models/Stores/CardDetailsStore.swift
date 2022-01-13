//
//  CardDetailsStore.swift
//  App
//
//  Created by Pablo Espinel on 2/1/22.
//

import Foundation

class CardDetailsStore: ObservableObject {
    @Published var cardBalance = CardBalance(balance: "")
    @Published var cardMovements = [CardMovement]()
    @Published var error: Wrapper.APIError?
    @Published var loading = false

    func fetch(card: String) {
        if cardMovements.isEmpty || cardBalance.balance.isEmpty {
            DispatchQueue.main.async {
                self.loading = true
                Wrapper.getCardDetails(card) { cardDetailsReponse in
                    switch cardDetailsReponse {
                    case let .success(balance, movements):
                        if balance.balance.isEmpty {
                            self.error = Wrapper.APIError.noResponse
                        } else {
                            self.cardBalance = balance
                            self.cardMovements = movements
                        }
                        self.loading = false
                    case let .failure(error):
                        self.error = error
                        self.loading = false
                    }
                }
            }
        }
    }

    func clean() {
        cardMovements.removeAll()
        cardBalance = CardBalance(balance: "")
    }
}
