//
//  NoGameView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 17/11/2023.
//

import SwiftUI

struct NoGameView: View {
    let myTeam: String
    var prev: Round
    var current: Round
    var body: some View {
        let timeDifference = Int(Int(current.myDate.timeIntervalSince(prev.myDate)/24/60/60 - 3)/7)
        let range = 0..<timeDifference
        ForEach(range, id: \.self) {_ in
            VStack {
                HStack {
                    Image("NoGame")
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
                            Text("has no game this week.")
                                .foregroundStyle(Color("AccentColor"))
                            Spacer()
                        }
                    }
                    Image("NoGame")
                        .resizable()
                        .frame(width: 60, height: 60)
                }
                .padding(.horizontal, -8)
            }
        }
    }
}
