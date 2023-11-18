//
//  ViewModel.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 17/11/2023.
//

import Foundation

class ViewModel: ObservableObject {
    @Published var rounds = [Round]()
    @Published var round = Round()
    @Published var homePlayers = [Player]()
    @Published var awayPlayers = [Player]()
    @Published var haveData = false
    @Published var errMsg = ""
    
    @MainActor func loadSchedData(currentTeam: Teams) async {
        haveData = false
        (rounds, errMsg) = GetSchedData(mycompID: currentTeam.compID, myTeamID: currentTeam.teamID, myTeamName: currentTeam.teamName)
        haveData = true
    }
    
    @MainActor func loadGameData(gameID: String, myTeam: String) async {
        haveData = false
        (round, homePlayers, awayPlayers, rounds, errMsg) = GetGameData(gameID: gameID, myTeam: myTeam)
        haveData = true
    }
}
