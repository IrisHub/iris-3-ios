//
//  Picker.swift
//  FriendsCard
//
//  Created by Shalin on 9/22/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI

struct PickerView<Presenting>: View where Presenting: View {

    @Binding var isShowing: Bool
    @Binding var commitChanges: Bool
    @Binding var picked: Int
    @Binding var options: [String]
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
                        HStack {
                            Text(self.title).foregroundColor(.rWhite).retinaTypography(.p5_main).padding([.top, .leading], Space.rSpaceThree)
                            
                            Spacer()
                            Button(action: {
                                withAnimation {
                                    self.isShowing.toggle()
                                    self.commitChanges = true
                                }
                            }) {
                                Text("DONE").foregroundColor(.rPurple).retinaTypography(.h5_main)
                            }.padding([.top, .trailing], Space.rSpaceThree)
                        }
                        Picker(self.title, selection: $picked) {
                            ForEach(Array(zip(self.options.indices, self.options)), id: \.0) { index, option in
                                Text(option).foregroundColor(.rWhite).retinaTypography(.p5_main).tag(index)
                            }
                        }.pickerStyle(WheelPickerStyle())
                        
                    }
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

    func pickerView(isShowing: Binding<Bool>,
                    commitChanges: Binding<Bool>,
                        picked: Binding<Int>,
                        title: String, options: Binding<[String]>) -> some View {
        PickerView(isShowing: isShowing,
                       commitChanges: commitChanges,
                       picked: picked,
                       options: options, presenting: self,
                       title: title)
    }

}
