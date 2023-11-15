//
//  DetailScheduleView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 15/11/2023.
//

import SwiftUI

struct DetailScheduleView: View {
    let myTeam: String
    let round: Round
    var body: some View {
        VStack {
            Text("\(round.roundNo)")
                .font(.footnote)
                .foregroundStyle(Color.gray)
                .padding(.bottom, -8)
            HStack {
                Image(ShortClubName(fullName: round.opponent))
                    .resizable()
                    .frame(width: 60, height: 60)
                VStack {
                    HStack {
                        Text("\(round.dateTime)")
                            .foregroundStyle(Color(round.result == "BYE" ? "AccentColor" : "DefaultColor"))
                        Spacer()
                    }
                    HStack {
                        Text("\(round.opponent) @ \(round.field)")
                            .foregroundStyle(Color(round.result == "BYE" ? "AccentColor" : "DefaultColor"))
                        Spacer()
                    }
                }
            }
            if round.message != "" {
                Text("\(round.message)")
                    .foregroundStyle(Color(.red))
            }
            if round.result != "No Data" || round.message == "" {
                HStack {
                    HStack {
                        Spacer()
                        Text(String(repeating: "●", count: round.homeGoals))
                            .foregroundStyle(round.homeTeam == myTeam ? Color.green : Color.red)
                            .font(.system(size:20))
                            .padding(.vertical, 0)
                            .padding(.horizontal, 0)
                            .multilineTextAlignment(.trailing)
                            .lineLimit(nil)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(.leading, -8)
                    if round.result == "BYE" || round.result == "No Data" {
                        Text(" \(round.result) ")
                            .foregroundStyle(Color(.white))
                            .fontWeight(.bold)
                            .background(BarBackground(result: round.result))
                    } else {
                        Text(" \(round.homeGoals) - \(round.awayGoals) \(round.result) ")
                            .foregroundStyle(Color(Color.black))
                            .fontWeight(.bold)
                            .background(BarBackground(result: round.result))
                    }
                    HStack {
                        Text(String(repeating: "●", count: round.awayGoals))
                            .foregroundStyle(round.awayTeam == myTeam ? Color.green : Color.red)
                            .font(.system(size:20))
                            .padding(.vertical, 0)
                            .padding(.horizontal, 0)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                        Spacer()
                    }
                    .padding(.trailing, -8)
                    .frame(minWidth: 0, maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal, -8)
    }
}

#Preview {
    DetailScheduleView(myTeam: "MHSOB", round: Round(id: UUID(), roundNo: "Round 1", dateTime: "Sat 15 Apr 2023 @ 14:00", field: "MBT", venue: "Melbourne Hockey Field", address: "21 Smith St", opponent: "Hawthorn", homeTeam: "Hawthorn", awayTeam: "MHSOB", homeGoals: 6, awayGoals: 11, message: "", result: "Win", played: "Completed", gameID: "1439971"))
}
