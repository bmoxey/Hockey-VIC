//
//  GetPlayerData.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 15/11/2023.
//

import Foundation

func GetPlayerData(allTeams: [Teams], ourCompID: String, ourTeam: String, ourTeamID: String, myURL: String) -> ( [PlayerStat], String) {
    var lines: [String] = []
    var newlines: [String] = []
    var errMsg = ""
    var playersStats: [PlayerStat] = []
    (lines, errMsg) = GetUrl(url: myURL.replacingOccurrences(of: "&amp;", with: "&"))
    for i in 0 ..< lines.count {
        if lines[i].contains("https://www.hockeyvictoria.org.au/statistics/") {
            var count = 6
            while lines[i+count].contains("option value") {
                let testCompID = String(lines[i+count].split(separator: "\"")[1])
                if testCompID != ourCompID {
                    (newlines, errMsg) = GetUrl(url: myURL.replacingOccurrences(of: "&amp;", with: "&").replacingOccurrences(of: ourCompID, with: testCompID))
                    lines = lines + newlines
                }
                count += 3
            }
        }
    }
    for i in 0 ..< lines.count {
        if lines[i].contains("https://www.hockeyvictoria.org.au/teams") {
            if lines[i-17].contains("Attended") || lines[i-17].contains("Filled in") {
                var fillin: Bool
                if lines[i-17].contains("Filled in") { fillin = true } else { fillin = false }
                let myRound = lines[i-9]
                let myDateTime = lines[i-4]
                let myTeamID = String(lines[i].split(separator: "=")[2]).trimmingCharacters(in: .punctuationCharacters)
                let filteredTeams = allTeams.filter { $0.teamID == myTeamID }
                let myGoals = Int(lines[i+6]) ?? 0
                let myGreenCards = Int(lines[i+9]) ?? 0
                let myYellowCards = Int(lines[i+12]) ?? 0
                let myRedCards = Int(lines[i+15]) ?? 0
                let myGoalie = Int(lines[i+18]) ?? 0
                if !filteredTeams.isEmpty {
                    playersStats.append(PlayerStat(roundNo: myRound, dateTime: myDateTime, teamID: myTeamID, teamName: filteredTeams[0].teamName, clubName: filteredTeams[0].clubName, divName: filteredTeams[0].divName, goals: myGoals, greenCards: myGreenCards, yellowCards: myYellowCards, redCards: myRedCards, goalie: myGoalie, fillin: fillin))
                    
                }
            }
        }
    }
    return (playersStats, errMsg)
}
