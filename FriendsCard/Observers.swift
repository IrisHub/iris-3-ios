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

struct DistantFriendProfile: Hashable, Identifiable, Codable {
    var id: String = "1"
    var name: String
    var emoji: String
    var reachedOut: Bool
}

struct LeaderboardProfile: Hashable, Identifiable, Codable {
    var id: String = "1"
    var name: String
    var score: String
    var onIris: Bool = false
}
