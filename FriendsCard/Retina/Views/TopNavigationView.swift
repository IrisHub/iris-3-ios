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
    var description: String
    var backButton: Bool = false
    var backButtonCommit : () -> Void = {}
    var rightButton: Bool = false
    var rightButtonIcon: String = ""
    var rightButtonIconColor : Color = Color.rPink
    var rightButtonCommit : () -> Void = {}
    var searchBar: Bool = false
    var searchBarPlaceholder: String = "Search"
    var backgroundColor: Color = Color.clear
    @Binding var searchText: String?

    var body: some View {
        VStack(alignment: .leading) {
            if (self.backButton) {
                HStack {
                    retinaIconButton(image: (Image(systemName: "chevron.left")), action: {
                        withAnimation {
                            self.backButtonCommit()
                        }
                    })
                    Spacer()
                }.padding(.leading, 24)
            }

            HStack {
                Text(self.title)
                .retinaTypography(.h4_main)
                .foregroundColor(.white)
                .padding(.leading, 24)
                .fixedSize(horizontal: false, vertical: true)
                Spacer()
                if (self.rightButton) {
                    retinaIconButton(image: (Image(systemName: rightButtonIcon)), foregroundColor: rightButtonIconColor, action: {
                        withAnimation {
                            self.rightButtonCommit()
                        }
                    }).padding([.leading, .trailing], 24)
                }
            }.padding(.bottom, 12)

            Text(description)
                .retinaTypography(.p5_main)
                .foregroundColor(.rGrey100)
                .padding([.leading, .trailing], 24)
                .fixedSize(horizontal: false, vertical: true)

            if (self.searchBar) {
                Search(isBack: false, isFilter: true, placeholder: self.searchBarPlaceholder, searchText: $searchText, buttonCommit: {  })
            }
        }
        .padding(.top, UIApplication.topInset*2)
        .clipped()
        .animation(.default)
        .background(backgroundColor)
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
    @State static var searchText: String?
    
    static var previews: some View {
        VStack() {
            
            TopNavigationView(title: "Choose Close Friends", description: "We’ll tell you when they’re free or busy.", backButton: true, rightButton: true, rightButtonIcon: "chart.bar", searchBar: true, searchBarPlaceholder: "Friends", searchText: $searchText)

            Spacer()
        }
        .edgesIgnoringSafeArea(.horizontal)
        .edgesIgnoringSafeArea(.top)
    }
}
