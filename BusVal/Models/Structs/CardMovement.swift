//
//  CardMovement.swift
//  App
//
//  Created by Pablo Espinel on 2/1/22.
//

import Foundation

struct CardMovement: Hashable, Identifiable {
    let id = UUID()
    let date: String
    let type: String
    let ammount: String
    let balance: String
}
