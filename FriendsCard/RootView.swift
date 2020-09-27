//
//  RootView.swift
//  FriendsCard
//
//  Created by Shalin on 9/9/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct RootView: View {
    @EnvironmentObject var googleDelegate: GoogleDelegate
    @EnvironmentObject var screenCoordinator: ScreenCoordinator

    var body: some View {
        NavigationView {
            if !UserDefaults.standard.bool(forKey: "onboardingComplete") {
                PhoneNumberView().environmentObject(googleDelegate).environmentObject(screenCoordinator)
            } else {
                HomeView().environmentObject(googleDelegate).environmentObject(screenCoordinator)
            }
        }
        .hideNavigationBar()
        .onAppear() {
            self.checkStatic()
        }
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

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
