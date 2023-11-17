//
//  GetSchedData.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 15/11/2023.
//

import Foundation

func GetSchedData(mycompID: String, myTeamID: String, myTeamName: String) -> ([Round], String) {
    var myRound = Round(id: UUID(), roundNo: "", myDate: Date(), dateTime: "", field: "", venue: "", address: "", opponent: "", homeTeam: "", awayTeam: "", homeGoals: 0, awayGoals: 0, message: "", result: "No Data", played: "", gameID: "")
    var rounds = [Round]()
    var lines: [String] = []
    var errMsg = ""
    var FL = false
    var FF = false
    var score = ""
    (lines, errMsg) = GetUrl(url: "https://www.hockeyvictoria.org.au/teams/" + mycompID + "/&t=" + myTeamID)
    for i in 0 ..< lines.count {
        if lines[i].contains("There are no draws to show") {
            errMsg = "There are no draws to show"
        }
        if lines[i].contains("col-md pb-3 pb-lg-0 text-center text-md-left") {
            myRound.roundNo = lines[i+3]
            myRound.dateTime = lines[i+6].trimmingCharacters(in: .whitespacesAndNewlines) + " " + lines[i+8].trimmingCharacters(in: .whitespacesAndNewlines)
            (myRound.message, myRound.myDate) = GetStart(inputDate: myRound.dateTime)
        }
        if lines[i].contains("https://www.hockeyvictoria.org.au/venues") {
            myRound.venue = lines[i+1]
            myRound.field = lines[i+5]
        }
        if lines[i].contains("have a BYE.") {
            myRound.venue = "BYE"
            myRound.field = "BYE"
            myRound.opponent = "BYE"
            myRound.result = "BYE"
            myRound.homeGoals = 0
            myRound.awayGoals = 0
        }
        if lines[i].contains("https://www.hockeyvictoria.org.au/teams/") {
            myRound.opponent = ShortTeamName(fullName: lines[i+1])
            score = lines[i+4]
            myRound.result = lines[i+8]
            if lines[i+6] == "FF" || lines[i+6] == "FL" {
                score = lines[i+8]
                myRound.result = lines[i+12]
            }
            (myRound.homeGoals, myRound.awayGoals) = GetScores(scores: score, seperator: "-")
            if myRound.result == "/div" { myRound.result = "No Data"}
        }
        if lines[i].contains("badge badge-danger") && lines[i+1] == "FF" {FF = true}
        if lines[i].contains("badge badge-warning") && lines[i+1] == "FL" {FL = true}
        if lines[i].contains("https://www.hockeyvictoria.org.au/game/") {
            (myRound.homeTeam, myRound.awayTeam) = GetHomeTeam(result: myRound.result, homeGoals: myRound.homeGoals, awayGoals: myRound.awayGoals, myTeam: myTeamName, opponent: myRound.opponent, rounds: rounds, venue: myRound.venue)
            if FL == true && myRound.result == "Loss" { myRound.result = "-FL" }
            if FL == true && myRound.result == "Win" { myRound.result = "+FL" }
            if FF == true && myRound.result == "Loss" { myRound.result = "-FF" }
            if FF == true && myRound.result == "Win" { myRound.result = "+FF" }
            myRound.gameID = String(String(lines[i]).split(separator: "/")[3])
            myRound.id = UUID()
            rounds.append(myRound)
            myRound = Round(id: UUID(), roundNo: "",  myDate: Date(), dateTime: "", field: "", venue: "", address: "", opponent: "", homeTeam: "", awayTeam: "", homeGoals: 0, awayGoals: 0, message: "", result: "No Data", played: "", gameID: "")
            FL = false
            FF = false
        }
    }
    return (rounds, errMsg)
}
