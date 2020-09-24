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

struct ReminderProfile: Hashable, Identifiable, Codable {
    var id: String = "1"
    var name: String
    var emoji: String
    var messaged: Bool
    var frequency: String
}

struct OskiProfile: Hashable, Codable {
    var health: String
    var image: String
    var score: Int
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

struct Avatar: Hashable, Codable {
    var name: String = ""
    var icon: String = ""
    var tags: String = ""
}


struct Assignments: Hashable, Identifiable, Codable {
    var id: String = "1"
    var classID: String = "1"
    var name: String
    var averageTime: String = "0"
}

struct Problems: Hashable, Identifiable, Codable {
    var id: String = "1"
    var classID: String = "1"
    var assignmentID: String = "1"
    var name: String
    var averageTime: String
    var votes: [Int]
    var votePercentages: [Int]
    var userVote: Int
}

struct Lectures: Hashable, Identifiable, Codable {
    var id: String = "1"
    var classID: String = "1"
    var name: String
    var polls: [[Int]]
    var maxVotes: [String]
    var votePercentages: [[Int]]
    var userVote: [Int]
}

struct Broadcaster: Hashable, Identifiable, Codable {
    var id: String = "1"
    var classID: String = "1"
    var assignmentID: String = "1"
    var name: String
    var icon: String
    var tags: String
}



