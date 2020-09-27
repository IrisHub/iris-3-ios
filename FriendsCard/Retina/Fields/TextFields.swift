//
//  TextFields.swift
//  Iris
//
//  Created by Shalin on 7/17/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI

public struct RetinaTextField: View {
    
    enum Style {
        case defaultStyle, primary, disabled, success, warning, danger, info
    }
    
    var style: Style
    var placeholder: String
    var icon: Image? = nil
    var commit: ()->() = { }
    @State private var focused: Bool = false
    @Binding var input: String
    
    // MARK: Inits
    
    init(_ placeholder: String, input:  Binding<String>, onCommit: @escaping ()->() = { }) {
        self.placeholder = placeholder
        _input = input
        self.style = .defaultStyle
        self.commit = onCommit
    }
    
    init(_ placeholder: String, input:  Binding<String>, style: Style, onCommit: @escaping ()->() = { }) {
        self.placeholder = placeholder
        _input = input
        self.style = style
        self.commit = onCommit
    }
    
    init(_ placeholder: String, input:  Binding<String>, icon: Image, onCommit: @escaping ()->() = { }) {
        self.placeholder = placeholder
        _input = input
        self.icon = icon
        self.style = .defaultStyle
        self.commit = onCommit
    }
    
    init(_ placeholder: String, input:  Binding<String>, style: Style, icon: Image, onCommit: @escaping ()->() = { }) {
        self.placeholder = placeholder
        _input = input
        self.style = style
        self.icon = icon
        self.commit = onCommit
    }
    
    // MARK:  Function declarations
    
    fileprivate func defaultStyle() -> some View {
        HStack {
            Rectangle().frame(width: 2, height: 26, alignment: .leading).foregroundColor(.rPink).cornerRadius(1).padding(.leading, 12)
            ZStack(alignment: .leading) {
                if input.isEmpty { Text(placeholder).foregroundColor(.rGrey100).retinaTypography(.p5_main).padding(.leading, 12) }
                TextField("", text: $input, onEditingChanged: { editingChanged in
                    self.focused = editingChanged
                    print(editingChanged ? "TextField focused" : "TextField focus removed")
                    
                }, onCommit: commit).padding(.leading, 12).foregroundColor(.rWhite)
            }
            if focused { icon.imageScale(.large).foregroundColor(.rGrey100) }
            else { icon.imageScale(.large).foregroundColor(.rGrey100) }
        }
        .padding(12)
        .background(Color.rBlack100)
    }
    
    fileprivate func primary() -> some View {
        HStack {
            ZStack(alignment: .leading) {
                if input.isEmpty { Text(placeholder).foregroundColor(.rBlack400) }
                TextField("", text: $input, onEditingChanged: { editingChanged in
                    self.focused = editingChanged
                    print(editingChanged ? "TextField focused" : "TextField focus removed")
                }, onCommit: commit).foregroundColor(.rBlack400)
            }
             icon.imageScale(.large).foregroundColor(.rBlack400)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 5)
        .foregroundColor(Color.rBlack400.opacity(self.focused ? 0 : 0.1)))
        .overlay(RoundedRectangle(cornerRadius: 5)
        .stroke(Color.rBlack400, lineWidth: 1))
    }
    
    fileprivate func success() -> some View {
        HStack {
            ZStack(alignment: .leading) {
                if input.isEmpty { Text(placeholder).foregroundColor(.rBlack400) }
                TextField("", text: $input, onEditingChanged: { editingChanged in
                    self.focused = editingChanged
                    print(editingChanged ? "TextField focused" : "TextField focus removed")
                }, onCommit: commit).foregroundColor(.rBlack400)
            }
            icon.imageScale(.large).foregroundColor(.rBlack400)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 5)
        .foregroundColor(Color.rBlack400.opacity(self.focused ? 0 : 0.1)))
        .overlay(RoundedRectangle(cornerRadius: 5)
        .stroke(Color.rBlack400, lineWidth: 1))
    }
    
    fileprivate func warning() -> some View {
        HStack {
            ZStack(alignment: .leading) {
                if input.isEmpty { Text(placeholder).foregroundColor(Color.rBlack400) }
                TextField("", text: $input, onEditingChanged: { editingChanged in
                    self.focused = editingChanged
                    print(editingChanged ? "TextField focused" : "TextField focus removed")
                }, onCommit: commit).foregroundColor(.rBlack400)
            }
            icon.imageScale(.large).foregroundColor(.rBlack400)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 5)
        .foregroundColor(Color.rBlack400.opacity(self.focused ? 0 : 0.1)))
        .overlay(RoundedRectangle(cornerRadius: 5)
        .stroke(Color.rBlack400, lineWidth: 1))
    }
    
    fileprivate func danger() -> some View {
        HStack {
            ZStack(alignment: .leading) {
                if input.isEmpty { Text(placeholder).foregroundColor(.rBlack400) }
                TextField("", text: $input, onEditingChanged: { editingChanged in
                    self.focused = editingChanged
                    print(editingChanged ? "TextField focused" : "TextField focus removed")
                }, onCommit: commit).foregroundColor(.rBlack400)
            }
            icon.imageScale(.large).foregroundColor(.rBlack400)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 5)
        .foregroundColor(Color.rBlack400.opacity(self.focused ? 0 : 0.1)))
        .overlay(RoundedRectangle(cornerRadius: 5)
        .stroke(Color.rBlack400, lineWidth: 1))
    }
    
    fileprivate func info() -> some View {
        HStack {
            ZStack(alignment: .leading) {
                if input.isEmpty { Text(placeholder).foregroundColor(.rBlack400) }
                TextField("", text: $input, onEditingChanged: { editingChanged in
                    self.focused = editingChanged
                    print(editingChanged ? "TextField focused" : "TextField focus removed")
                }, onCommit: commit).foregroundColor(.rBlack400)
            }
            icon.imageScale(.large).foregroundColor(.rBlack400)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 5)
        .foregroundColor(Color.rBlack400.opacity(self.focused ? 0 : 0.1)))
        .overlay(RoundedRectangle(cornerRadius: 5)
        .stroke(Color.rBlack400, lineWidth: 1))
    }
    
    // MARK:  Body
    
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
}

// MARK: Preview

struct TextField_Previews: PreviewProvider {
    @State static var input: String = ""
    static var previews: some View {
        VStack(spacing: 20) {
            RetinaTextField("Thats a default Textfield", input: $input, onCommit: {print("party")})
            RetinaTextField("Thats a default Textfield + Icon", input: $input, icon: Image(systemName: "star.fill"), onCommit: {print("party")})
            RetinaTextField("Primary", input: $input, style: .primary, icon: Image(systemName: "star.fill"))
            RetinaTextField("Success", input: $input, style: .success, icon: Image(systemName: "star.fill"))
            RetinaTextField("Warning", input: $input, style: .warning, icon: Image(systemName: "star.fill"))
            RetinaTextField("Danger", input: $input, style: .danger, icon: Image(systemName: "star.fill"))
            RetinaTextField("Info", input: $input, style: .info, icon: Image(systemName: "star.fill"))
        }
        .padding()
    }
}
