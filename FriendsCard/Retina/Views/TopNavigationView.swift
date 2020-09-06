//
//  TopNavigationView.swift
//  Iris
//
//  Created by Shalin on 7/21/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI

struct TopNavigationView: View {
    var title : String
    var bolded: String
    var subtitle: String = ""
    var leftIconString: String
    var rightIconStrings : [String]
    var buttonCommit : ()->() = {}
    
    var body: some View {
        
        HStack(alignment: .center) {
            ZStack {
                HStack {
                    Button(action:
                        self.buttonCommit
                    ) {
                        Image(systemName: self.leftIconString)
                            .foregroundColor(Color.rGrey100)
                            .padding(.horizontal, 4)
                            .retinaTypography(.h5_main)
                    }
                    Spacer()
                }
                VStack {
                    HStack {
                        Text(bolded.isEmpty ? self.title : self.title + "").retinaTypography(.p5_main, color: .rWhite).offset(y: self.subtitle == "" ? 5: 0)
                        Text(!bolded.isEmpty ? bolded : "").retinaTypography(.h5_main, color: .rWhite).padding(-3)
                    }
                    Text(self.subtitle).retinaTypography(.p6_main, color: .rGrey100).padding(.top, self.subtitle == "" ? 0: 5)
                }
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
        .padding(.top, UIApplication.topInset)
        .background(Color.rBlack200)
        .clipped()
//        .shadow(color: Color.retinaBasic, radius: 3, x: 0, y: 0)
        .animation(.default)
    }
}

struct RightNavButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? Color.white: Color.gray)
    }
}

struct LeftNavButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? Color.white: Color.gray)
    }
}


struct TopNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        VStack() {
            
            TopNavigationView(title: "Your results for", bolded: "Chicken", subtitle: "Created for 3:20pm", leftIconString: "chevron.left", rightIconStrings: ["", ""])

            Spacer()
        }
        .edgesIgnoringSafeArea(.horizontal)
        .edgesIgnoringSafeArea(.top)
    }
}
