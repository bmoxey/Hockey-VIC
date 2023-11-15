//
//  DetailLadderView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 15/11/2023.
//

import SwiftUI

struct DetailLadderView: View {
    let myTeam: String
    let item: LadderItem
    var body: some View {
        HStack {
         Text("\(item.pos)")
             .frame(width: 20, alignment: .leading)
             .font(.footnote)
             .foregroundStyle(Color(item.teamName == myTeam ? "AccentColor" : "DefaultColor"))
         Image(ShortClubName(fullName: item.teamName))
             .resizable()
             .frame(width: 45, height: 45)
             .padding(.vertical, -4)
         Text(item.teamName)
             .multilineTextAlignment(.leading)
             .lineLimit(nil)
             .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
             .fontWeight(item.teamName == myTeam ? .bold : .regular)
             .foregroundStyle(Color(item.teamName == myTeam ? "AccentColor" : "DefaultColor"))
         Text("\(item.diff)")
             .frame(width: 35, alignment: .trailing)
             .foregroundStyle(Color(item.teamName == myTeam ? "AccentColor" : "DefaultColor"))
         Text("\(item.points)")
             .frame(width: 35, alignment: .trailing)
             .foregroundStyle(Color(item.teamName == myTeam ? "AccentColor" : "DefaultColor"))
         Text("\(item.winRatio)")
             .frame(width: 35, alignment: .trailing)
             .foregroundStyle(Color(item.teamName == myTeam ? "AccentColor" : "DefaultColor"))
        }
    }
}

#Preview {
    DetailLadderView(myTeam: "MHSOB", item: LadderItem(id: UUID(), pos: 1, teamName: "MHSOBHC", compID: "123123", teamID: "12312", played: 6, wins: 3, draws: 1, losses: 2, forfeits: 0, byes: 0, scoreFor: 33, scoreAgainst: 21, diff: 12, points: 10, winRatio: 65))
}
