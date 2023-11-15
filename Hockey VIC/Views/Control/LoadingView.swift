//
//  LoadingView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 14/11/2023.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            Text("Loading...")
                .font(.largeTitle)
                .foregroundStyle(Color(.gray))
        }
    }
}

#Preview {
    LoadingView()
}
