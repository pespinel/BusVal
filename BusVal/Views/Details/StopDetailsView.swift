//
//  StopDetailsView.swift
//  BusVal
//
//  Created by Pablo on 07/03/2021.
//

import Alamofire
import MapKit
import SkeletonUI
import SwiftUI
import SWXMLHash
import WidgetKit

// MARK: VIEWS
struct StopDetailsView: View {
    var stop: String

    @Environment(\.managedObjectContext) var context

    @State var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var showBanner = false
    @State var bannerData: BannerModifier.BannerData = BannerModifier.BannerData(title: "", detail: "", type: .success)
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
                    detailsList.frame(
                        width: UIScreen.main.bounds.width,
                        alignment: .center
                    )
                }
            }
        }
        .banner(data: self.$bannerData, show: self.$showBanner)
        .navigationBarTitle("Parada \(stop)", displayMode: .inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                favoriteToolbarButton
                mapToolbarButton
            }
        }
        .onAppear {
            self.stopDetailsStore.fetch(stop: stop)
            self.stopTimesStore.fetch(stop: stop)
            self.timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
        }
        .onDisappear {
            self.timer.upstream.connect().cancel()
        }
    }
}

private struct StopTimeView: View {
    var stopTime: String
    var timeColor: Color

    init(stopTime: Int) {
        self.stopTime = String(stopTime)
        if stopTime >= 5 {
            self.timeColor = Color.green
        } else if stopTime < 5 && stopTime > 1 {
            self.timeColor = Color.orange
        } else {
            self.timeColor = Color.red
        }
    }

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

// MARK: COMPONENTS
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

    // swiftlint:disable number_separator
    private var stopMap: some View {
        VStack {
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: self.stopDetailsStore.checkpoints.first?.coordinate.latitude ?? 41.65518,
                    longitude: self.stopDetailsStore.checkpoints.first?.coordinate.longitude ?? -4.72372
                ),
                span: Constants.Location.zoomedSpan
            )
            Map(coordinateRegion: .constant(region), showsUserLocation: false,
                userTrackingMode: .constant(.none), annotationItems: self.stopDetailsStore.checkpoints) { item in
                    MapMarker(coordinate: item.coordinate)
            }.frame(
                minWidth: UIScreen.main.bounds.width,
                maxWidth: UIScreen.main.bounds.width,
                minHeight: UIScreen.main.bounds.width / 2,
                maxHeight: UIScreen.main.bounds.width / 2,
                alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/
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
                WidgetCenter.shared.reloadAllTimelines()
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

// MARK: METHODS
extension StopDetailsView {
    init(stop: String) {
        self.stop = stop
        var predicate: NSPredicate?
        predicate = NSPredicate(format: "code == %@", stop)
        self._result = FetchRequest(
            entity: FavoriteStop.entity(),
            sortDescriptors: [],
            predicate: predicate
        )
    }

    private func toggleFavorite() {
        if self.result.isEmpty {
            let newFavoriteStop = FavoriteStop(context: self.context)
            newFavoriteStop.id = UUID()
            newFavoriteStop.code = self.stopDetailsStore.stopDetails.code.description
            newFavoriteStop.name = self.stopDetailsStore.stopDetails.name.description
            do {
                try self.context.save()
                self.bannerData.title = "Guardada en favoritos"
                self.bannerData.detail = "Puedes ver tus paradas favoritas desde la pestaña 'Favoritos'"
                self.bannerData.type = .success
                self.showBanner = true
            } catch {
                self.bannerData.title = "Error"
                self.bannerData.detail = "No se ha podido guardar la parada en favoritos"
                self.bannerData.type = .warning
                self.showBanner = true
            }
        } else {
            self.bannerData.title = "Eliminada de favoritos"
            self.bannerData.detail = "Puedes añadir otras paradas a favoritos desde la vista de detalles de parada"
            self.bannerData.type = .error
            self.showBanner = true
            self.context.delete(self.result[0])
        }
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

// MARK: PREVIEW
#if DEBUG
struct StopDetailsView_Previews: PreviewProvider {
    static let stop = "1181"

    static var previews: some View {
        return
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
