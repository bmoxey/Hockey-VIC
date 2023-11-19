//
//  DetailFixtureView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 19/11/2023.
//

import SwiftUI

struct DetailFixtureView: View {
    let myTeam: String
    let round: Round
    var formattedTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: round.myDate)
    }
    var body: some View {
        let diff = Calendar.current.dateComponents([.day, .hour, .minute], from: Date.now, to: round.myDate)
        let isWithinOneWeek = Date() < round.myDate && Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date()) ?? Date() >= round.myDate
        VStack {
            HStack {
                Image(round.roundNo.contains("Grand Final") ? round.result: ShortClubName(fullName: round.opponent))
                    .resizable()
                    .frame(width: 60, height: 60)
                Text(round.result == "No Game" ? "No game this week" : "\(round.opponent)")
                    .foregroundStyle(Color("DefaultColor"))
                Spacer()
                VStack {
                    Text(round.result == "No Game" ? "" : "\(formattedTime)")
                        .foregroundStyle(Color("DefaultColor"))
                    Text("\(round.field)")
                        .foregroundStyle(Color("DefaultColor"))
                }
            }
            if round.message != "" {
                HStack {
                    Text("")
                        .frame(width: 12)
                    Spacer()
                    Text("\(round.message)")
                        .foregroundStyle(Color(.purple))
                    Spacer()
                }
                
            }
            if diff.day! >= 0 && diff.hour! >= 0 && diff.minute! >= 0 {
                HStack {
                    Text("")
                        .frame(width: 12)
                    Spacer()
                    if diff.day! == 0 {
                        Text("Starts in \(diff.hour!) hours and \(diff.minute!) minutes")
                            .foregroundStyle(Color("AccentColor"))
                    } else {
                        Text("Starts in \(diff.day!) days and \(diff.hour!) hours")
                            .foregroundStyle(isWithinOneWeek ? Color("AccentColor") :  Color(.red))
                    }
                    Spacer()
                }
            } else {
                HStack {
                    Text("")
                        .frame(width: 12)
                    HStack {
                        Spacer()
                        if round.homeGoals > 0 {
                            Text(String(repeating: "●", count: round.homeGoals))
                                .foregroundStyle(round.homeTeam == myTeam ? Color.green : Color.red)
                                .font(.system(size:20))
                                .padding(.vertical, 0)
                                .padding(.horizontal, 0)
                                .multilineTextAlignment(.trailing)
                                .lineLimit(nil)
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(.leading, -8)
                    if round.result == "No Data" || round.result == "BYE" || round.result == "No Game" {
                        Text(" \(round.result) ")
                            .foregroundStyle(Color(.white))
                            .fontWeight(.bold)
                            .background(BarBackground(result: round.result))
                            .frame(minWidth: 120)
                    } else {
                        Text(" \(round.homeGoals) - \(round.awayGoals) \(round.result) ")
                            .foregroundStyle(Color(Color.black))
                            .fontWeight(.bold)
                            .background(BarBackground(result: round.result))
                            .frame(minWidth: 120)
                    }
                    HStack {
                        if round.awayGoals > 0 {
                            Text(String(repeating: "●", count: round.awayGoals))
                                .foregroundStyle(round.awayTeam == myTeam ? Color.green : Color.red)
                                .font(.system(size:20))
                                .padding(.vertical, 0)
                                .padding(.horizontal, 0)
                                .multilineTextAlignment(.leading)
                                .lineLimit(nil)
                        }
                        Spacer()
                    }
                    .padding(.trailing, -8)
                    .frame(minWidth: 0, maxWidth: .infinity)
                }
            }
        }
//        .padding(.horizontal, -8)
    }
}


#Preview {
    DetailFixtureView(myTeam: "MHSOB", round: Round())
}
