//
//  NewDetailsView.swift
//  BusVal
//
//  Created by Pablo on 04/03/2021.
//

import Alamofire
import Kingfisher
import SwiftUI

// MARK: - NewDetailsView

struct NewDetailsView: View {
    let new: New

    var body: some View {
        ScrollView(.vertical) {
            newReader
        }
        .navigationBarTitle(Text(new.date), displayMode: .inline)
        .onAppear {
            registerScreen(view: "NewDetailsView")
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                refreshToolbarButton
            }
        }
    }
}

// MARK: Components

extension NewDetailsView {
    private var newReader: some View {
        VStack(alignment: .leading) {
            if let _image = new.image {
                KFImage(URL(string: Wrapper.Endpoint.newImage.getPath(id: _image))!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Image(systemSymbol: .newspaperFill)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            Text(self.new.title!.components(separatedBy: "(")[0].lowercased().capitalizingFirstLetter())
                .bold()
                .font(.title3)
                .multilineTextAlignment(.leading)
                .foregroundColor(Color.accentColor)
                .padding()
            Text(self.new.description!.replacingOccurrences(of: "<BR>", with: "\n"))
                .multilineTextAlignment(.leading)
                .padding([.leading, .trailing, .bottom])
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

// MARK: - NewDetailsView_Previews

#if DEBUG
    struct NewDetailsView_Previews: PreviewProvider {
        static let new = New(
            title: "New title ()",
            date: "01/01/2021",
            description: """
            Very long New description Very long New description
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
