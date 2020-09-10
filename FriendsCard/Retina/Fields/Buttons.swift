//
//  Button.swift
//  Iris
//
//  Created by Shalin on 7/17/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI

// MARK: - Custom Button Styles
enum Size {
    case medium, large
}

struct RetinaButtonStyle: ButtonStyle {
    var color: Color
    var size: Size
    var style: retinaButton.Style
    
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        switch style {
        case .fill: return AnyView(FillButton(color: color, configuration: configuration))
        case .outline: return AnyView(OutlineButton(color: color, configuration: configuration))
        case .outlineOnly: return AnyView(OutlineOnlyButton(color: color, configuration: configuration))
        case .ghost: return AnyView(GhostButton(color: color, configuration: configuration))
        case .search: return AnyView(SearchButton(color: color, configuration: configuration))
        case .left: return AnyView(LeftButton(color: color, size: size, configuration: configuration))
        }
    }
    
    struct LeftButton: View {
        var color: Color
        var size: Size
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        var body: some View {
            configuration.label
                .retinaTypography(.h6_main)
                .foregroundColor(isEnabled ? .white : .rBlack200)
                .padding([.leading, .trailing])
                .frame(minHeight: size == .medium ? 36 : 48)
                .background(isEnabled ? color : Color.rBlack400.opacity(0.2))
                .cornerRadius(CornerRadius.rCornerRadius)
                .opacity(configuration.isPressed ? 0.7 : 1)
        }
    }

    
    struct SearchButton: View {
        var color: Color
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        var body: some View {
            configuration.label
                .retinaTypography(.h6_main)
                .foregroundColor(isEnabled ? .white : .rBlack200)
                .padding([.leading, .trailing])
                .frame(minHeight: 36)
                .background(isEnabled ? color : Color.rBlack400.opacity(0.2))
                .cornerRadius(CornerRadius.rCornerRadius)
                .opacity(configuration.isPressed ? 0.7 : 1)
        }
    }

    
    struct FillButton: View {
        var color: Color
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        var body: some View {
            configuration.label
                .retinaTypography(.p5_main)
                .foregroundColor(isEnabled ? .white : .rBlack400)
                .padding()
                .frame(minHeight: 56)
                .background(isEnabled ? color : Color.rBlack400.opacity(0.2))
                .cornerRadius(CornerRadius.rCornerRadius)
                .opacity(configuration.isPressed ? 0.7 : 1)
        }
    }
    
    struct OutlineButton: View {
        var color: Color
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        var body: some View {
            configuration.label
                .retinaTypography(.p5_main)
                .foregroundColor(isEnabled ? color : .rBlack400)
                .padding()
                .frame(minHeight: 56)
                .background(isEnabled ? color.opacity(0.2) : Color.rBlack400.opacity(0.15))
                .cornerRadius(CornerRadius.rCornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.rCornerRadius)
                        .stroke(isEnabled ? color : Color.rBlack400.opacity(0.5), lineWidth: 1)
                )
                .opacity(configuration.isPressed ? 0.7 : 1)
        }
    }
    
    struct OutlineOnlyButton: View {
        var color: Color
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        var body: some View {
            configuration.label
                .retinaTypography(.h5_main)
                .foregroundColor(isEnabled ? color : .rBlack400)
                .padding(12)
                .frame(maxWidth: .infinity, minHeight: 36)
                .background(Color.rBlack400.opacity(0.01))
                .cornerRadius(CornerRadius.rCornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.rCornerRadius)
                        .stroke(isEnabled ? color : Color.rBlack400.opacity(0.5), lineWidth: 2)
                )
                .opacity(configuration.isPressed ? 0.7 : 1)
            
        }
    }

    
    struct GhostButton: View {
        var color: Color
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        var body: some View {
            configuration.label
                .retinaTypography(.p5_main)
                .foregroundColor(isEnabled ? color : .rBlack400)
                .padding()
                .frame(minHeight: 56)
                .background(Color.white)
                .cornerRadius(CornerRadius.rCornerRadius)
                .opacity(configuration.isPressed ? 0.7 : 1)
        }
    }
}

// MARK: - Usage

extension Button {
    /// Changes the appearance of the button
    func style(_ style: retinaButton.Style, color: Color, size: Size) -> some View {
        self.buttonStyle(RetinaButtonStyle(color: color, size: size, style: style))
    }
}

struct retinaButton: View {
    
    enum Style {
        case fill, outline, outlineOnly, ghost, search, left
    }
    
    var text: String?
    var image: Image?
    var style: Style = .fill
    var color: Color = .rBlack400
    var action: () -> Void
    var textAndImage: Bool { text != nil && image != nil }
    
