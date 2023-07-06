//
//  DeveloperSettingsView.swift
//  BusVal
//
//  Created by Pablo on 30/12/21.
//

import Firebase
import SwiftUI

// MARK: - DeveloperSettingsView

struct DeveloperSettingsView: View {
    @AppStorage("firstRun")
    var firstRun = false

    @AppStorage("cardID")
    var cardID = ""

    @Environment(\.managedObjectContext)
    var context

    @Environment(\.dismiss)
    var dismiss

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
            .onAppear {
                registerScreen(view: "DeveloperSettingsView")
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

// MARK: Components

extension DeveloperSettingsView {
    private var developerList: some View {
        List {
            Section(header: Text("App Storage")) {
                cleanAllRow
                onboardingRow
                cleanCardRow
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

    private var cleanAllRow: some View {
        HStack {
            Text("Clean all")
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

    private var onboardingRow: some View {
        HStack {
            Text("First run?")
                .font(.body)
                .padding()
            Spacer()
            Toggle(isOn: $firstRun) {}.accessibility(identifier: "onboardingToggle")
        }
    }

    private var cleanCardRow: some View {
        HStack {
            Text("Clean card storage")
                .font(.body)
                .padding()
            Spacer()
            Button {
                UserDefaults.standard.removeObject(forKey: "cardID")
            } label: {
                Image(systemSymbol: .trashFill)
                    .font(.title2)
                    .padding()
            }
        }.accessibility(identifier: "cleanCardStorage")
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
                    do {
                        for object in self.result {
                            self.context.delete(object)
                        }
                        try context.save()
                    } catch {
                        print("Error cleaning core data")
                    }
                }
            } label: {
                Image(systemSymbol: .trashFill)
                    .font(.title2)
                    .padding()
            }.accessibility(identifier: "cleanCoreData")
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

// MARK: Methods

extension DeveloperSettingsView {
    init() {
        let predicate = NSPredicate(value: true)
        _result = FetchRequest(
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

// MARK: - DeveloperSettingsView_Previews

struct DeveloperSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        DeveloperSettingsView()
    }
}
