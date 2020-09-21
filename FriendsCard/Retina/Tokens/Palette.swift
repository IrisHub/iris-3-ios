//
//  Palette.swift
//  Iris
//
//  Created by Shalin on 7/16/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI

extension Color {
    
    // BLACK
    static let rBlack500 = Color("r-black-500")
    static let rBlack400 = Color("r-black-400")
    static let rBlack300 = Color("r-black-300")
    static let rBlack200 = Color("r-black-200")
    static let rBlack100 = Color("r-black-100")
    
    // GRAY
    static let rGrey100 = Color("r-grey-100")
    
    // WHITE
    static let rWhite = Color("r-white")
    
    // RED
    static let rRed = Color("r-red")
    
    // PINK
    static let rPink = Color("r-pink")
    
    // PURPLE
    static let rPurple = Color("r-purple")
    
    // Green
    static let rGreen = Color("r-green")

}

struct Color_Previews: PreviewProvider {

    static var previews: some View {
        VStack(alignment: .center, spacing: 10) {
            HStack{
                Rectangle().size(CGSize(width: 50, height: 50))
                    .foregroundColor(.rBlack500)
                Rectangle().size(CGSize(width: 50, height: 50))
                    .foregroundColor(.rBlack400)
                Rectangle().size(CGSize(width: 50, height: 50))
                    .foregroundColor(.rBlack300)
                Rectangle().size(CGSize(width: 50, height: 50))
                .foregroundColor(.rBlack200)
                Rectangle().size(CGSize(width: 50, height: 50))
                .foregroundColor(.rBlack100)
                Rectangle().size(CGSize(width: 50, height: 50))
                .foregroundColor(.rGrey100)
                Rectangle().size(CGSize(width: 50, height: 50))
                .foregroundColor(.rRed)
                Rectangle().size(CGSize(width: 50, height: 50))
                .foregroundColor(.rGreen)
            }
        }
    .padding()
    }
}
