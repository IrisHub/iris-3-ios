//
//  SearchCell.swift
//  Iris
//
//  Created by Shalin on 7/21/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI

struct LeaderCell: View {
    var title: String
    var subtitle: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("🍾  " + title).foregroundColor(.rWhite).retinaTypography(.h5_main).fixedSize(horizontal: false, vertical: true).padding(.leading, 24)
            }
            Spacer()
            Text(subtitle).foregroundColor(.rPink).retinaTypography(.h5_main).fixedSize(horizontal: false, vertical: true).padding(.trailing, 24)
        }
        .frame(width: UIScreen.screenWidth, height: 60)
    }
}

struct SearchCell_Previews: PreviewProvider {
    static var previews: some View {
        LeaderCell(title: "Sam Gorman", subtitle: "3/3")
    }
}
