//
//  Padding.swift
//  Iris
//
//  Created by Shalin on 7/17/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI

extension Image {
    
    //MARK: Avatars
    
    ///Turn image into a circular avatar
    func retinaAvatarCircle() -> some View {
        self
            .resizable()
            .renderingMode(.original)
            .aspectRatio(contentMode: .fill)
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            .padding(.all, 16)
        
    }
    
    ///Turn image into a rectangular avatar
    func retinaAvatarSquare() -> some View {
        self
            .resizable()
            .renderingMode(.original)
            .aspectRatio(contentMode: .fill)
            .frame(width: 40, height: 40)
            .clipShape(Rectangle())
            .padding(.all, 16)
        
    }
    ///Turn image into a rounded rectangle avatar
    func retinaAvatarRounded() -> some View {
        self
            .resizable()
            .renderingMode(.original)
            .aspectRatio(contentMode: .fill)
            .frame(width: 40, height: 40)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .padding(.all, 16)
        
    }
    
    //MARK: Styled Images
    
    ///Modify image to fit a circular format
    func retinaCircle(width: CGFloat) -> some View {
        self
            .resizable()
            .renderingMode(.original)
            .aspectRatio(contentMode: .fill)
            .frame(width: width, height: width)
            .clipShape(Circle())
    }
    
    ///Modify image to fit a square format
    func retinaSquare(width: CGFloat) -> some View {
        self
            .resizable()
            .renderingMode(.original)
            .aspectRatio(contentMode: .fill)
            .frame(width: width, height: width)
    }
    
    ///Modify image to fit a rectangle format with the edges clipped
    func retinaRectangle(width: CGFloat, height: CGFloat) -> some View {
        self
            .resizable()
            .renderingMode(.original)
            .aspectRatio(contentMode: .fill)
            .frame(width: width, height: height)
            .clipped()
    }

    
    ///Modify image to fit a rounded corners square format
    func retinaRounded(width: CGFloat) -> some View {
        self
            .resizable()
            .renderingMode(.original)
            .aspectRatio(contentMode: .fill)
            .frame(width: width, height: width)
            .clipShape(RoundedRectangle(cornerRadius: width/10.0))
    }
    ///Modify image to have upper rounded corners in a square format
    func retinaTopRounded(width: CGFloat) -> some View {
        self
            .resizable()
            .renderingMode(.original)
            .aspectRatio(contentMode: .fill)
            .frame(width: width, height: width)
            .clipShape(RoundedCorner(radius: width/10.0, corners: [.topLeft, .topRight]))
    }
    
    ///Modify image to have lower rounded corners in a square format
    func retinaBottomRounded(width: CGFloat) -> some View {
        self
            .resizable()
            .renderingMode(.original)
            .aspectRatio(contentMode: .fill)
            .frame(width: width, height: width)
            .clipShape(RoundedCorner(radius: width/10.0, corners: [.bottomLeft, .bottomRight]))
    }
    
    ///Modify image to have left-side rounded corners in a square format
    func retinaLeftRounded(width: CGFloat) -> some View {
        self
            .resizable()
            .renderingMode(.original)
            .aspectRatio(contentMode: .fill)
            .frame(width: width, height: width)
            .clipShape(RoundedCorner(radius: width/10.0, corners: [.bottomLeft, .topLeft]))
        
            
    }
    
    ///Modify image to have right-side rounded corners in a square format
    func retinaRightRounded(width: CGFloat) -> some View {
        self
            .resizable()
            .renderingMode(.original)
            .aspectRatio(contentMode: .fill)
            .frame(width: width, height: width)
            .clipShape(RoundedCorner(radius: width/10.0, corners: [.bottomRight, .topRight]))
    }
    
    
}


struct Images_Previews_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                Image("food")
                    .retinaAvatarCircle()
                Image("food")
                    .retinaAvatarSquare()
                Image("food")
                    .retinaAvatarRounded()
                
            }.padding()
            
            HStack(spacing: 20) {
                Image("food")
                    .retinaCircle(width: 90)
                Image("food")
                    .retinaSquare(width: 90)
                Image("food")
                    .retinaRounded(width: 90)
            }.padding()
            
            HStack {
                Image("food")
                    .retinaRectangle(width: 300, height: 120)
            }.padding()
            
            HStack(spacing: 20) {
                Image("food")
                    .retinaTopRounded(width: 120)
                Image("food")
                    .retinaBottomRounded(width: 120)
            }.padding()
            
            HStack(spacing: 20) {
                Image("food")
                    .retinaLeftRounded(width: 120)
                Image("food")
                    .retinaRightRounded(width: 120)
            }.padding()
        }
    }
}
