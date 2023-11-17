//
//  NoGameView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 17/11/2023.
//

import SwiftUI

struct NoGameView: View {
    var prev: Round
    var current: Round
    var body: some View {
        let timeDifference = Int(Int(current.myDate.timeIntervalSince(prev.myDate)/24/60/60 - 3)/7)
        let range = 0..<timeDifference
        ForEach(range, id: \.self) {_ in
            HStack {
                Image("stop")
                    .resizable()
                    .frame(width: 60, height: 60)
                VStack {
                    HStack {
                        Spacer()
                        Text("No match scheduled")
                            .foregroundStyle(Color("AccentColor"))
                        Spacer()
                        Text("")
                            .frame(width: 70)
                    }
                    HStack {
                        Spacer()
                        Text("for this week.")
                            .foregroundStyle(Color("AccentColor"))
                        Spacer()
                        Text("")
                            .frame(width: 70)
                    }
                }
            }
            .padding(.horizontal, -8)
        }
    }
}
