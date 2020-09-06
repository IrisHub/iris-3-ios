//
//  SamsView.swift
//  FriendsCard
//
//  Created by Shalin on 9/6/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI

struct SamsView: View {
    var body: some View {
        
        VStack {
            HStack {
                retinaButton(text: "Back", action: {
                    print("Sam is a figma GOD")
                }).padding(.leading, Space.rSpaceThree)

                Text("Hello World").retinaTypography(.h3_main).foregroundColor(.rPink).padding(.leading, Space.rSpaceThree)
                
                Spacer()
                
            }.padding(.top, Space.rSpaceThree)
            Spacer()
        }
        
        
        
        
    }
}









struct SamsView_Previews: PreviewProvider {
    static var previews: some View {
        SamsView()
    }
}
