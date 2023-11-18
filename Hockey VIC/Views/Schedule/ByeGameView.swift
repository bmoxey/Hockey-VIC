//
//  ByeGameView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 18/11/2023.
//

import SwiftUI

struct ByeGameView: View {
    let myTeam: String
    let round: Round
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE d MMM @ h:mm a"
        return dateFormatter.string(from: round.myDate)
    }
    var body: some View {
        VStack {
            HStack {
                Text("\(round.roundNo)")
                    .font(.footnote)
                    .foregroundStyle(Color.gray)
                    .padding(.bottom, -8)
                Text("")
                    .frame(width: 12)
            }
            HStack {
                Image("BYE")
                    .resizable()
                    .frame(width: 60, height: 60)
                VStack {
                    HStack {
                        Spacer()
                        Text("\(myTeam)")
                            .foregroundStyle(Color("AccentColor"))
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Text("has a BYE this round.")
                            .foregroundStyle(Color("AccentColor"))
                        Spacer()
                    }
                }
                Image("BYE")
                    .resizable()
                    .frame(width: 60, height: 60)
                Text("")
                    .frame(width: 20)
            }
            .padding(.horizontal, -8)
        }
    }
}

#Preview {
    ByeGameView(myTeam: "MHSOB", round: Round())
}
