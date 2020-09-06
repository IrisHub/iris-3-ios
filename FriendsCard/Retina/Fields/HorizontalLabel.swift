//
//  SwiftUIView.swift
//  Iris
//
//  Created by Shalin on 7/21/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI

struct HorizontalLabel: View {
    var text: String
    
    var body: some View {
        Text(text)
        .rotationEffect(.radians(-.pi/2))
        .retinaTypography(.h6_main)
        .foregroundColor(.rWhite)
    }
}

struct HorizontalLabel_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalLabel(text: "1 of 4")
    }
}
