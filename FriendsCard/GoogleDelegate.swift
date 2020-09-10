//
//  GoogleDelegate.swift
//  FriendsCard
//
//  Created by Shalin on 8/28/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import GoogleSignIn
import Alamofire

class GoogleDelegate: NSObject, GIDSignInDelegate, ObservableObject {
    
    var clientID = "34431726447-bml0p59f5uev4mhl61dtsjd8cge7hhrt.apps.googleusercontent.com"
    var serverClientID = "34431726447-htsbgcpttuj8ou690s391dfm4sssf4js.apps.googleusercontent.com"
    var scopes = ["https://www.googleapis.com/auth/calendar"]

    @Published var signedIn: Bool = false
        
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        
        // If the previous `error` is null, then the sign-in was succesful
        print("Successful sign-in!")
        print("Authcode is : \(String(describing: user.serverAuthCode))")
        print("User's name is : \(String(describing: user.profile.name))")
        UserDefaults.standard.set(user.profile.name ?? "", forKey: "fullName")
        UserDefaults.standard.set(user.serverAuthCode ?? "", forKey: "authorizationCode")
        if !UserDefaults.standard.bool(forKey: "card1PermissionsComplete") && !UserDefaults.standard.bool(forKey: "calendarAllowed") {
            self.fetchRefreshToken(code: user.serverAuthCode)
        }
        
        UserDefaults.standard.set(true, forKey: "calendarAllowed")
        self.signedIn = true
        print(self.signedIn)
    }
    
    func fetchRefreshToken(code: String) {
        let parameters: Parameters = ["client_id": "34431726447-htsbgcpttuj8ou690s391dfm4sssf4js.apps.googleusercontent.com", "code": code, "client_secret": "zuUDbMhRZ-hHDSdM_lo3n0_Q", "grant_type": "authorization_code"]
        
        AF.request("https://oauth2.googleapis.com/token", method: .post, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success( _):
                if let json = response.value as? [String: Any] {
//                    print("JSON: \(json)") // serialized json response
//                    print("self.refresh_token", json["refresh_token"] as? String)
                    print("User's refresh token is : \(String(describing: json["refresh_token"] as? String))")
                    UserDefaults.standard.set(json["refresh_token"] as? String ?? "", forKey: "refreshToken")
                }
            case .failure( _):
                print("ERR OR")
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    // wait a couple secs then try again
                    self.fetchRefreshToken(code: code)
                }
            }
        }
    }

    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {

    }

}
