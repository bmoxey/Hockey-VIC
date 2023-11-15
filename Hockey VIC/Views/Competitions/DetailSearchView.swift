//
//  DetailSearchView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 14/11/2023.
//

import SwiftUI

struct DetailSearchView: View {
    var searchComp: String
    var searchDiv: String
    var teamsFound: Int
    var body: some View {
        VStack {
            Spacer()
            let searchImage = "search" + String(teamsFound / 100)
            Image(searchImage)
                .resizable()
                .scaledToFit()
                .frame(width: 240, height: 240)
            Text("")
            Text("Searching ...")
                .font(.largeTitle)
            Text("")
            Text(searchComp)
            Text(searchDiv)
            Text("Teams found: \(teamsFound)")
            Spacer()
            Spacer()
        }
    }
}

#Preview {
    DetailSearchView(searchComp: "2023 Winter Competition", searchDiv: "Mens Premier League", teamsFound: 634)
}
