//
//  CardBalance.swift
//  App
//
//  Created by Pablo Espinel on 2/1/22.
//

import Foundation

struct CardBalance: Hashable, Identifiable {
    let id = UUID()
    let balance: String
}
