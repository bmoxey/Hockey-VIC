//
//  DetailRoundView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 15/11/2023.
//

import SwiftUI

struct DetailRoundView: View {
    var myTeam: String
    var myRound: Round
    var body: some View {
        VStack {
//            Text("\(myRound.venue)")
//                .font(.footnote)
//                .foregroundStyle(Color.gray)
//                .padding(.bottom, -8)
            if myRound.message != "" {
                Text(myRound.message)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            HStack {
                Image(ShortClubName(fullName: myRound.homeTeam))
                    .resizable()
                    .frame(width: 60, height: 60)
                Text(myRound.homeTeam)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .frame(width: 160)
                    .fontWeight(myRound.homeTeam == myTeam ? .bold : .regular)
                    .foregroundStyle(Color(myRound.homeTeam == myTeam ? Color("AccentColor") : .default))
                if myRound.result != "No Data" {
                    Text("\(myRound.homeGoals)")
                        .font(.largeTitle)
                        .frame(width: 60, height: 45)
                        .background(myRound.homeTeam == myTeam ? BarBackground(result: myRound.result) : Color(.clear))
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            Text("vs")
                .padding(.all, -12)
            HStack {
                Image(ShortClubName(fullName: myRound.awayTeam))
                    .resizable()
                    .frame(width: 60, height: 60)
                Text(myRound.awayTeam)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .frame(width: 160)
                    .fontWeight(myRound.awayTeam == myTeam ? .bold : .regular)
                    .foregroundStyle(Color(myRound.awayTeam == myTeam ? Color("AccentColor") : .default))
                if myRound.result != "No Data" {
                    Text("\(myRound.awayGoals)")
                        .font(.largeTitle)
                        .frame(width: 60, height: 45)
                    
                        .background(myRound.awayTeam == myTeam ? BarBackground(result: myRound.result) : Color(.clear))
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

#Preview {
    DetailRoundView(myTeam: "MHSOB", myRound: Round())
}
