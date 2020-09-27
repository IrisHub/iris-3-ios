//
//  AccessCode.swift
//  FriendsCard
//
//  Created by Shalin on 9/26/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI
import GoogleSignIn

struct AccessCode: View {
    @State var input: String = ""
    @State var value: CGFloat = 0
    @State var errorAlert = false
    @State var emptyAlert = false
    @State var moveToNext: Bool = false

    @EnvironmentObject var screenCoordinator: ScreenCoordinator

    var body: some View {
        ZStack {
            Color.rBlack500.edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                HStack {
                    Image("oski")
                    Spacer()
                }.frame(height: 150)
            }
            
            VStack {
                VStack(alignment: .leading) {
                    
                    HStack {
                        retinaIconButton(image: (Image(systemName: "chevron.left")), backgroundColor: .clear, action: {
                            DispatchQueue.main.async {
                                self.screenCoordinator.selectedPushItem = .home
                            }
                        })
                        Spacer()
                    }.padding([.leading, .bottom], 6)

                    
                    Text("HELLO KING 👑").retinaTypography(.p1_main).foregroundColor(.rWhite).padding([.leading, .trailing], 24).padding(.bottom, 12)
                                        
                    RetinaTextField("ENTER ACCESS CODE", input: $input, onCommit: { print("party") })
                        .frame(width: UIScreen.screenWidth - 60)
                        .padding(.leading, 24)
                    
                    if (self.errorAlert || self.emptyAlert) {
                        Text(self.emptyAlert ? "Enter something and try again." : "Invalid code, try again.").retinaTypography(.p6_main).foregroundColor(.rRed).padding(.leading, 24).padding([.bottom, .top], 12)
                    }
                                        
                }.padding(.top, 24)
                Spacer()
            }
                                    
            VStack {
                Spacer()
                BottomNavigationView(title: "UNLOCK", action: {self.verifyCode()})
                .isHidden(self.input == "", remove: self.input == "")
                .animation(.easeInOut)
            }

            NavigationLink(destination: HubView().environmentObject(self.screenCoordinator), isActive: self.$moveToNext) { EmptyView() }
        }
        .onTapGesture(count: 1, perform: {
            self.hideKeyboard()
        })
        .hideNavigationBar()
    }
    
    func verifyCode() {
        UIApplication.shared.endEditing(true)
        
        if self.input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.emptyAlert = true
            return
        }
        
        
        if !(self.input.trimmingCharacters(in: .whitespacesAndNewlines) == "👁") && !(self.input.trimmingCharacters(in: .whitespacesAndNewlines) == "🖍") && !(self.input.trimmingCharacters(in: .whitespacesAndNewlines) == "💀") {
            self.errorAlert = true
            return
        }
        
        self.moveToNext = true
    }
}

struct AccessCode_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNumberView()
    }
}
