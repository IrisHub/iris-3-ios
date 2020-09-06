//
//  Typography.swift
//  Iris
//
//  Created by Shalin on 7/16/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI


public struct RetinaTypography: ViewModifier {
    
    private enum Family: String {
        case
        main = "DMSans",
        secondary = "DMSerifDisplay"
    }
    
    private enum Weight: String {
        case regular, medium, bold
    }
    
    private enum Size: CGFloat {
        case
        one = 60,
        two = 48,
        three = 36,
        four = 24,
        five = 16,
        six = 14
    }
    
    enum Style {
        /// Titles
        case h1_main, h2_main, h3_main, h4_main, h5_main, h6_main
        
        /// Paragraphs
        case p5_main, p6_main
        
        /// Titles
        case h1_secondary, h2_secondary, h3_secondary, h4_secondary, h5_secondary, h6_secondary
        
        /// Paragraphs
        case p5_secondary, p6_secondary

    }
        
    var style: Style
    
    private func getName(_ family: Family, _ weight: Weight) -> String {
        let fontWeight = weight.rawValue.capitalizingFirstLetter()
        let familyName = family.rawValue
//        print("\(familyName)-\(fontWeight)")
        return "\(familyName)-\(fontWeight)"
    }
    
    private func customFont(family: Family, weight: Weight, size: Size) -> Font {
        return Font.custom(getName(family, weight), size: size.rawValue)
    }
    
    public func body(content: Content) -> some View {
        switch style {
        case .h1_main: return content
            .font(customFont(family: .main, weight: .bold, size: .one))
        case .h2_main: return content
            .font(customFont(family: .main, weight: .bold, size: .two))
        case .h3_main: return content
            .font(customFont(family: .main, weight: .bold, size: .three))
        case .h4_main: return content
            .font(customFont(family: .main, weight: .bold, size: .four))
        case .h5_main: return content
            .font(customFont(family: .main, weight: .bold, size: .five))
        case .h6_main: return content
            .font(customFont(family: .main, weight: .bold, size: .six))
            
        case .p5_main: return content
            .font(customFont(family: .main, weight: .regular, size: .five))
        case .p6_main: return content
            .font(customFont(family: .main, weight: .regular, size: .six))
            
        case .h1_secondary: return content
            .font(customFont(family: .secondary, weight: .regular, size: .one))
        case .h2_secondary: return content
            .font(customFont(family: .secondary, weight: .regular, size: .two))
        case .h3_secondary: return content
            .font(customFont(family: .secondary, weight: .regular, size: .three))
        case .h4_secondary: return content
            .font(customFont(family: .secondary, weight: .regular, size: .four))
        case .h5_secondary: return content
            .font(customFont(family: .secondary, weight: .regular, size: .five))
        case .h6_secondary: return content
            .font(customFont(family: .secondary, weight: .regular, size: .six))

        case .p5_secondary: return content
            .font(customFont(family: .secondary, weight: .regular, size: .five))
        case .p6_secondary: return content
            .font(customFont(family: .secondary, weight: .regular, size: .six))
            
        }
    }
}

extension View {
    func retinaTypography(_ style: RetinaTypography.Style) -> some View {
        self
            .modifier(RetinaTypography(style: style))
    }
    
    func retinaTypography(_ style: RetinaTypography.Style, color: Color) -> some View {
        self
            .modifier(RetinaTypography(style: style))
            .foregroundColor(color)
    }
}


struct Typography_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            VStack(alignment: .leading, spacing: 20) {
                Group {
                    Text("Text").retinaTypography(.h1_main, color: .rBlack400)
                    Text("Text").retinaTypography(.h1_main, color: .rBlack400)
                    Text("Text").retinaTypography(.h1_main, color: .rBlack400)
                
                    Text("Text").retinaTypography(.h1_main)
                    Text("Text").retinaTypography(.h2_main)
                    Text("Text").retinaTypography(.h3_main)
                    Text("Text").retinaTypography(.h4_main)
                    Text("Text").retinaTypography(.h5_main)
                    Text("Text")
                }
                Group {
    //                Text("Text").retinaTypography(.s1)
    //                Text("Text").retinaTypography(.s2)
                    
                    Text("Text").retinaTypography(.p5_main)
                    Text("Text").retinaTypography(.p6_main)
                    
    //                Text("Text").retinaTypography(.c1)
    //                Text("Text").retinaTypography(.c2)
                }
            }.padding()
            Spacer()
        }
    }
}
