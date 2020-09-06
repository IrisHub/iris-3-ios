//
//  Observers.swift
//  FriendsCard
//
//  Created by Shalin on 9/2/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct CloseFriendSchedule: Hashable, Identifiable, Codable {
    var id: String = "1"
    var activity: String
    var status: String
    var onIris: Bool = false
    var busy: Bool = false
}

class Observer : ObservableObject{
    @Published var friendSchedules = [CloseFriendSchedule]()
    
    init() {
        getSchedules()
    }
    
    func getSchedules() {
        let parameters = [
            "user_id": UserDefaults.standard.string(forKey: "phoneNumber"),
        ]
        let headers : HTTPHeaders = ["Content-Type": "application/json"]

        AF.request("https://7vo5tx7lgh.execute-api.us-west-1.amazonaws.com/testing/friends-get", method: .post, parameters: parameters as Parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
            print("request body: \(response.request?.httpBody)")
            do {
                print(response)
                let json = try JSON(data: response.data ?? Data())
                for (i,subJson):(String, JSON) in json {
                    let item = CloseFriendSchedule(id: i, activity: "[MDB] Interview Comm Training", status: subJson["status"].stringValue, onIris: subJson["on_iris"].boolValue, busy: subJson["busy"].boolValue)
                    self.friendSchedules.append(item)
                }
            } catch {
                print("error")
            }
        }
    }
}
