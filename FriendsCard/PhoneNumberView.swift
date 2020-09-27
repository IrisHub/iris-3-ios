//
//  PhoneNumberView.swift
//  FriendsCard
//
//  Created by Shalin on 9/6/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI
import GoogleSignIn
import Alamofire
import SwiftyJSON

struct PhoneNumberView: View {
    @State var input: String = ""
    @State var value: CGFloat = 0
    @State var errorAlert = false
    @State var emptyAlert = false

    @EnvironmentObject var googleDelegate: GoogleDelegate
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
                    Text("YOUR CAL STARTER PACK x ONLINE SCHOOL SAVIOR  x ENDER OF THE CAL STANFORD RIVALRY X MOFFITT 2.0").retinaTypography(.h6_main).foregroundColor(.rPink).padding([.leading, .trailing], 24).padding(.bottom, 12)

                    Text("WELCOME TO IRIS").retinaTypography(.p1_main).foregroundColor(.rWhite).padding([.leading, .trailing], 24).padding(.bottom, 12)
                    
                    if (self.errorAlert || self.emptyAlert) {
                        Text(self.emptyAlert ? "Enter something and try again." : "Invalid number, please try again.").retinaTypography(.p6_main).foregroundColor(.rRed).padding(.leading, 24).padding([.bottom, .top], 12)
                    }
                    
                    RetinaTextField("ENTER YOUR PHONE #", input: $input, onCommit: {print("party")})
                        .textContentType(.telephoneNumber)
                        .keyboardType(.numberPad)
                        .frame(width: UIScreen.screenWidth - 60)
                        .padding(.leading, 24)
                    
                    HStack {
                        Text("You agree to our").retinaTypography(.p6_main).foregroundColor(.rWhite).fixedSize(horizontal: false, vertical: true)
                        NavigationLink(destination: InformationView(type: .privacy).environmentObject(self.screenCoordinator), tag: ScreenCoordinator.PushedItem.privacy, selection: self.$screenCoordinator.selectedPushItem) {
                            Text("Privacy").underline().retinaTypography(.p6_main).foregroundColor(.rWhite).fixedSize(horizontal: false, vertical: true)
                        }
                        Text("+").retinaTypography(.p6_main).foregroundColor(.rWhite).fixedSize(horizontal: false, vertical: true)
                        NavigationLink(destination: InformationView(type: .tos).environmentObject(self.screenCoordinator), tag: ScreenCoordinator.PushedItem.tos, selection: self.$screenCoordinator.selectedPushItem) {
                            Text("Terms").underline().retinaTypography(.p6_main).foregroundColor(.rWhite).fixedSize(horizontal: false, vertical: true)
                        }
                        Text("🐻").retinaTypography(.p6_main).fixedSize(horizontal: false, vertical: true)
                    }
                    .shadow(color: .rBlack500, radius: 10)
//                    .isHidden(self.input == "", remove: self.input == "")
                    .padding(.top, 12).padding(.leading, 24)
                    
                }.padding(.top, 24)
                Spacer()
            }
                                    
            VStack {
                Spacer()
                BottomNavigationView(title: "Submit", action: {self.verifyCode()})
                .isHidden(self.input == "", remove: self.input == "")
                .animation(.easeInOut)
            }

            NavigationLink(destination: HomeView().environmentObject(googleDelegate).environmentObject(self.screenCoordinator), tag: ScreenCoordinator.PushedItem.home, selection: self.$screenCoordinator.selectedPushItem) { EmptyView() }
        }
        .onTapGesture(count: 1, perform: {
            self.hideKeyboard()
        })
        .hideNavigationBar()
        .onAppear() {
            self.checkStatic()
        }
    }
    
    func verifyCode() {
        UIApplication.shared.endEditing(true)
        
        if self.input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.emptyAlert = true
            return
        }
        
        
        if !(self.input.trimmingCharacters(in: .whitespacesAndNewlines).isPhoneNumber) || self.input.count < 10 {
            self.errorAlert = true
            return
        }
        
        UserDefaults.standard.set(self.input.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "phoneNumber")
        
        UserDefaults.standard.set(true, forKey: "onboardingComplete")
        self.screenCoordinator.selectedPushItem = .home
    }
    
    func checkStatic() {
        print("checking static")
        AF.request("https://raw.githubusercontent.com/IrisHub/iris-3-endpoint-responses/master/user_interview_static.json", method: .get, encoding: JSONEncoding.default)
            .responseJSON { response in
            do {
                let json = try JSON(data: response.data ?? Data())
                if (UserDefaults.standard.string(forKey: "phoneNumber") == json["number"].stringValue) {
                    UserDefaults.standard.setValue(true, forKey: "useStaticJSON")
                }
            } catch {
                print("error")
            }
        }
    }
}

struct PhoneNumberView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNumberView()
    }
}
