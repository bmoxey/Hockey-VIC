//
//  GetRoundData.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 15/11/2023.
//

import Foundation

func GetRoundData(mycompID: String, myDivID: String, myTeamName: String, currentRound: String) -> (String, String, String, [Round], [String], String) {
    var myRound = Round(id: UUID(), roundNo: "", dateTime: "", field: "", venue: "", address: "", opponent: "", homeTeam: "", awayTeam: "", homeGoals: 0, awayGoals: 0, message: "", result: "No Data", played: "", gameID: "")
    var rounds = [Round]()
    var lines: [String] = []
    var byeTeams: [String] = []
    var errMsg = ""
    var prev = ""
    var next = ""
    var myURL = ""
    var byes = false
    var started: Bool = false
    var scores = ""
    myRound.roundNo = currentRound
    (lines, errMsg) = GetUrl(url: "https://www.hockeyvictoria.org.au/games/" + mycompID + "/&d=" + myDivID)
    for i in 0 ..< lines.count {
        if lines[i].contains("https://www.hockeyvictoria.org.au/pointscores/") { started = true }
        if lines[i].contains("https://www.hockeyvictoria.org.au/games/") {
            if started {
                let roundName = lines[i+2]
                if roundName == currentRound {
                    if lines[i-18].contains("https://www.hockeyvictoria.org.au/games/") {
                        prev = lines[i-16]
                    } else {
                        prev = ""
                    }
                    if lines[i+18].contains("https://www.hockeyvictoria.org.au/games/") {
                        next = lines[i+20]
                    } else {
                        next = ""
                    }
                    let mybit = String(lines[i]).split(separator: "\"")
                    myURL = String(mybit[1]).replacingOccurrences(of: "&amp;", with: "&")
                }
            }
        }
    }
    if myURL != "" {
        (lines, errMsg) = GetUrl(url: myURL)
        for i in 0 ..< lines.count {
            if lines[i].contains("BYEs") { byes = true }
            if lines[i].contains("col-md pb-3 pb-lg-0 text-center text-md-left") {
                myRound.dateTime = lines[i+1].trimmingCharacters(in: .whitespacesAndNewlines) + " " + lines[i+3].trimmingCharacters(in: .whitespacesAndNewlines)
                (myRound.message, myRound.played) = GetStart(inputDate: myRound.dateTime)
            }
            if lines[i].contains("https://www.hockeyvictoria.org.au/venues/") {
                myRound.venue = lines[i+1]
                myRound.field = lines[i+5]
            }
            if lines[i].contains("https://www.hockeyvictoria.org.au/teams/") {
                if byes {
                    byeTeams.append(ShortTeamName(fullName: lines[i+1]))
                } else {
                    if lines[i+8].contains("www.hockeyvictoria.org.au/teams/") {
                        myRound.homeTeam = ShortTeamName(fullName: lines[i+1])
                        scores = lines[i+5]
                    }
                    if lines[i-8].contains("www.hockeyvictoria.org.au/teams/") {
                        myRound.awayTeam = ShortTeamName(fullName: lines[i+1])
                        (myRound.homeGoals, myRound.awayGoals) = GetScores(scores: scores, seperator: "vs")
                        myRound.result = GetResult(myTeam: myTeamName, homeTeam: myRound.homeTeam, awayTeam: myRound.awayTeam, homeGoals: myRound.homeGoals, awayGoals: myRound.awayGoals)
                        if scores == "vs" {
                            if myRound.message == "" { myRound.message = "No results available."}
                            myRound.result = "No Data"
                        } else {
                            myRound.result = GetResult(myTeam: myTeamName, homeTeam: myRound.homeTeam, awayTeam: myRound.awayTeam, homeGoals: myRound.homeGoals, awayGoals: myRound.awayGoals)
                        }
                    }
                }
            }
            if lines[i].contains("https://www.hockeyvictoria.org.au/game/") {
                myRound.gameID = String(lines[i].split(separator: "/")[3])
                myRound.id = UUID()
                rounds.append(myRound)
            }
        }
    }
    
    
    return (prev, currentRound, next, rounds, byeTeams, errMsg)
}
