//
//  NewsView.swift
//  BusVal
//
//  Created by Pablo on 03/03/2021.
//

import Alamofire
import SkeletonUI
import SwiftUI
import SWXMLHash

// MARK: VIEWS
struct NewsView: View {
    @ObservedObject var newsStore: NewsStore

    var body: some View {
        NavigationView {
            VStack {
                if newsStore.error == nil {
                    newsList
                } else {
                    emptyNewsList
                }
            }
            .navigationBarTitle("Noticias", displayMode: .large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    refreshNewsToolbarButton
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear { self.newsStore.fetch() }
    }
}

// MARK: COMPONENTS
extension NewsView {
    private var newsList: some View {
        SkeletonList(with: newsStore.news, quantity: 5) { loading, new in
            VStack {
                if let _new = new {
                    NavigationLink(destination: NewDetailsView(new: _new)) {
                        HStack(alignment: .center) {
                            Image(systemSymbol: .book)
                                .imageScale(.large)
                                .foregroundColor(.accentColor)
                                .padding(.trailing)
                            VStack(alignment: .leading) {
                                Text(_new.title)
                                    .textCase(.uppercase)
                                    .font(.headline)
                                    .accessibility(addTraits: .isHeader)
                                    .lineLimit(2)
                                Text(_new.date).font(.body)
                            }
                        }
                    }.padding([.top, .bottom])
                } else {
                    Spacer()
                        .skeleton(with: loading)
                        .shape(type: .rectangle)
                        .appearance(type: .solid(color: .gray))
                        .multiline(lines: 2, scales: [1: 0.5])
                        .animation(type: .pulse())
                }
            }
        }.listStyle(InsetListStyle())
    }

    private var emptyNewsList: some View {
        VStack {
            Spacer()
            Text("Error descargando las noticias")
            Spacer()
        }
    }

    private var refreshNewsToolbarButton: some View {
        Button(
            action: {
                self.newsStore.clean()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.newsStore.fetch()
                }
            }, label: { Image(systemSymbol: .arrowClockwise) }
        )
    }
}

// MARK: PREVIEW
#if DEBUG
struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        let newsStore = NewsStore()

        TabView {
            NewsView(newsStore: newsStore)
                .tabItem {
                    Image(systemSymbol: .listDash)
                    Text("Preview")
                }
        }.onAppear {
            newsStore.fetch()
        }
    }
}
#endif