    var body: some View {
        Button(action: action, label: {
            HStack() {
                ZStack {
                    if style == .outlineOnly {
                    }
                    Spacer()
                    HStack(spacing: textAndImage ? 12 : 0) {
                        Text(text ?? "")
                        image
                    }
                    Spacer()
                }
            }
        }).style(style, color: color, size: .large)
    }
}

struct retinaSearchButton: View {
    var text: String?
    var color: Color = .rBlack200
    var backgroundColor: Color = .rBlack500
    var action: () -> Void
    
    var body: some View {
        HStack {
            Button(action: action, label: {
                HStack() {
                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass").padding(6).foregroundColor(.rPink)
                        Text(text ?? "").retinaTypography(.p6_main)
                    }
                    Spacer()
                }
            }).style(.search, color: color, size: .large).padding([.leading, .trailing], 24)
        }.frame(width: UIScreen.screenWidth, height: 90).background(backgroundColor)
    }
}

struct retinaLeftButton: View {
    enum Left { case none, icon, image, emoji }
    var text: String?
    var left: Left? = retinaLeftButton.Left.none
    var iconString: String?
    var color: Color = .rBlack200
    var checked: Bool? = false
    var size: Size? = .large
    var action: () -> Void
    
    var body: some View {
        HStack {
            Button(action: action, label: {
                HStack() {
                    HStack(spacing: 12) {
                        if (iconString != "" && iconString != nil) {
                            if (left == .icon) {
                                Image(iconString ?? "").resizable().frame(width: 24, height: 24).padding(6)
                            } else if (left == .icon) {
                                Image(systemName: iconString ?? "").padding(6).foregroundColor(.rPink)
                            } else if (left == .emoji) {
                                Text(iconString ?? "💎").retinaTypography( size == .medium ? .h6_main : .h5_main)
                            }
                        }
                        Text(text ?? "").retinaTypography( size == .medium ? .h6_main : .h5_main)
                    }
                    Spacer()
                    if checked ?? false {
                        Image(systemName: "checkmark").padding(6).foregroundColor(.rWhite).retinaTypography(.h6_main)
                    }
                }
            }).style(.left, color: color, size: size ?? .large).padding([.leading, .trailing], 24)
        }.frame(width: UIScreen.screenWidth, height: size == .medium ? 48 : 60)
    }
}



struct retinaIconButton: View {
    var image: Image?
    var foregroundColor: Color = .rWhite
    var backgroundColor: Color = .rBlack500
    var action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            HStack {
                image?.foregroundColor(foregroundColor).retinaTypography(.h5_main)
            }
            .frame(width: 48, height: 48)
            .background(backgroundColor.opacity(0.6))
            .cornerRadius(CornerRadius.rCornerRadius)
        })
    }
}




// MARK: - Preview

public struct Input_Previews: PreviewProvider {
    static let cloudImg = Image(systemName: "cloud.sun")
    
    public static var previews: some View {
        VStack(spacing: 40) {
            
            HStack(spacing: 5) {
                retinaButton(text: "Fill", style: .fill, action: { print("click") })
                retinaButton(text: "Outline", style: .outlineOnly, color: .rBlack400, action: { print("click") })
                retinaButton(text: "Ghost", style: .ghost, action: { print("click") })
            }
            
            HStack(spacing: 5) {
                retinaButton(text: "Danger", color: .rBlack400, action: { print("click") })
                retinaButton(text: "Warning", color: .rBlack400, action: { print("click") })
                retinaButton(text: "Success", color: .rBlack400, action: { print("click") })
            }
            
            HStack(spacing: 5) {
                retinaButton(text: "Disabled", style: .fill, action: { print("click") })
                    .disabled(true)
                retinaButton(text: "Disabled", style: .outline, action: { print("click") })
                    .disabled(true)
                retinaButton(text: "Disabled", style: .ghost, action: { print("click") })
                    .disabled(true)
            }
            
            HStack(spacing: 5) {
                retinaButton(text: "Text", action: { print("click") })
                retinaButton(text: "Text", image: cloudImg, action: { print("click") })
                retinaButton(image: cloudImg, action: { print("click") })
            }
            
            HStack(spacing: 5) {
                retinaSearchButton(text: "Text", action: { print("click") })
            }
            
            HStack(spacing: 5) {
                retinaLeftButton(text: "Text", action: { print("click") })
            }

            
            HStack(spacing: 5) {
                retinaIconButton(image: (Image(systemName: "line.horizontal.3.decrease")), action: { print("click") })
            }

            
            Button(action: { print("click") }, label: { Text("Custom") })
                .style(.outline, color: .rBlack400, size: .large)
        }
    .padding(10)
    }
}
