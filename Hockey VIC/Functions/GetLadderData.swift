//
//  GetLadderData.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 18/11/2023.
//

import Foundation

func GetLadderData(myCompID: String, myDivID: String, myTeam: String) -> ([LadderItem], String) {
    var myLadder = LadderItem()
    var ladder = [LadderItem]()
    var lines: [String] = []
    var errMsg = ""
    var pos = 0
    (lines, errMsg) = GetUrl(url: "https://www.hockeyvictoria.org.au/pointscores/" + myCompID + "/&d=" + myDivID)
    for i in 0 ..< lines.count {
        if lines[i].contains("This ladder is not currently available") {
            errMsg = "This ladder is not currently available"
        }
        if lines[i].contains("hockeyvictoria.org.au/teams/") {
            pos += 1
            myLadder.teamID = String(String(lines[i]).split(separator: "=")[2]).trimmingCharacters(in: .punctuationCharacters)
            myLadder.compID = String(String(lines[i]).split(separator: "/")[3])
            myLadder.teamName = ShortTeamName(fullName: lines[i+1])
            myLadder.played = Int(lines[i+7]) ?? 0
            myLadder.wins = Int(lines[i+10]) ?? 0
            myLadder.draws = Int(lines[i+13]) ?? 0
            myLadder.losses = Int(lines[i+16]) ?? 0
            myLadder.forfeits = Int(lines[i+19]) ?? 0
            myLadder.byes = Int(lines[i+22]) ?? 0
            myLadder.scoreFor = Int(lines[i+25]) ?? 0
            myLadder.scoreAgainst = Int(lines[i+28]) ?? 0
            myLadder.diff = Int(lines[i+31]) ?? 0
            myLadder.points = Int(lines[i+34]) ?? 0
            myLadder.winRatio = Int(lines[i+38]) ?? 0
            myLadder.pos = pos
            myLadder.id = UUID()
            ladder.append(myLadder)
        }
    }
    return (ladder, errMsg)
}
