//
//  LoadingView.swift
//  Iris
//
//  Created by Shalin on 7/18/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack(alignment: .top) {
          Color.rBlack400.edgesIgnoringSafeArea(.all)
            VStack {
                Text("Customizing").retinaTypography(.h4_main).foregroundColor(.rWhite)
                LottieView(name: "loading").frame(width:150, height:150).padding(.top, 12)
            }.padding(.top, UIScreen.main.bounds.size.height/5)
        }
    }
}


struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
