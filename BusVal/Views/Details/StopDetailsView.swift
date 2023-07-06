//
//  StopDetailsView.swift
//  BusVal
//
//  Created by Pablo on 07/03/2021.
//

import Alamofire
import CoreData
import MapKit
import SkeletonUI
import SwiftUI
import SWXMLHash
import WidgetKit

// MARK: - StopDetailsView

struct StopDetailsView: View {
    // MARK: Lifecycle

    init(stop: String) {
        self.stop = stop
        _result = FetchRequest<FavoriteStop>(
            entity: FavoriteStop.entity(),
            sortDescriptors: [],
            predicate: NSPredicate(format: "code == %@", stop)
        )
    }

    // MARK: Internal

    var stop: String

    @Environment(\.managedObjectContext)
    var context

    @State var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var showBanner = false
    @State var bannerData: BannerModifier.BannerData = .init(title: "", detail: "", type: .success)
    @State var progress: Float = 0.0

    @ObservedObject var stopDetailsStore = StopDetailsStore()
    @ObservedObject var stopTimesStore = StopTimesStore()

    @FetchRequest var result: FetchedResults<FavoriteStop>

    var body: some View {
        VStack {
            progressBar
            ScrollView(.vertical) {
                stopMap
                if stopTimesStore.error != nil {
                    Text("Error consultando los tiempos de la parada")
                } else {
                    detailsList
                }
            }
        }
        .banner(data: $bannerData, show: $showBanner)
        .navigationBarTitle("Parada \(stop)", displayMode: .inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                favoriteToolbarButton
                mapToolbarButton
            }
        }
        .onAppear {
            stopDetailsStore.fetch(stop: stop)
            stopTimesStore.fetch(stop: stop)
            timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
            registerScreen(view: "StopDetailsView[\(stop)]")
        }
        .onDisappear {
            timer.upstream.connect().cancel()
        }
    }
}

// MARK: - StopTimeView

private struct StopTimeView: View {
    // MARK: Lifecycle

    init(stopTime: Int) {
        self.stopTime = String(stopTime)
        if stopTime >= 5 {
            timeColor = .green
        } else if stopTime < 5, stopTime > 1 {
            timeColor = .orange
        } else {
            timeColor = .red
        }
    }

    // MARK: Internal

    var stopTime: String
    var timeColor: Color

    var body: some View {
        ZStack {
            Image(systemName: "\(stopTime).square.fill")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(timeColor)
                .frame(width: 35, height: 35)
        }
    }
}

// MARK: Components

extension StopDetailsView {
    private var progressBar: some View {
        ProgressView(value: progress, total: 30)
            .onReceive(timer) { _ in
                if progress < 29.9 {
                    progress += 0.1
                } else {
                    self.stopTimesStore.fetch(stop: stop, force: true)
                    progress = 0
                }
            }
    }

    private var stopMap: some View {
        VStack {
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: self.stopDetailsStore.checkpoints.first?.coordinate.latitude ?? 41.65518,
                    longitude: self.stopDetailsStore.checkpoints.first?.coordinate.longitude ?? -4.72372
                ),
                span: Constants.Location.zoomedSpan
            )
            Map(
                coordinateRegion: .constant(region),
                showsUserLocation: false,
                userTrackingMode: .constant(.none),
                annotationItems: self.stopDetailsStore.checkpoints
            ) { item in
                MapMarker(coordinate: item.coordinate)
            }.frame(
                minWidth: UIScreen.main.bounds.width,
                maxWidth: UIScreen.main.bounds.width,
                minHeight: UIScreen.main.bounds.height / 3,
                maxHeight: UIScreen.main.bounds.height / 3,
                alignment: Alignment.center
            )
        }
    }

    private var detailsList: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text("TIEMPOS:")
                    .font(.headline)
                    .multilineTextAlignment(.trailing)
                Spacer()
            }.padding()
            if !stopTimesStore.stopTimes.isEmpty {
                ForEach(self.stopTimesStore.stopTimes, id: \.self) { stopTime in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Linea \(stopTime[0])")
                                .font(.system(size: 18))
                                .bold()
                            Text(stopTime[1].lowercased().capitalizingFirstLetter())
                                .font(.system(size: 18))
                        }
                        Spacer()
                        StopTimeView(stopTime: Int(stopTime[2])!)
                    }.padding([.leading, .trailing])
                    Divider()
                }
            } else {
                Text("No hay datos")
                    .padding(.leading)
            }
        }
    }

    private var favoriteToolbarButton: some View {
        Button(
            action: {
                toggleFavorite()
            },
            label: {
                Image(systemSymbol: self.result.isEmpty ? .heart : .heartFill)
                    .renderingMode(.original)
            }
        )
    }

    private var mapToolbarButton: some View {
        Button(
            action: { openInMaps() },
            label: { Image(systemSymbol: .locationCircle) }
        )
    }
}

// MARK: Methods

extension StopDetailsView {
    private func toggleFavorite() {
        if result.isEmpty {
            do {
                let newFavoriteStop = FavoriteStop(context: context)
                newFavoriteStop.stopID = UUID()
                newFavoriteStop.code = stopDetailsStore.stopDetails.code.description
                newFavoriteStop.name = stopDetailsStore.stopDetails.name.description
                try context.save()
                bannerData.title = "Guardada en favoritos"
                bannerData.detail = "Puedes ver tus paradas favoritas desde la pestaña 'Favoritos'"
                bannerData.type = .success
            } catch {
                bannerData.title = "Error"
                bannerData.detail = "No se ha podido guardar la parada en favoritos"
                bannerData.type = .warning
            }
        } else {
            do {
                context.delete(result.first!)
                try context.save()
                bannerData.title = "Eliminada de favoritos"
                bannerData.detail = "Puedes añadir otras paradas a favoritos desde la vista de detalles de parada"
                bannerData.type = .error
            } catch {
                bannerData.title = "Error"
                bannerData.detail = "No se ha podido guardar la parada en favoritos"
                bannerData.type = .warning
            }
        }
        showBanner = true
        WidgetCenter.shared.reloadAllTimelines()
    }

    private func openInMaps() {
        let coorX = stopDetailsStore.stopDetails.coordinateX
        let coorY = stopDetailsStore.stopDetails.coordinateY
        let url = URL(string: "maps://?saddr=&daddr=\(coorY),\(coorX)")
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!)
        }
    }
}

// MARK: - StopDetailsView_Previews

#if DEBUG
    struct StopDetailsView_Previews: PreviewProvider {
        static let stop = "1181"

        static var previews: some View {
            TabView {
                NavigationView {
                    StopDetailsView(stop: stop)
                        .navigationBarTitle("Parada \(stop)", displayMode: .inline)
                }.tabItem {
                    Image(systemSymbol: .listDash)
                    Text("Preview")
                }
            }
        }
    }
#endif
