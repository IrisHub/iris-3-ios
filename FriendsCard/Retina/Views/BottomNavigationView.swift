//
//  BottomNavigationView.swift
//  FriendsCard
//
//  Created by Shalin on 9/9/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI

struct BottomNavigationView: View {
    var title: String
    var action: () -> Void = {}

    var body: some View {
        Group {
            ZStack {
                Rectangle()
                .foregroundColor(Color.rBlack200)
                .frame(width: UIScreen.screenWidth, height: 100)
                
                HStack {
                    retinaButton(text: title, style: .outlineOnly, color: .rPink, action: { DispatchQueue.main.async { self.action() }}).frame(width: UIScreen.screenWidth-48, height: 36, alignment: .trailing)
                }
            }.padding(.bottom, DeviceUtility.isIphoneXType ? UIApplication.bottomInset : 0)
        }
    }
}

struct BottomNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavigationView(title: "Next")
    }
}
