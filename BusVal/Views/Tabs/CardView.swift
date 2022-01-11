//
//  CardView.swift
//  App
//
//  Created by Pablo Espinel on 2/1/22.
//

import SkeletonUI
import SwiftUI

// MARK: VIEW
struct CardView: View {
    @AppStorage("cardID") var cardID = ""

    @ObservedObject var cardDetailsStore: CardDetailsStore

    @Environment(\.colorScheme) var colorScheme

    @State var showAddCardSheet = false
    @State var inputText = ""
    @State var loading = false
    @State var showCardErrorBanner = false
    @State var errorCardBanner: BannerModifier.BannerData = BannerModifier.BannerData(
        title: "Tarjeta inválida", detail: "Error al guardar la tarjeta", type: .error
    )

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                if cardID.isEmpty {
                    emptyCardRow
                    addCardButton
                } else {
                    balanceRow
                    movementsList
                }
            }
            .navigationBarTitle("Tarjeta")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.cardDetailsStore.clean()
                        self.cardDetailsStore.fetch(card: cardID)
                    } label: {
                        Image(systemSymbol: .arrowClockwise)
                    }.disabled(cardID.isEmpty)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            if !cardID.isEmpty {
                cardDetailsStore.fetch(card: cardID)
            }
        }
    }
}

// MARK: COMPONENTS
extension CardView {
    private var emptyCardRow: some View {
        HStack {
            Spacer()
            Text("Todavía no has añadido ninguna tarjeta")
                .padding()
            Spacer()
        }
    }

    private var addCardButton: some View {
        HStack {
            Spacer()
            Button {
                self.showAddCardSheet = true
            } label: {
                Text("Añadir tarjeta")
                Image(systemSymbol: .creditcard)
                    .font(.title2)
            }
            .sheet(isPresented: $showAddCardSheet) {
                addCardSheet
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.accentColor)
            .cornerRadius(10)
            Spacer()
        }
    }

    private var movementsList: some View {
        SkeletonList(with: cardDetailsStore.cardMovements, quantity: 10) { loading, movement in
            VStack(alignment: .leading) {
                HStack {
                    VStack {
                        Image(systemSymbol: movement?.type == "7" ? .arrowDown : .arrowUp)
                            .font(.title)
                            .foregroundColor(movement?.type == "7" ? .red : .green)
                    }
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemSymbol: .purchased)
                            Text("Importe:")
                                .bold()
                            Text(movement?.ammount ?? "")
                        }
                        HStack {
                            Image(systemSymbol: .eurosignSquareFill)
                            Text("Saldo restante:")
                                .bold()
                            Text(movement?.balance ?? "")
                        }
                        HStack {
                            Image(systemSymbol: .calendar)
                            Text("Fecha:")
                                .bold()
                            Text(movement?.date ?? "")
                        }
                    }
                }
            }
            .skeleton(with: loading)
            .shape(type: .rectangle)
            .appearance(type: .solid(color: .gray))
            .multiline(lines: 3, scales: [1: 0.5])
            .animation(type: .pulse())
        }.listStyle(InsetListStyle())
    }

    private var balanceRow: some View {
        HStack {
            Text("Movimientos")
                .bold()
                .font(.title2)
            Spacer()
            Text("Saldo: ")
                .bold()
                .font(.title2)
            Text(cardDetailsStore.cardBalance.balance)
                .bold()
                .font(.title2)
                .padding(5)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke()
                        .frame(minWidth: 20)
                )
            Image(systemSymbol: .eurosignSquareFill)
                .renderingMode(.original)
                .foregroundColor(.accentColor)
                .font(.title2)
        }.padding()
    }

    private var addCardSheet: some View {
        NavigationView {
            VStack {
                if self.cardDetailsStore.loading {
                    ProgressView()
                        .scaleEffect(2, anchor: .center)
                        .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                } else {
                    Form {
                        TextField("Número de tarjeta de auvasa", text: $inputText)
                            .foregroundColor(colorScheme == .light ? .black : .white)
                            .keyboardType(.decimalPad)
                            .padding()
                    }
                    Spacer()
                    Text("GUARDAR")
                        .font(.headline)
                        .frame(height: 55)
                        .frame(width: UIScreen.main.bounds.width - 20)
                        .foregroundColor(.white)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                        .animation(nil, value: 0)
                        .padding(.bottom)
                        .onTapGesture {
                            checkInputCard()
                        }
                }
            }.navigationTitle("Añadir tarjeta")
        }.banner(data: self.$errorCardBanner, show: self.$showCardErrorBanner)
    }
}

// MARK: METHODS
extension CardView {
    private func checkInputCard() {
        if inputText.isEmpty { return }
        // Wait for async method fetch
        DispatchQueue.main.async {
            self.cardDetailsStore.loading = true
            Wrapper.getCardDetails(inputText) { cardDetailsReponse in
                switch cardDetailsReponse {
                case let .success(balance, movements):
                    self.cardDetailsStore.cardBalance = balance
                    self.cardDetailsStore.cardMovements = movements
                    self.cardDetailsStore.loading = false
                    cardID = inputText
                    self.showAddCardSheet = false
                case .failure(let error):
                    self.cardDetailsStore.error = error
                    self.cardDetailsStore.loading = false
                    self.showCardErrorBanner = true
                }
            }
        }
    }
}

// MARK: PREVIEW
struct BusCardView_Previews: PreviewProvider {
    static var previews: some View {
        let cardDetailsStore = CardDetailsStore()
        let cardID = "1100464058"

        CardView(cardDetailsStore: cardDetailsStore).onAppear {
            if !cardID.isEmpty {
                cardDetailsStore.fetch(card: cardID)
            }
        }
    }
}
