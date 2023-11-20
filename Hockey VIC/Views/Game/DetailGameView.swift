//
//  DetailGameView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 15/11/2023.
//

import SwiftUI

struct DetailGameView: View {
    var round: Round
    var myTeam: String
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE d MMM @ h:mm a"
        return dateFormatter.string(from: round.myDate)
    }
    var body: some View {
        let diff = Calendar.current.dateComponents([.day, .hour, .minute], from: Date.now, to: round.myDate)
        let isWithinOneWeek = Date() < round.myDate && Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date()) ?? Date() >= round.myDate
        Section(header: CenterSection(title: "Game Details")) {
            VStack {
                Text(formattedDate)
                    .font(.footnote)
                    .foregroundStyle(isWithinOneWeek ? Color("DefaultColor") : Color.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
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
                    if round.message != "" {
                        Text(round.message)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                if round.roundNo.contains("Grand Final") && round.result != "" {
                    Image(round.result)
                        .resizable()
                        .frame(width: 120, height: 120)
                        .padding(.all, -20)
                }
                HStack {
                    Image(ShortClubName(fullName: round.homeTeam))
                        .resizable()
                        .frame(width: 120, height: 120)
                    Text("VS")
                    Image(ShortClubName(fullName: round.awayTeam))
                        .resizable()
                        .frame(width: 120, height: 120)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                VStack {
                    if round.result != "No Data" {
                        HStack {
                            Text("\(round.homeGoals)")
                                .font(.largeTitle)
                                .frame(width: 140, height: 50)
                                .background(round.homeTeam == myTeam ? BarBackground(result: round.result) : Color(.clear))
                            Text("\(round.awayGoals)")
                                .font(.largeTitle)
                                .frame(width: 140, height: 50)
                                .background(round.awayTeam == myTeam ? BarBackground(result: round.result) : Color(.clear))
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    HStack {
                        Text(round.homeTeam)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .frame(width: 140)
                            .fontWeight(round.homeTeam == myTeam ? .bold : .regular)
                            .foregroundStyle(Color(round.homeTeam == myTeam ? "AccentColor" : "DefaultColor"))
                        Text(round.awayTeam)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .frame(width: 140)
                            .fontWeight(round.awayTeam == myTeam ? .bold : .regular)
                            .foregroundStyle(Color(round.awayTeam == myTeam ? "AccentColor" : "DefaultColor"))
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
    }
}

#Preview {
    DetailGameView(round: Round(), myTeam: "MHSOB")
}
