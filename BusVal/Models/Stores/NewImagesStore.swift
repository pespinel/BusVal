//
//  NewImagesStore.swift
//  BusVal
//
//  Created by Pablo on 28/12/21.
//

import SwiftUI

class NewImagesStore: ObservableObject {
    @Published var newImage = UIImage()

    func fetch(url: String) {
        if self.newImage == UIImage() {
            DispatchQueue.main.async {
                Wrapper.getNewImage(url) { image in
                    self.newImage = image
                }
            }
        }
    }
}
