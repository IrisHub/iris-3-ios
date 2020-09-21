//
//  Search.swift
//  Iris
//
//  Created by Shalin on 7/19/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI

struct Search: View {
    var isBack: Bool
    var isFilter: Bool
    var placeholder: String
    @Binding var searchText: String?
    var buttonCommit: () -> Void = {}

    var body: some View {
        VStack {
            HStack {
                HStack {
                    Button(action: {
                        UIApplication.shared.endEditing(true)
                        self.searchText = ""
                        self.buttonCommit()
                    }) {
                        Image(systemName: isBack ? "chevron.left" : (isFilter ? "line.horizontal.3.decrease" : "magnifyingglass"))
                        .retinaTypography(.h5_main)
                        .foregroundColor(.rWhite)
                    }.padding(6).padding(.leading, 12)

                                        
                    ZStack(alignment: .leading) {
                        if searchText?.isEmpty ?? true { Text(placeholder).foregroundColor(.rWhite).retinaTypography(.p6_main).padding(.leading, 12) }
                        TextField("", text: $searchText.bound).retinaTypography(.p6_main).padding(.leading, 12)
                    }
                    

                    Button(action: {
                        UIApplication.shared.endEditing(true)
                        self.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                    }.padding(6).padding(.trailing, 12)
                }.frame(minHeight: 36)
                    .foregroundColor(.rWhite)
                    .background(Color.rBlack200)
                    .cornerRadius(CornerRadius.rCornerRadius)
                    .padding([.leading, .trailing], 24)
            }
            .frame(width: UIScreen.screenWidth, height: 90)
        }
        

    }
}

struct Search_Previews: PreviewProvider {
    @State static var searchTextEmpty: String? = ""
    @State static var searchTextFilled: String? = "Hi Friends"
    
    static var previews: some View {
        Group {
            HStack {
                retinaSearchButton(text: "Hello", color: .gray, backgroundColor: .white, action: { print("click") })
            }
            Search(isBack: true, isFilter: false, placeholder: "Try a cuisine, ingredient, or dish", searchText: $searchTextEmpty, buttonCommit:{})
            Search(isBack: true, isFilter: false, placeholder: "Try a cuisine, ingredient, or dish", searchText: $searchTextFilled, buttonCommit:{})
        }
    }
}
