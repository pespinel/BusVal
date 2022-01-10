//
//  NewDetailsView.swift
//  BusVal
//
//  Created by Pablo on 04/03/2021.
//

import Alamofire
import Combine
import SwiftUI

// MARK: VIEW
struct NewDetailsView: View {
    let new: New

    @ObservedObject var newImageStore = NewImagesStore()

    var body: some View {
        ScrollView(.vertical) {
            newReader
        }
        .onAppear {
            if let _image = new.image {
                self.newImageStore.fetch(url: _image)
            }
        }
        .navigationBarTitle(Text(new.date), displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                refreshToolbarButton
            }
        }
    }
}

// MARK: COMPONENTS
extension NewDetailsView {
    private var newReader: some View {
        VStack(alignment: .leading) {
            Text(self.new.title!.components(separatedBy: "(")[0].lowercased().capitalizingFirstLetter())
                .bold()
                .font(.title3)
                .multilineTextAlignment(.leading)
                .foregroundColor(Color.accentColor)
                .padding()
            Image(uiImage: self.newImageStore.newImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text(self.new.description!.replacingOccurrences(of: "<BR>", with: "\n"))
                .multilineTextAlignment(.leading)
                .padding()
        }
    }

    private var refreshToolbarButton: some View {
        Button {
            let url: NSURL = URL(string: self.new.link!)! as NSURL
            UIApplication.shared.open(url as URL)
        } label: {
            Image(systemSymbol: .safariFill)
        }
    }
}

// MARK: PREVIEW
#if DEBUG
struct NewDetailsView_Previews: PreviewProvider {
    static let new = New(
        title: "New title ()",
        date: "01/01/2021",
        description: """
            <BR>Very long New description Very long New description
            <BR>Very long New description Very long New description
            <BR>Very long New description Very long New description
            <BR>Very long New description Very long New description
            <BR>Very long New description Very long New description
            <BR>Very long New description Very long New description
            <BR>Very long New description Very long New description
            <BR>Very long New description Very long New description
            <BR>Very long New description Very long New description
            <BR>Very long New description Very long New description
            <BR>Very long New description Very long New description
            <BR>Very long New description Very long New description
            <BR>Very long New description Very long New description
        """,
        link: "https://google.com",
        image: "imagen10"
    )

    static var previews: some View {
        NavigationView {
            NewDetailsView(new: new)
        }
    }
}
#endif
