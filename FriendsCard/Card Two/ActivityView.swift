//
//  ActivityView.swift
//  FriendsCard
//
//  Created by Shalin on 8/29/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI

struct ActivityView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                HStack {
                    Text("Friend Activity")
                        .retinaTypography(.h4_secondary)
                        .foregroundColor(.white)
                    .padding(.leading, 24)
                    Spacer()
                    
                    retinaIconButton(image: (Image(systemName: "xmark")), action: {
                        withAnimation {

                        }
                    }).padding([.leading, .trailing], 24)
                }
            }.padding([.top], UIApplication.topInset*2)
            
            Text("You’re doing a great job so far, keep it up!").retinaTypography(.h5_main, color: .rWhite).padding([.leading, .top], 24)
            
            ScrollView {
                HStack {
                    Spacer()
                    LeaderCell(title: "Sam Gorman", subtitle: "3/3")
                    Spacer()
                }
            }.padding([.top], 24)
            Spacer()
        }
        .background(Color.rBlack400)
        .edgesIgnoringSafeArea(.all)
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
