//
//  Banner.swift
//  Iris
//
//  Created by Shalin on 7/21/20.
//  Copyright © 2020 Shalin. All rights reserved.
//


import SwiftUI

struct BannerModifier: ViewModifier {
    
    struct BannerData {
        var title:String
        var detail:String
        var type: BannerType
    }
    
    enum BannerType {
        case Info
        case Warning
        case Success
        case Error
        
        var tintColor: Color {
            switch self {
            case .Info:
                return Color(.displayP3, red: 45/255, green: 57/255, blue: 52/255)
            case .Success:
                return Color.green
            case .Warning:
                return Color.yellow
            case .Error:
                return Color.red
            }
        }
    }
    
    // Members for the Banner
    @Binding var data:BannerData
    @Binding var show:Bool
    
    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
            if show {
                VStack(alignment: .leading, spacing: 2) {
                    Text(data.title).retinaTypography(.h4_main)
                    HStack {
                        Image(systemName: "info.circle.fill").foregroundColor(.rPink)
                        Text(data.detail).retinaTypography(.p6_main)
                        .foregroundColor(Color.rWhite)
                        Spacer()
                    }
                    .padding(.top, 12)
                }
                .padding(.leading, 24)
                .frame(width: UIScreen.screenWidth, height: 120)
                .foregroundColor(Color.rWhite)
                .background(Color.rBlack100)
                .edgesIgnoringSafeArea(.all)
                    
                .animation(.easeInOut)
                    .transition(AnyTransition.move(edge: .top).combined(with: .opacity).combined(with: .offset(
                        .init(width: 0, height: 0)
                    )))
                .onTapGesture {
                    withAnimation {
                        self.show = false
                    }
                }.onAppear(perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            self.show = false
                        }
                    }
                })
            }
        }.edgesIgnoringSafeArea(.all)
    }

}

extension View {
    func banner(data: Binding<BannerModifier.BannerData>, show: Binding<Bool>) -> some View {
        self.modifier(BannerModifier(data: data, show: show))
    }
}
