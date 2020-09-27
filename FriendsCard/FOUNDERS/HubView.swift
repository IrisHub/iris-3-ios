//
//  HubView.swift
//  FriendsCard
//
//  Created by Shalin on 9/26/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct HubView: View {
    @EnvironmentObject var screenCoordinator: ScreenCoordinator
    @State var staticJSON = false

    var body: some View {
        ZStack {
            Color.rBlack500.edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                TopNavigationHeader(heading: "", title: "IRIS HUB", description: "", backButton: true, backButtonCommit: { self.screenCoordinator.selectedPushItem = .home })
                
                HStack {
                    Text("STATIC JSON RESPONSES").retinaTypography( .h5_main)
                    Spacer()
                    RetinaToggle(toggleState: $staticJSON, style: .defaultStyle)
                }.padding([.leading,.bottom,.trailing], 24)

                
                retinaLeftButton(text: "RESET APP & DATABASE SETTINGS", left: retinaLeftButton.Left.none, iconString: "", checked: false, action: {
                    self.resetEverything()
                })

                Spacer()
            }
        }
        .onAppear() {
            self.staticJSON = UserDefaults.standard.bool(forKey: "useStaticJSON")
        }
        .onChange(of: staticJSON) { _ in
            print("updated user defaults", staticJSON)
            UserDefaults.standard.set(staticJSON, forKey: "useStaticJSON")
            if (staticJSON) {
            } else {
                
            }
        }
        .hideNavigationBar()
    }
    
    func resetEverything() {
        let parameters = [
            "user_id": UserDefaults.standard.string(forKey: "phoneNumber")
        ]
        let headers : HTTPHeaders = ["Content-Type": "application/json"]
        AF.request("https://7vo5tx7lgh.execute-api.us-west-1.amazonaws.com/testing/delete-user", method: .post, parameters: parameters as Parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
            do {
                let json = try JSON(data: response.data ?? Data())
                print(json)
                
                UserDefaults.standard.removeObject(forKey: "card1PermissionsComplete")
                UserDefaults.standard.removeObject(forKey: "card2PermissionsComplete")
                UserDefaults.standard.removeObject(forKey: "card3PermissionsComplete")
                UserDefaults.standard.removeObject(forKey: "card4PermissionsComplete")
                UserDefaults.standard.removeObject(forKey: "card5PermissionsComplete")
                UserDefaults.standard.removeObject(forKey: "classes")
                UserDefaults.standard.removeObject(forKey: "closeFriends")
                UserDefaults.standard.removeObject(forKey: "contactsAllowed")
                UserDefaults.standard.removeObject(forKey: "calendarAllowed")
            } catch {
                print("error")
            }
        }
    }
    
    func useStaticJSON() {
        UserDefaults.standard.set(true, forKey: "useStaticJSON")
    }

}

struct HubView_Previews: PreviewProvider {
    static var previews: some View {
        HubView()
    }
}
