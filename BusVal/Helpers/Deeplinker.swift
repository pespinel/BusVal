//
//  Deeplinker.swift
//  BusVal
//
//  Created by Pablo on 7/1/22.
//

import Foundation
import SwiftUI

// MARK: - Deeplinker

class Deeplinker {
    enum Deeplink: Equatable {
        case home
        case details(code: String)
    }

    func manage(url: URL) -> Deeplink? {
        guard url.scheme == URL.appScheme else {
            return nil
        }
        guard url.pathComponents.contains(URL.appDetailsPath) else {
            return .home
        }
        guard let query = url.query else {
            return .details(code: "")
        }

        let components = query.split(separator: ",").flatMap { $0.split(separator: "=") }
        guard let idIndex = components.firstIndex(of: Substring(URL.appCodeQueryName)) else {
            return nil
        }
        guard idIndex + 1 < components.count else {
            return nil
        }
        return .details(code: String(components[idIndex.advanced(by: 1)]))
    }
}

// MARK: - DeeplinkKey

struct DeeplinkKey: EnvironmentKey {
    static var defaultValue: Deeplinker.Deeplink? {
        nil
    }
}

extension EnvironmentValues {
    var deeplink: Deeplinker.Deeplink? {
        get {
            self[DeeplinkKey.self]
        }
        set {
            self[DeeplinkKey.self] = newValue
        }
    }
}

extension URL {
    static let appScheme = "busval"
    static let appHost = "www.auvasa.es"
    static let appHomeURL = "\(Self.appScheme)://\(Self.appHost)"
    static let appDetailsPath = "details"
    static let appCodeQueryName = "code"
    static let appDetailsURLFormat = "\(Self.appHomeURL)/\(Self.appDetailsPath)?\(Self.appCodeQueryName)=%@"
}
