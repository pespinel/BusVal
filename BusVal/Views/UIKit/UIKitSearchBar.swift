//
//  UIKitSearchBar.swift
//  BusVal
//
//  Created by Pablo Espinel on 1/1/22.
//

import SwiftUI

struct UIKitSearchBar: UIViewRepresentable {
    class Coordinator: NSObject, UISearchBarDelegate {
        // MARK: Lifecycle

        init(text: Binding<String>) {
            _text = text
        }

        // MARK: Internal

        @Binding var text: String

        func searchBar(_: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }

    @Binding var text: String

    func makeCoordinator() -> UIKitSearchBar.Coordinator {
        Coordinator(text: $text)
    }

    func makeUIView(context: UIViewRepresentableContext<UIKitSearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context _: UIViewRepresentableContext<UIKitSearchBar>) {
        uiView.text = text
    }
}
