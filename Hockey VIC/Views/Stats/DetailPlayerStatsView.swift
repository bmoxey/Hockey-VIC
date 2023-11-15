//
//  DetailPlayerStatsView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 15/11/2023.
//

import SwiftUI

struct DetailPlayerStatsView: View {
    var playerStat: PlayerStat
    var body: some View {
        HStack {
             if playerStat.fillin {
                 Image(systemName: "person.fill.badge.plus")
                     .foregroundColor(Color("AccentColor"))
             }
             Image(playerStat.clubName)
                 .resizable()
                 .frame(width: 45, height: 45)
             VStack(alignment: .leading) {
                 Text("\(playerStat.dateTime)")
                     .font(.footnote)
                     .foregroundStyle(Color(.gray))
                 Text("\(playerStat.roundNo) - \(playerStat.teamName)")
             }
             if playerStat.goalie == 1 {
                 Text(" (GK)")
             }
             if playerStat.greenCards > 0 {
                 Text(String(repeating: "▲", count: playerStat.greenCards))
                     .font(.system(size:24))
                     .foregroundStyle(Color.green)
                     .padding(.vertical, 0)
                     .padding(.horizontal, 0)
             }
             if playerStat.yellowCards > 0 {
                 Text(String(repeating: "■", count: playerStat.yellowCards))
                     .font(.system(size:24))
                     .foregroundStyle(Color.yellow)
                     .padding(.vertical, 0)
                     .padding(.horizontal, 0)
             }
             if playerStat.redCards > 0 {
                 Text(String(repeating: "●", count: playerStat.redCards))
                 .font(.system(size:24))
                 .foregroundStyle(Color.red)
                 .padding(.vertical, 0)
                 .padding(.horizontal, 0)
             }
             Spacer()
             if playerStat.goals > 0 {
                 Text(String(repeating: "●", count: playerStat.goals))
                 .font(.system(size:20))
                 .foregroundStyle(Color.green)
                 .padding(.vertical, 0)
                 .padding(.horizontal, 0)
                 .multilineTextAlignment(.trailing)
                 .lineLimit(nil)
             }
         }
         .padding(.horizontal, -8)
     }
}

#Preview {
    DetailPlayerStatsView(playerStat: PlayerStat(roundNo: "Round 1", dateTime: "Sat 15 Apr 2023 15:30", teamID: "123", teamName: "Waverley Hockey Club", clubName: "Waverley", divName: "State league 1", goals: 2, greenCards: 1, yellowCards: 1, redCards: 0, goalie: 0, fillin: false))
}
