//
//  Structs.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 14/11/2023.
//

import Foundation
import SwiftUI
import Combine

class SharedData: ObservableObject {
    @Published var activeTabIndex: Int = 0
    @Published var refreshSchedule: Bool = false
    @Published var refreshLadder: Bool = false
    @Published var refreshRound: Bool = false
    @Published var refreshStats: Bool = false
    @Published var refreshTeams: Bool = false
    @Published var newTeamID: String = ""
    @Published var currentRound: String = "Round 1"
}

struct Team : Identifiable {
    var id = UUID()
    var compName: String
    var compID: String
    var divName: String
    var divID: String
    var teamName: String
    var teamID: String
    var clubName: String
}

struct Rounds: Codable {
    var rounds: [Round]
}

struct Round: Codable {
    var id: UUID
    var roundNo: String
    var myDate: Date
    var dateTime: String
    var field: String
    var venue: String
    var address: String
    var opponent: String
    var homeTeam: String
    var awayTeam: String
    var homeGoals: Int
    var awayGoals: Int
    var message: String
    var result: String
    var played: String
    var gameID: String
    
    init() {
        self.id = UUID()
        self.roundNo = ""
        self.myDate = Date()
        self.dateTime = ""
        self.field = ""
        self.venue = ""
        self.address = ""
        self.opponent = ""
        self.homeTeam = ""
        self.awayTeam = ""
        self.homeGoals = 0
        self.awayGoals = 0
        self.message = ""
        self.result = ""
        self.played = ""
        self.gameID = ""
    }
}

struct Player: Identifiable {
    var id = UUID()
    var name: String
    var numberGames: Int
    var goals: Int
    var greenCards: Int
    var yellowCards: Int
    var redCards: Int
    var goalie: Int
    var surname: String
    var captain: Bool
    var fillin: Bool
    var us: Bool
    var statsLink: String
}

struct Ladder: Codable {
    var ladder: [LadderItem]
}

struct LadderItem: Codable {
    var id: UUID
    var pos: Int
    var teamName: String
    var compID: String
    var teamID: String
    var played: Int
    var wins: Int
    var draws: Int
    var losses: Int
    var forfeits: Int
    var byes: Int
    var scoreFor: Int
    var scoreAgainst: Int
    var diff: Int
    var points: Int
    var winRatio: Int
}

struct PlayerStat: Identifiable {
    var id = UUID()
    var roundNo: String
    var dateTime: String
    var teamID: String
    var teamName: String
    var clubName: String
    var divName: String
    var goals: Int
    var greenCards: Int
    var yellowCards: Int
    var redCards: Int
    var goalie: Int
    var fillin: Bool
}
