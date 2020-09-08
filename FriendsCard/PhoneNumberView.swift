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

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var googleDelegate: GoogleDelegate

    var body: some View {
        NavigationView {
            ZStack {
                Color.rBlack400.edgesIgnoringSafeArea(.all)
                VStack {
                    VStack(alignment: .leading) {
                        Text("What’s your phone number? ").retinaTypography(.h4_secondary).foregroundColor(.rWhite).padding([.leading, .bottom], 24)
                        RetinaTextField("Enter your phone number", input: $input, onCommit: {print("party")})
                        if (self.errorAlert || self.emptyAlert) {
                            Text(self.emptyAlert ? "Enter something and try again." : "Invalid code entered, please try again.").retinaTypography(.p6_main).foregroundColor(.rRed).padding([.leading, .top], 24)
                        }
                    }.padding(.top, UIScreen.screenHeight/5)
                    Spacer()
                    Group {
                        ZStack {
                            Rectangle()
                            .foregroundColor(Color.rBlack200)
                            .frame(width: UIScreen.screenWidth, height: 100)
                            
                            HStack {
                                retinaButton(text: "Submit", style: .outlineOnly, color: .rPink, action: { self.verifyCode() }).frame(width: UIScreen.screenWidth-48, height: 36, alignment: .trailing)
                            }
                        }.padding(.bottom, DeviceUtility.isIphoneXType ? UIApplication.bottomInset : 0)
                    }
                    .offset(y: -self.value)
                    .animation(.spring())
                    .onAppear {
                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) {
                            (notif) in
                            if let rect = notif.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect {
                                let keyboardHeight = rect.height
                                self.value = keyboardHeight
                            }
                        }
                        
                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) {
                            (notif) in
                            self.value = 0
                        }
                    }

                }
                NavigationLink(destination: HomeView().environmentObject(googleDelegate), isActive: $moveToNext) { EmptyView() }
            }
            .edgesIgnoringSafeArea(.all)
        }
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
        
        UserDefaults.standard.set(true, forKey: "onboardingComplete")
        self.moveToNext = true
    }
}

struct PhoneNumberView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNumberView()
    }
}
