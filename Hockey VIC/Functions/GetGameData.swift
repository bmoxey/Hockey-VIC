//
//  GetGameData.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 15/11/2023.
//

import Foundation

func GetGameData(gameNumber: String, myTeam: String) -> (Round, [Player], [Player], [Round], String) {
    var lines: [String] = []
    var currentTeamName: String = ""
    var myRound: Round = Round(id: UUID(), roundNo: "",  myDate: Date(), dateTime: "", field: "", venue: "", address: "", opponent: "", homeTeam: "", awayTeam: "", homeGoals: 0, awayGoals: 0, message: "", result: "No Data", played: "", gameID: "")
    var myGame: Round = Round(id: UUID(), roundNo: "", myDate: Date(), dateTime: "", field: "", venue: "", address: "", opponent: "", homeTeam: "", awayTeam: "", homeGoals: 0, awayGoals: 0, message: "", result: "", played: "", gameID: "")
    var homePlayers: [Player] = []
    var awayPlayers: [Player] = []
    var otherGames: [Round] = []
    var errMsg = ""
    var fillins: Bool = false
    var others: Bool = false
    var score: String = ""
    var FF: Bool = false
    var FL: Bool = false
    var msg: String = ""
    (lines, errMsg) = GetUrl(url: "https://www.hockeyvictoria.org.au/game/" + gameNumber + "/")
    for i in 0 ..< lines.count {
        if lines[i].contains("Match not found.") {
            errMsg = "Match not found."
        }
        if lines[i].contains("Other matches between these teams") { others = true }
        if !others {
            if lines[i].contains("h1 class=\"h3 mb-0") {
                if lines[i+1].contains("&middot;") {
                    let mybit = String(lines[i+1]).split(separator: ";")
                    myRound.roundNo = String(mybit[mybit.count-1]).trimmingCharacters(in: .whitespacesAndNewlines)
                    if myRound.roundNo.count < 5 {
                        myRound.roundNo = String(mybit[mybit.count-2]).trimmingCharacters(in: .whitespaces).replacingOccurrences(of: " &middot", with: "")
                    }
                }
            }
            if lines[i].contains("www.hockeyvictoria.org.au/teams/") {
                if myRound.homeTeam == "" {
                    myRound.homeTeam = ShortTeamName(fullName: lines[i+1])
                } else {
                    if myRound.awayTeam == "" {
                        myRound.awayTeam = ShortTeamName(fullName: lines[i+1])
                    } else {
                        if FL { msg = lines[i+1] + " " + lines[i+5] + " " + lines[i+7] }
                        if FF { msg = lines[i+1] + " " + lines[i+5] + " " + lines[i+7] }
                        if lines[i+3].contains("win") {
                            score = lines[i+6]
                            myRound.result = "win"
                            if lines[i+8] == "FL" {
                                if ShortTeamName(fullName: lines[i+1]) == myRound.awayTeam { score = lines[i+10] }
                                FL = true
                            }
                            if lines[i+8] == "FF" {
                                if ShortTeamName(fullName: lines[i+1]) == myRound.awayTeam { score = lines[i+10] }
                                FF = true
                            }
                        }
                    }
                }
            }
            if lines[i] == "Teams drew!" { myRound.result = "Draw" ; score = lines[i+3] }
            if lines[i].contains("Results for this match are not currently available.") { myRound.result = "No Data" }
            if lines[i] == "Date &amp; time" {
                myRound.dateTime = lines[i+2].trimmingCharacters(in: .whitespacesAndNewlines)
                (myRound.message, myRound.myDate) = GetStart(inputDate: myRound.dateTime)
            }
            if lines[i] == "Venue" {
                myRound.venue = lines[i+2].trimmingCharacters(in: .whitespacesAndNewlines)
                myRound.address = lines[i+4].trimmingCharacters(in: .whitespacesAndNewlines)
            }
            if lines[i] == "Field" {
                myRound.field = lines[i+2].trimmingCharacters(in: .whitespacesAndNewlines)
                (myRound.homeGoals, myRound.awayGoals) = GetScores(scores: score, seperator: "-")
                if myRound.result == "No Data" {
                    if myRound.message == "" { myRound.message = "No results available."}
                } else {
                    (myRound.homeGoals, myRound.awayGoals) = GetScores(scores: score, seperator: "-")
                    myRound.result = GetResult(myTeam: myTeam, homeTeam: myRound.homeTeam, awayTeam: myRound.awayTeam, homeGoals: myRound.homeGoals, awayGoals: myRound.awayGoals)
                    if FL == true && myRound.result == "Loss" { myRound.result = "-FL" }
                    if FL == true && myRound.result == "Win" { myRound.result = "+FL" }
                    if FF == true && myRound.result == "Loss" { myRound.result = "-FF" }
                    if FF == true && myRound.result == "Win" { myRound.result = "+FF" }
                    if msg != "" {myRound.message = msg}
                }
            }
            if lines[i].contains("table-responsive") {
                currentTeamName = ShortTeamName(fullName: lines[i-5])
            }
            if lines[i].contains("https://www.hockeyvictoria.org.au/statistics/") {
                if lines[i-3].contains("Attended") || fillins {
                    var myName = ""
                    var surname = ""
                    var myCap = false
                    (myName, surname, myCap) = FixName(fullname: lines[i+1])
                    let myGoals = Int(lines[i+7]) ?? 0
                    let myGreen = Int(lines[i+10]) ?? 0
                    let myYellow = Int(lines[i+13]) ?? 0
                    let myRed = Int(lines[i+16]) ?? 0
                    let myGoalie = Int(lines[i+19]) ?? 0
                    var us = true
                    if currentTeamName != myTeam { us = false }
                    let games = 0
                    if myRound.homeTeam == currentTeamName {
                        homePlayers.append(Player(name: myName, numberGames: games, goals: myGoals, greenCards: myGreen, yellowCards: myYellow, redCards: myRed, goalie: myGoalie, surname: surname, captain: myCap, fillin: fillins, us: us, statsLink: ""))
                    } else {
                        awayPlayers.append(Player(name: myName, numberGames: games, goals: myGoals, greenCards: myGreen, yellowCards: myYellow, redCards: myRed, goalie: myGoalie, surname: surname, captain: myCap, fillin: fillins, us: us, statsLink: ""))
                    }
                }
                
            }
        } else {
            if lines[i].contains("Fill ins") { fillins = true }
            if lines[i].contains("col-md pb-3 pb-lg-0 text-center text-md-left") {
                myGame.roundNo = lines[i+3]
                myGame.dateTime = lines[i+7].trimmingCharacters(in: .whitespacesAndNewlines) + " " + lines[i+9].trimmingCharacters(in: .whitespacesAndNewlines)
                (myGame.message, myGame.myDate) = GetStart(inputDate: myGame.dateTime)
            }
            if lines[i].contains("https://www.hockeyvictoria.org.au/venues") {
                myGame.venue = lines[i+1]
                myGame.field = lines[i+5]
            }
            if lines[i].contains(" vs ") {
                score = lines[i]
                (myGame.homeGoals, myGame.awayGoals) = GetScores(scores: score, seperator: "vs")
            }
            if lines[i] == "vs" {
                myGame.result = "No Data"
            }
            if lines[i].contains("https://www.hockeyvictoria.org.au/teams") {
                if myGame.homeTeam == "" {
                    myGame.homeTeam = ShortTeamName(fullName: lines[i+1])
                } else {
                    myGame.awayTeam = ShortTeamName(fullName: lines[i+1])
                }
            }
            if lines[i].contains("https://www.hockeyvictoria.org.au/game/") {
                
                if myGame.homeTeam == myTeam { myGame.opponent = myGame.awayTeam }
                else {myGame.opponent = myGame.homeTeam}
                if myGame.result != "No Data" {
                    myGame.result = GetResult(myTeam: myTeam, homeTeam: myGame.homeTeam, awayTeam: myGame.awayTeam, homeGoals: myGame.homeGoals, awayGoals: myGame.awayGoals)
                }
                myGame.id = UUID()
                otherGames.append(myGame)
                myGame = Round(id: UUID(), roundNo: "", myDate: Date(), dateTime: "", field: "", venue: "", address: "", opponent: "", homeTeam: "", awayTeam: "", homeGoals: 0, awayGoals: 0, message: "", result: "", played: "", gameID: "")
            }

        }
    }
    return (myRound, homePlayers, awayPlayers, otherGames, errMsg)
}
