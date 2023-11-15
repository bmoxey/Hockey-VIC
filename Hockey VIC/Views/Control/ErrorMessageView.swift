//
//  ErrorMessageView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 15/11/2023.
//

import SwiftUI

struct ErrorMessageView: View {
    var errMsg: String
    var body: some View {
        Spacer()
        Image("swearing")
            .resizable()
            .scaledToFit()
            .frame(width: 240, height: 240)
            .foregroundStyle(Color(.gray))
        Text("ERROR:")
            .font(.largeTitle)
            .foregroundStyle(Color(.red))
        Text("")
        Text(errMsg)
        Text("")
        Text("Teams database may need to be rebuilt")
            .foregroundStyle(Color(.red))
            .fontWeight(.bold)
        Spacer()
        Spacer()
    }
}

#Preview {
    ErrorMessageView(errMsg: "No data to display.")
}
