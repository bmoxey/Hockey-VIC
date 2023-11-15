//
//  GetStatsData.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 15/11/2023.
//

import Foundation

func GetStatsData(myCompID: String, myTeamID: String) -> ( [Player], String) {
    var lines: [String] = []
    var errMsg = ""
    var fillins = false
    var players: [Player] = []
    (lines, errMsg) = GetUrl(url: "https://www.hockeyvictoria.org.au/teams-stats/" + myCompID + "/&t=" + myTeamID)
    for i in 0 ..< lines.count {
         if lines[i].contains("There are no records to show.") {
             errMsg = "There are no records to show."
         }
         if lines[i].contains("Fill ins") { fillins = true }
         if lines[i].contains("https://www.hockeyvictoria.org.au/statistics/") {
             let statsLink = String(lines[i].split(separator: "\"")[1])
             var myName = ""
             var surname = ""
             var myCap = false
             (myName, surname, myCap) = FixName(fullname: lines[i+1].capitalized.trimmingCharacters(in: CharacterSet.letters.inverted))
             let myGames = Int(lines[i+6]) ?? 0
             let myGoals = Int(lines[i+10]) ?? 0
             let myGreen = Int(lines[i+14]) ?? 0
             let myYellow = Int(lines[i+18]) ?? 0
             let myRed = Int(lines[i+22]) ?? 0
             let myGoalie = Int(lines[i+26]) ?? 0
             players.append(Player(name: myName, numberGames: myGames, goals: myGoals, greenCards: myGreen, yellowCards: myYellow, redCards: myRed, goalie: myGoalie, surname: surname, captain: myCap, fillin: fillins, us: true, statsLink: statsLink))
         }
     }


    return(players, errMsg)
}
