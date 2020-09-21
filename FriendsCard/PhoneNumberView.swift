//
//  PhoneNumberView.swift
//  FriendsCard
//
//  Created by Shalin on 9/6/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI
import GoogleSignIn

struct PhoneNumberView: View {
    @State var input: String = ""
    @State var value: CGFloat = 0
    @State var errorAlert = false
    @State var emptyAlert = false
    @State var moveToNext: Bool = false

    @EnvironmentObject var googleDelegate: GoogleDelegate

    var body: some View {
        ZStack {
            Color.rBlack400.edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                HStack {
                    Image("oski")
                    Spacer()
                }.frame(height: 150)
            }
            

            VStack {
                VStack(alignment: .leading) {
                    Text("YOUR CAL STARTER PACK x ONLINE SCHOOL SAVIOR  x ENDER OF THE CAL STANFORD RIVALRY X MOFFITT 2.0").retinaTypography(.h6_main).foregroundColor(.rPink).padding([.leading, .trailing], 24).padding(.bottom, 12)

                    Text("WELCOME TO IRIS").retinaTypography(.h1_main).foregroundColor(.rWhite).padding([.leading, .trailing], 24).padding(.bottom, 12)
                    
                    RetinaTextField("ENTER YOUR PHONE #", input: $input, onCommit: {print("party")})
                        .textContentType(.telephoneNumber)
                        .keyboardType(.numberPad)
                        .frame(width: UIScreen.screenWidth - 60)
                        .padding(.leading, 24)
                    
                    if (self.errorAlert || self.emptyAlert) {
                        Text(self.emptyAlert ? "Enter something and try again." : "Invalid code entered, please try again.").retinaTypography(.p6_main).foregroundColor(.rRed).padding([.leading, .top], 24)
                    }
                }.padding(.top, 24)
                Spacer()
            }
                                    
            VStack {
                Spacer()
                BottomNavigationView(title: "Submit", action: {self.verifyCode()})
                .isHidden(self.input == "", remove: self.input == "")
                .animation(.easeInOut)
            }

            NavigationLink(destination: HomeView().environmentObject(googleDelegate), isActive: $moveToNext) { EmptyView() }
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
        
        if !(self.input.trimmingCharacters(in: .whitespacesAndNewlines).isPhoneNumber) {
            self.errorAlert = true
            return
        }
        
        UserDefaults.standard.set(self.input.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "phoneNumber")
        
        UserDefaults.standard.set(true, forKey: "onboardingComplete")
        self.moveToNext = true
    }
}

struct PhoneNumberView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNumberView()
    }
}
