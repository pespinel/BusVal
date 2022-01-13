//
//  LinesView.swift
//  BusVal
//
//  Created by Pablo on 29/02/2021.
//

import Firebase
import SkeletonUI
import SwiftUI
import SWXMLHash

// MARK: - LinesView

struct LinesView: View {
    // MARK: Internal

    @Environment(\.colorScheme) var colorScheme

    @ObservedObject var linesStore: LinesStore

    var body: some View {
        NavigationView {
            VStack {
                picker
                Spacer()
                if self.linesStore.error == nil {
                    linesList
                } else {
                    Text("Error al obtener las líneas")
                }
            }.navigationBarTitle("Líneas", displayMode: .large)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            self.linesStore.fetch()
            registerScreen(view: "LinesView")
        }
    }

    // MARK: Private

    @State private var selectedSegment = 0
    @State private var selectedIndex: Int = 0
}

// MARK: Components

extension LinesView {
    private var linesList: some View {
        SkeletonList(
            with: self.linesStore.lines.filter {
                $0.type == Constants.Lines.Segments.names[selectedSegment]
            },
            quantity: 20
        ) { loading, line in
            if let _line = line {
                NavigationLink(destination: LineDetailsView(line: _line.line)) {
                    HStack {
                        Image(systemName: LineHelper().getImage(line: _line.line))
                            .imageScale(.large)
                            .padding(.trailing)
                            .foregroundColor(Color(LineHelper().getColor(line: _line.line, scheme: colorScheme)))
                        VStack(alignment: .leading) {
                            Text("Línea \(_line.line)").bold()
                            Text(_line.name).lineLimit(1)
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
        }.listStyle(PlainListStyle())
    }

    private var picker: some View {
        Picker(selection: $selectedSegment, label: Text("Tipo de línea")) {
            ForEach(0 ..< Constants.Lines.Segments.images.count) { index in
                Image(systemName: Constants.Lines.Segments.images[index])
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding([.leading, .trailing])
    }
}

// MARK: - LinesView_Previews

#if DEBUG
    struct LinesView_Previews: PreviewProvider {
        static var previews: some View {
            let linesStore = LinesStore()

            LinesView(linesStore: linesStore)
                .onAppear {
                    linesStore.fetch()
                }
        }
    }
#endif
