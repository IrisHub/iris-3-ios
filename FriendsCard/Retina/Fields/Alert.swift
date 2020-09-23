//
//  AlertView.swift
//  FriendsCard
//
//  Created by Shalin on 9/21/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI

struct TextFieldAlert<Presenting>: View where Presenting: View {

    @Binding var isShowing: Bool
    @Binding var text: String
    let presenting: Presenting
    let title: String

    var body: some View {
        GeometryReader { (deviceSize: GeometryProxy) in
            ZStack {
                self.presenting
                    .disabled(isShowing)
            
                ZStack {
                    Color.rBlack500.edgesIgnoringSafeArea(.all)
                    .opacity(0.8)
                    .blur(radius: 6)
                    
                    VStack(alignment: .leading) {
                        Text(self.title).foregroundColor(.rWhite).retinaTypography(.p5_main).padding(.bottom, Space.rSpaceThree)

                        RetinaTextField("#3a, #4b-e, #6", input: self.$text, onCommit: {print("party")})
                            .keyboardType(.default)

                        HStack {
                            Button(action: {
                                withAnimation {
                                    self.isShowing.toggle()
                                    self.hideKeyboard()
                                }
                            }) {
                                Text("CANCEL").foregroundColor(.rWhite).retinaTypography(.p5_main)
                            }.padding([.top], Space.rSpaceTwo)
                            Spacer()
                            Button(action: {
                                withAnimation {
                                    self.isShowing.toggle()
                                    self.hideKeyboard()
                                }
                            }) {
                                Text("SHARE").foregroundColor(.rPurple).retinaTypography(.h5_main)
                            }.padding([.top], Space.rSpaceTwo)
                        }
                    }
                    .padding(Space.rSpaceThree)
                    .background(Color.rBlack400)
                    .frame(
                        width: deviceSize.size.width*0.9,
                        height: deviceSize.size.height*0.9
                    )
                    .cornerRadius(CornerRadius.rCornerRadius)
                }
                .opacity(self.isShowing ? 1 : 0)
            }
        }
    }
}

extension View {

    func textFieldAlert(isShowing: Binding<Bool>,
                        text: Binding<String>,
                        title: String) -> some View {
        TextFieldAlert(isShowing: isShowing,
                       text: text,
                       presenting: self,
                       title: title)
    }

}
