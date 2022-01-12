//
//  OnboardingView.swift
//  BusVal
//
//  Created by Pablo on 30/12/21.
//

import SwiftUI

// MARK: VIEWS
struct OnboardingView: View {
    @AppStorage("firstRun") var firstRun = true

    @State var state = 0

    var body: some View {
        ZStack {
            TabView(selection: $state) {
                welcomeSection
                    .tag(0)
                timesSection
                    .tag(1)
                linesSection
                    .tag(2)
                mapSection
                    .tag(3)
                favoritesSection
                    .tag(4)
            }.tabViewStyle(.page)
            VStack {
                Spacer()
                bottomButton
            }
            .padding(.bottom, 50)
            .padding([.trailing, .leading], 30)
        }.onAppear {
            registerScreen(view: "OnboardingView")
        }
    }
}

struct OnboardingSectionView: View {
    var title: String
    var description: String?
    var image: String

    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .foregroundColor(.white)
            Text(title)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .overlay(
                    Capsule(style: .continuous)
                        .frame(height: 3)
                        .offset(y: 5)
                        .foregroundColor(.white),
                    alignment: .bottom
                )
            description.map {
                Text($0)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
            }
            Spacer()
            Spacer()
        }
        .multilineTextAlignment(.center)
        .padding(30)
    }
}

// MARK: COMPONENTS
extension OnboardingView {
    private var bottomButton: some View {
        Text(state == 0 ? "EMPEZAR" : state == 4 ? "ENTENDIDO" : "SIGUIENTE" )
            .font(.headline)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .foregroundColor(.black)
            .background(.white)
            .cornerRadius(10)
            .animation(nil, value: 0)
            .onTapGesture {
                nextSlide()
            }
    }

    private var welcomeSection: some View {
        OnboardingSectionView(title: "Binvenid@ a BusVal", image: "bus.doubledecker")
    }

    private var timesSection: some View {
        OnboardingSectionView(
            title: "Consulta tiempos",
            description: "Consulta los tiempos para todas las paradas de Auvasa",
            image: "timer.square"
        )
    }

    private var linesSection: some View {
        OnboardingSectionView(
            title: "Consulta líneas",
            description: "Consulta las líneas y sus recorridos",
            image: "app.connected.to.app.below.fill"
        )
    }

    private var mapSection: some View {
        OnboardingSectionView(
            title: "Mapa",
            description: "Busca entre todas las paradas en el mapa",
            image: "map.fill"
        )
    }

    private var favoritesSection: some View {
        OnboardingSectionView(
            title: "Favoritos",
            description: "Guarda paradas en favoritos para acceder rápidamente a ellas",
            image: "staroflife.fill"
        )
    }
}

// MARK: METHODS
extension OnboardingView {
    func nextSlide() {
        if state == 4 {
            firstRun = false
        }
        withAnimation(.spring()) {
            state += 1
        }
    }
}

// MARK: PREVIEW
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            RadialGradient(
                gradient: Gradient(colors: [Color.secondary, Color.accentColor]),
                center: .topLeading,
                startRadius: 128,
                endRadius: UIScreen.main.bounds.height
            ).ignoresSafeArea()
            OnboardingView()
        }
    }
}
