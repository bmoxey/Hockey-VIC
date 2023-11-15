//
//  DetailTeamView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 15/11/2023.
//

import SwiftUI

struct DetailTeamView: View {
    var team: Teams
    var body: some View {
        VStack {
            Text(team.compName)
                .font(.footnote)
                .foregroundStyle(Color(.gray))
            Text(team.clubName)
                .font(.title)
                .padding(.bottom, -12)
                .padding(.top, 4)
            HStack {
                Spacer()
                Image(team.clubName)
                    .resizable()
                    .frame(width: 45, height: 45)
                Text(team.divType.prefix(1).uppercased() + team.divType.dropFirst())
                    .font(.title)
                Spacer()
            }
            Text(team.divName)
            if team.teamName != team.clubName {
                Text("competing as \(team.teamName)")
                    .font(.footnote)
            }
        }
        .padding(.bottom, 8)
    }
}

#Preview {
    DetailTeamView(team: Teams(compName: "2023 Seniors Competition", compID: "12345", divName: "Pennant D", divID: "32134", divType: "Boys ", divLevel: "C", teamName: "Waverley", teamID: "1234", clubName: "Waverley", isCurrent: false, isUsed: false))
}
