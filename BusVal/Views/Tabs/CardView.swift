//
//  CardView.swift
//  App
//
//  Created by Pablo Espinel on 2/1/22.
//

import SkeletonUI
import SwiftUI

// MARK: - CardView

struct CardView: View {
    @AppStorage("cardID")
    var cardID = ""

    @ObservedObject var cardDetailsStore: CardDetailsStore

    @Environment(\.colorScheme)
    var colorScheme

    @State var showAddCardSheet = false
    @State var inputText = ""
    @State var loading = false
    @State var showCardErrorBanner = false
    @State var errorCardBanner: BannerModifier.BannerData = .init(
        title: "Tarjeta inválida", detail: "Error al guardar la tarjeta", type: .error
    )

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                if cardID.isEmpty {
                    Spacer()
                    emptyCardRow
                        .sheet(isPresented: $showAddCardSheet) {
                            addCardSheet
                        }
                    Spacer()
                } else {
                    balanceRow
                    movementsList
                }
            }
            .navigationBarTitle("Tarjeta")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        cardDetailsStore.clean()
                        cardDetailsStore.fetch(card: cardID)
                    } label: {
                        Image(systemSymbol: .arrowClockwise).accessibility(identifier: "refreshCardView")
                    }.disabled(cardID.isEmpty)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            if !cardID.isEmpty {
                cardDetailsStore.fetch(card: cardID)
            }
            registerScreen(view: "CardView")
        }
    }
}

// MARK: Components

extension CardView {
    private var emptyCardRow: some View {
        VStack {
            HStack {
                Spacer()
                Text("Todavía no has añadido ninguna tarjeta")
                    .padding()
                Spacer()
            }
            HStack {
                Spacer()
                Button {
                    self.showAddCardSheet = true
                } label: {
                    Text("Añadir tarjeta")
                    Image(systemSymbol: .creditcard)
                        .font(.title2)
                }
                .accessibility(identifier: "addCardButton")
                .padding()
                .foregroundColor(.white)
                .background(Color.accentColor)
                .cornerRadius(10)
                Spacer()
            }
        }
    }

    private var movementsList: some View {
        SkeletonList(with: cardDetailsStore.cardMovements, quantity: 10) { loading, movement in
            VStack(alignment: .leading) {
                HStack {
                    Image(systemSymbol: movement?.type == "7" ? .arrowDown : .arrowUp)
                        .padding(.trailing)
                        .imageScale(.large)
                        .foregroundColor(movement?.type == "7" ? .red : .green)
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
            .accessibility(identifier: "cardMovementsList")
            .padding([.top, .bottom])
            .skeleton(with: loading)
            .shape(type: .rectangle)
            .appearance(type: .solid(color: .gray))
            .multiline(lines: 3, scales: [1: 0.5])
            .animation(type: .pulse())
        }.listStyle(PlainListStyle())
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
                            .accessibility(identifier: "addCardTextField")
                            .modifier(TextFieldClearButton(text: $inputText))
                            .foregroundColor(colorScheme == .light ? .black : .white)
                            .keyboardType(.decimalPad)
                            .padding()
                    }
                    Spacer()
                    Text("GUARDAR")
                        .accessibility(identifier: "addCardSaveButton")
                        .disabled(self.inputText.isEmpty)
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

// MARK: Methods

extension CardView {
    private func checkInputCard() {
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
                case let .failure(error):
                    self.cardDetailsStore.error = error
                    self.cardDetailsStore.loading = false
                    self.showCardErrorBanner = true
                }
            }
        }
    }
}

// MARK: - CardView_Previews

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let cardDetailsStore = CardDetailsStore()

        CardView(cardDetailsStore: cardDetailsStore)
    }
}
