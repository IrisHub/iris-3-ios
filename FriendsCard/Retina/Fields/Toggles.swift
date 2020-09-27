//
//  Toggles.swift
//  Iris
//
//  Created by Shalin on 7/17/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI

public struct RetinaToggle: View {
    
    enum Style {
        case defaultStyle, primary, disabled, success, warning, danger, info
    }
    
    @Binding var toggleState: Bool
    var style: Style
    
    struct ColoredToggleStyle: ToggleStyle {
        var onColor = Color.rBlack400
        var offColor = Color.rBlack400
        var thumbColor = Color.white
        
        func makeBody(configuration: Self.Configuration) -> some View {
            Button(action: { configuration.isOn.toggle() } ) {
                RoundedRectangle(cornerRadius: 16, style: .circular)
                    .fill(configuration.isOn ? onColor : offColor)
                    .frame(width: 50, height: 29)
                    .overlay(
                        ZStack {
                            Circle()
                                .fill(thumbColor)
                                .shadow(radius: 1, x: 0, y: 1)
                                .padding(1.5)
                                .offset(x: configuration.isOn ? 10 : -10)
//                            Image(systemName: configuration.isOn ? "checkmark" : "")
//                                .font(.system(size: 12, weight: .black))
//                                .foregroundColor(onColor)
//                                .offset(x: configuration.isOn ? 10 : -10)
                        }
                    )
                    .animation(.easeInOut(duration: 0.1))
            }
            .font(.title)
            .padding(.horizontal)
        }
    }
    
    
    public var body: some View {
        switch style {
        case .primary: return AnyView(primary())
        case .success: return AnyView(success())
        case .warning: return AnyView(warning())
        case .danger: return AnyView(danger())
        case .info: return AnyView(info())
        default: return AnyView(defaultStyle())
        }
    }
    
    
    fileprivate func defaultStyle() -> some View {
        Toggle("", isOn: $toggleState)
            .toggleStyle(
                ColoredToggleStyle(
                    onColor: .rPink,
                    offColor: Color.rBlack400.opacity(0.1),
                    thumbColor: .white))
    }
    
    fileprivate func primary() -> some View {
        Toggle("", isOn: $toggleState)
            .toggleStyle(
                ColoredToggleStyle(
                    onColor: .rBlack400,
                    offColor: Color.rBlack400.opacity(0.1),
                    thumbColor: .white))
    }
    
    fileprivate func success() -> some View {
        Toggle("", isOn: $toggleState)
            .toggleStyle(
                ColoredToggleStyle(
                    onColor: .rBlack400,
                    offColor: Color.rBlack400.opacity(0.1),
                    thumbColor: .white))
    }
    
    fileprivate func info() -> some View {
        Toggle("", isOn: $toggleState)
            .toggleStyle(
                ColoredToggleStyle(
                    onColor: .rBlack400,
                    offColor: Color.rBlack400.opacity(0.1),
                    thumbColor: .white))
    }
    
    
    fileprivate func warning() -> some View {
        Toggle("", isOn: $toggleState)
            .toggleStyle(
                ColoredToggleStyle(
                    onColor: .rBlack400,
                    offColor: Color.rBlack400.opacity(0.1),
                    thumbColor: .white))
    }
    
    
    fileprivate func danger() -> some View {
        Toggle("", isOn: $toggleState)
            .toggleStyle(
                ColoredToggleStyle(
                    onColor: .rBlack400,
                    offColor: Color.rBlack400.opacity(0.1),
                    thumbColor: .white))
    }
}

struct Toggles_Previews: PreviewProvider {
    @State static var toggleState: Bool = true

    static var previews: some View {
        VStack {
            RetinaToggle(toggleState: self.$toggleState, style: .defaultStyle)
            RetinaToggle(toggleState: self.$toggleState, style: .primary)
            RetinaToggle(toggleState: self.$toggleState, style: .success)
            RetinaToggle(toggleState: self.$toggleState, style: .info)
            RetinaToggle(toggleState: self.$toggleState, style: .warning)
            RetinaToggle(toggleState: self.$toggleState, style: .danger)
        }
    }
}
