//
//  Searchview.swift
//  BusVal
//
//  Created by Pablo on 03/03/2021.
//

import SkeletonUI
import SwiftUI
import SWXMLHash

// MARK: VIEWS
struct SearchView: View {
    @Environment(\.colorScheme) var colorScheme

    @ObservedObject var linesStore: LinesStore
    @ObservedObject var stopsStore: StopsStore

    @State var searchText = ""
    @State var selectedTab = 0

    var body: some View {
        NavigationView {
            VStack {
                UIKitSearchBar(text: $searchText)
                    .edgesIgnoringSafeArea(.bottom)
                if selectedTab == 0 {
                    linesList
                } else if selectedTab == 1 {
                   stopsList
                }
            }
            .navigationBarTitle("Buscar", displayMode: .large)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    toolBarPicker
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            self.linesStore.fetch()
            self.stopsStore.fetch()
        }
    }
}

// MARK: COMPONENTS
extension SearchView {
    private var linesList: some View {
        SkeletonList(with: linesStore.lines.filter {
            self.searchText.isEmpty ? true : $0.friendlyName.contains(self.searchText)
        }, quantity: 20) { loading, line in
            if let _line = line {
                NavigationLink(destination: LineDetailsView(line: _line.line)) {
                    HStack {
                        Image(systemName: LineHelper().getImage(line: _line.line))
                            .imageScale(.large)
                            .padding(.trailing)
                            .foregroundColor(Color(LineHelper().getColor(line: _line.line, scheme: colorScheme)))
                        VStack(alignment: .leading) {
                            Text("Línea: \(_line.line)").bold()
                            Text(_line.name).lineLimit(1)
                        }
                    }
                }
            } else {
                Spacer()
                    .skeleton(with: loading)
                    .shape(type: .rectangle)
                    .appearance(type: .solid(color: .gray))
                    .multiline(lines: 2, scales: [1: 0.5])
                    .animation(type: .pulse())
            }
        }
        .listStyle(InsetListStyle())
        .edgesIgnoringSafeArea(.top)
        .gesture(DragGesture().onChanged { _ in
            UIApplication.shared.endEditing()
        })
    }

    private var stopsList: some View {
        SkeletonList(with: stopsStore.stops.filter {
            self.searchText.isEmpty ? true : $0.friendlyName.contains(self.searchText)
        }, quantity: 20) { loading, stop in
            if let _stop = stop {
                NavigationLink(destination: StopDetailsView(stop: _stop.code)) {
                    HStack {
                        Image(systemSymbol: .grid)
                            .imageScale(.large)
                            .padding(.trailing)
                            .foregroundColor(Color.accentColor)
                        VStack(alignment: .leading) {
                            Text("Parada: \(_stop.code)").bold()
                            Text(_stop.name).lineLimit(1)
                        }
                    }
                }
            } else {
                Spacer()
                    .skeleton(with: loading)
                    .shape(type: .rectangle)
                    .appearance(type: .solid(color: .gray))
                    .multiline(lines: 2, scales: [1: 0.5])
                    .animation(type: .pulse())
            }
        }
        .listStyle(InsetListStyle())
        .edgesIgnoringSafeArea(.top)
        .gesture(DragGesture().onChanged { _ in
            UIApplication.shared.endEditing()
        })
    }

    private var toolBarPicker: some View {
        Picker(selection: $selectedTab, label: Text("Línea/Parada")) {
            ForEach(0..<Constants.SearchTabs.names.count) { index in
                Text(Constants.SearchTabs.names[index])
            }
        }.pickerStyle(SegmentedPickerStyle())
    }
}

// MARK: PREVIEW
#if DEBUG
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        let linesStore = LinesStore()
        let stopsStore = StopsStore()

        SearchView(linesStore: linesStore, stopsStore: stopsStore)
            .onAppear {
                linesStore.fetch()
                stopsStore.fetch()
            }
    }
}
#endif
