//
//  ReminderView.swift
//  FriendsCard
//
//  Created by Shalin on 8/29/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI

struct ReminderView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        NavigationView {
            ZStack {
                Color.rBlack400.edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading) {
                    HStack {
                        retinaIconButton(image: (Image(systemName: "chevron.left")), action: {
                            print(";pressed!")
                            withAnimation {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }).padding(24)
                        Spacer()
                    }.padding([.top], UIApplication.topInset)

                    Group {
                        HStack {
                            Text("For this week")
                                .retinaTypography(.h4_secondary)
                                .foregroundColor(.white)
                            .padding(.leading, 24)
                            Spacer()
                            retinaIconButton(image: (Image(systemName: "chart.bar")), foregroundColor: .rPink, backgroundColor: .clear, action: {
                                withAnimation {

                                }
                            }).padding([.leading, .trailing], 24)
                        }
                    }
                    
                    ScrollView {
                        HStack {
                            Spacer()
                            ReminderCell(name: "Alex MacDonald", phoneNumber: "818-203-3202", emoji: "😆")
                            Spacer()
                        }
                    }
                    Spacer()
                }
            }
        }
        .hideNavigationBar()
    }
}

struct ReminderView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderView()
    }
}
