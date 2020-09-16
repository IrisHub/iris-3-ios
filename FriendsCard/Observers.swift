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

struct Contact: Hashable, Identifiable, Codable {
    var id: String = "1"
    var name: String
    var phoneNum: String
    var emoji: String
    var selected: Bool = false
}

struct CloseFriendSchedule: Hashable, Identifiable, Codable {
    var id: String = "1"
    var name: String
    var activity: String
    var status: String
    var onIris: Bool = false
    var busy: Bool = false
}

struct DistantFriendProfile: Hashable, Identifiable, Codable {
    var id: String = "1"
    var name: String
    var emoji: String
    var messaged: Bool
}

struct LeaderboardProfile: Hashable, Identifiable, Codable {
    var id: String = "1"
    var name: String
    var score: String
    var onIris: Bool = false
}

struct Poll: Hashable, Identifiable, Codable {
    var id: String = "1"
    var name: String
    var emoji: String
}

struct Classes: Hashable, Identifiable, Codable {
    var id: String = "1"
    var name: String
    var selected: Bool = false
}

struct Assignments: Hashable, Identifiable, Codable {
    var id: String = "1"
    var classID: String = "1"
    var name: String
    var averageTime: String
}

struct Problems: Hashable, Identifiable, Codable {
    var id: String = "1"
    var classID: String = "1"
    var assignmentID: String = "1"
    var name: String
    var averageTime: String
    var votes: [Int]
}

struct Lectures: Hashable, Identifiable, Codable {
    var id: String = "1"
    var classID: String = "1"
    var name: String
    var averageTime: String
    var polls: [[Int]]
    var maxVotes: [Int]
    var votePercentages: [Int]
    var userVote: [Int]
}


