//
//  BannerModifier.swift
//  BusVal
//
//  Created by Pablo on 23/8/21.
//

import SwiftUI

// MARK: VIEW
struct BannerModifier: ViewModifier {
    @Binding var data: BannerData
    @Binding var show: Bool

    struct BannerData {
        var title: String
        var detail: String
        var type: BannerType
    }

    enum BannerType {
        case info
        case warning
        case success
        case error

        var tintColor: Color {
            switch self {
            case .info:
                return Color(red: 67 / 255, green: 154 / 255, blue: 215 / 255)
            case .success:
                return Color.green
            case .warning:
                return Color.yellow
            case .error:
                return Color.red
            }
        }
    }

    func body(content: Content) -> some View {
        ZStack {
            content
            if show {
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(data.title)
                                .bold()
                            Text(data.detail)
                                .font(Font.system(size: 15, weight: .light, design: .default))
                        }
                        Spacer()
                    }
                    .foregroundColor(Color.white)
                    .padding(12)
                    .background(data.type.tintColor)
                    .cornerRadius(8)
                    Spacer()
                }
                .padding()
                .animation(Animation.easeInOut(duration: 1.0), value: show)
                .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                .onTapGesture {
                    withAnimation {
                        self.show = false
                    }
                }.onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            self.show = false
                        }
                    }
                }
            }
        }
    }
}

// MARK: METHODS
extension View {
    func banner(data: Binding<BannerModifier.BannerData>, show: Binding<Bool>) -> some View {
        self.modifier(BannerModifier(data: data, show: show))
    }
}

// MARK: PREVIEW
#if DEBUG
struct Banner_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Info")
                .banner(
                    data: .constant(BannerModifier.BannerData(
                        title: "Title",
                        detail: "Detail",
                        type: BannerModifier.BannerType.info
                    )),
                    show: .constant(true)
                )
            Text("Warning")
                .banner(
                    data: .constant(BannerModifier.BannerData(
                        title: "Title",
                        detail: "Detail",
                        type: BannerModifier.BannerType.warning
                    )),
                    show: .constant(true)
                )
            Text("Error")
                .banner(
                    data: .constant(BannerModifier.BannerData(
                        title: "Title",
                        detail: "Detail",
                        type: BannerModifier.BannerType.error
                    )),
                    show: .constant(true)
                )
        }
    }
}
#endif
