//
//  LineDetailsView.swift
//  BusVal
//
//  Created by Pablo on 04/03/2021.
//

import Alamofire
import MapKit
import SkeletonUI
import SwiftUI
import SWXMLHash

// MARK: - LineDetailsView

struct LineDetailsView: View {
    var line: String

    @ObservedObject var lineDetailsStore = LineDetailsStore()
    @ObservedObject var lineScheduleStore = LineScheduleStore()

    @State var selectedTab = 0
    @State var showScheduleSheet = false
    @State var showMapSheet = false

    var body: some View {
        VStack {
            picker
            lineDetailsList
        }
        .onAppear {
            self.lineDetailsStore.fetch(line: line)
            self.lineScheduleStore.fetch(line: line)
            registerScreen(view: "LineDetailsView")
        }
        .navigationBarTitle("Línea \(line)")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                scheduleSheetToolbarButton
                mapSheetToolbarButton
            }
        }
    }
}

// MARK: Components

extension LineDetailsView {
    private var picker: some View {
        Picker(selection: $selectedTab, label: Text("Ida/Vuelta")) {
            if self.lineDetailsStore.lineReturnDetails.isEmpty {
                Text("Trayecto").disabled(true)
            } else {
                ForEach(0 ..< Constants.LineDetailsTabs.names.count, id: \.self) { index in
                    Text(Constants.LineDetailsTabs.names[index])
                }
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding([.trailing, .leading])
        .edgesIgnoringSafeArea(.bottom)
    }

    private var scheduleSheet: some View {
        NavigationView {
            ScrollView {
                CornerCardView(title: "LABORABLES", description: lineScheduleStore.lineSchedule.weekdays)
                CornerCardView(title: "SÁBADOS", description: lineScheduleStore.lineSchedule.saturdays)
                CornerCardView(title: "FESTIVOS", description: lineScheduleStore.lineSchedule.festive)
                lineScheduleStore.lineSchedule.note.map { CornerCardView(title: "NOTAS", description: $0)
                }
            }
            .navigationBarTitle("Horarios", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(
                        action: { self.showScheduleSheet = false },
                        label: { Text("OK") }
                    )
                }
            }
        }
    }

    private var mapSheet: some View {
        NavigationView {
            let region = MKCoordinateRegion(
                center: Constants.Location.start,
                span: Constants.Location.span
            )
            Map(
                coordinateRegion: .constant(region),
                showsUserLocation: false,
                userTrackingMode: .constant(.none),
                annotationItems: lineDetailsStore.checkpoints
            ) { item in
                MapAnnotation(coordinate: item.coordinate) {
                    MapAnnotationView(code: item.stopCode!)
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarTitle("Paradas", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(
                        action: { self.showMapSheet = false },
                        label: { Text("OK") }
                    )
                }
            }
        }
    }

    private var lineDetailsList: some View {
        SkeletonList(
            with: LineHelper().getDetails(
                tab: self.selectedTab,
                store: self.lineDetailsStore
            ),
            quantity: 20
        ) { loading, lineDetails in
            if let _lineDetails = lineDetails {
                NavigationLink(destination: StopDetailsView(stop: _lineDetails.code)) {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemSymbol: .grid)
                                .padding(.trailing)
                                .foregroundColor(.accentColor)
                            Text("Parada \(_lineDetails.code)")
                                .bold()
                                .multilineTextAlignment(.leading)
                        }
                        HStack {
                            Image(systemSymbol: .safariFill)
                                .foregroundColor(.accentColor)
                                .padding(.trailing)
                            Text(_lineDetails.stop).multilineTextAlignment(.leading)
                        }
                    }
                    .padding([.top, .bottom])
                    .buttonStyle(PlainButtonStyle())
                }
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

    private var scheduleSheetToolbarButton: some View {
        Button {
            self.showScheduleSheet = true
        } label: {
            Image(systemSymbol: .calendar)
        }
        .accessibility(identifier: "scheduleButton")
        .sheet(isPresented: $showScheduleSheet) {
            scheduleSheet
        }
    }

    private var mapSheetToolbarButton: some View {
        Button {
            self.showMapSheet = true
        } label: {
            Image(systemSymbol: .map)
        }
        .accessibility(identifier: "mapButton")
        .sheet(isPresented: $showMapSheet) {
            mapSheet
        }
    }
}

// MARK: - LineDetailsView_Previews

#if DEBUG
    struct LineDetailsView_Previews: PreviewProvider {
        static let line = "1"

        static var previews: some View {
            NavigationView {
                LineDetailsView(line: line)
            }
        }
    }
#endif
