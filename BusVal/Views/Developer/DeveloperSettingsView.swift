//
//  DeveloperSettingsView.swift
//  BusVal
//
//  Created by Pablo on 30/12/21.
//

import Firebase
import SwiftUI

// MARK: VIEW
struct DeveloperSettingsView: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.dismiss) var dismiss

    @State var showInfo = false
    @State var showWarning = false
    @State var showError = false
    @State var showProgress = false

    @FetchRequest var result: FetchedResults<FavoriteStop>

    var body: some View {
        if showProgress {
            activityIndicator
        } else {
            NavigationView {
                developerList
            }
            .banner(
                data: .constant(BannerModifier.BannerData(
                    title: "Title",
                    detail: "Detail",
                    type: BannerModifier.BannerType.info
                )),
                show: $showInfo
            )
            .banner(
                data: .constant(BannerModifier.BannerData(
                    title: "Title",
                    detail: "Detail",
                    type: BannerModifier.BannerType.warning
                )),
                show: $showWarning
            )
            .banner(
                data: .constant(BannerModifier.BannerData(
                    title: "Title",
                    detail: "Detail",
                    type: BannerModifier.BannerType.error
                )),
                show: $showError
            )
        }
    }
}

// MARK: COMPONENTS
extension DeveloperSettingsView {
    private var developerList: some View {
        List {
            Section(header: Text("App Storage")) {
                storageRow
            }
            Section(header: Text("Banner")) {
                infoRow
                warningRow
                errorRow
            }
            Section(header: Text("Progress View")) {
                progressRow
            }
            Section(header: Text("Core data")) {
                dataRow
            }
            Section(header: Text("Firebase")) {
                crashRow
                logOutRow
            }
        }.listStyle(.automatic)
        .navigationBarTitle("Developer Settings")
        .edgesIgnoringSafeArea(.bottom)
    }

    private var activityIndicator: some View {
        ProgressView()
            .scaleEffect(2, anchor: .center)
            .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
    }

    private var storageRow: some View {
        HStack {
            Text("Clean")
                .font(.body)
                .padding()
            Spacer()
            Button {
                if let bundleID = Bundle.main.bundleIdentifier {
                    UserDefaults.standard.removePersistentDomain(forName: bundleID)
                    exit(0)
                }
            } label: {
                Image(systemSymbol: .trashFill)
                    .font(.title2)
                    .padding()
            }
        }
    }

    private var infoRow: some View {
        HStack {
            Text("Info")
                .font(.body)
                .padding()
            Spacer()
            Button {
                showInfo = true
            } label: {
                Image(systemSymbol: .infoCircleFill)
                    .font(.title2)
                    .padding()
            }
        }
    }

    private var warningRow: some View {
        HStack {
            Text("Warning")
                .font(.body)
                .padding()
            Spacer()
            Button {
                showWarning = true
            } label: {
                Image(systemSymbol: .exclamationmarkTriangleFill)
                    .font(.title2)
                    .padding()
            }
        }
    }

    private var errorRow: some View {
        HStack {
            Text("Error")
                .font(.body)
                .padding()
            Spacer()
            Button {
                showError = true
            } label: {
                Image(systemSymbol: .multiplyCircleFill)
                    .font(.title2)
                    .padding()
            }
        }
    }

    private var progressRow: some View {
        HStack {
            Text("Show for one second")
                .font(.body)
                .padding()
            Spacer()
            Button {
                showProgress = true
                trigerProgress()
            } label: {
                Image(systemSymbol: .asteriskCircleFill)
                    .font(.title2)
                    .padding()
            }
        }
    }

    private var dataRow: some View {
        HStack {
            Text("Remove all")
                .font(.body)
                .padding()
            Spacer()
            Button {
                if !self.result.isEmpty {
                    for object in self.result {
                        self.context.delete(object)
                    }
                }
            } label: {
                Image(systemSymbol: .trashFill)
                    .font(.title2)
                    .padding()
            }
        }
    }

    private var crashRow: some View {
        HStack {
            Text("Crash the app")
                .font(.body)
                .padding()
            Spacer()
            Button {
                fatalError("Developer crash test")
            } label: {
                Image(systemSymbol: .lockShieldFill)
                    .font(.title2)
                    .padding()
            }
        }
    }

    private var logOutRow: some View {
        HStack {
            Text("Log out")
                .font(.body)
                .padding()
            Spacer()
            Button {
                do {
                    try Firebase.Auth.auth().signOut()
                } catch {}
            } label: {
                Image(systemSymbol: .flameFill)
                    .font(.title2)
                    .padding()
            }
        }
    }
}

// MARK: METHODS
extension DeveloperSettingsView {
    init() {
        let predicate = NSPredicate(value: true)
        self._result = FetchRequest(
            entity: FavoriteStop.entity(),
            sortDescriptors: [],
            predicate: predicate
        )
    }

    private func trigerProgress() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            showProgress = false
        }
    }
}

// MARK: PREVIEW
struct DeveloperSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        DeveloperSettingsView()
    }
}
