//
//  NoNetworkView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 14/11/2023.
//

import SwiftUI

struct NoNetworkView: View {
    var body: some View {
        VStack {
            Spacer()
            Image("dontknow")
                .resizable()
                .scaledToFit()
                .frame(width: 240, height: 240)
            Spacer()
            Text("No Network Detected")
                .font(.largeTitle)
            Spacer()
            Image(systemName: "wifi.slash")
                .foregroundStyle(Color(.red))
                .font(.system(size: 128, weight: .bold))
            Spacer()
            Spacer()
        }
    }
}

#Preview {
    NoNetworkView()
}
