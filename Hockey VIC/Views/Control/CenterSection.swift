//
//  CenterSection.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 15/11/2023.
//

import SwiftUI

struct CenterSection: View {
    var title: String
    var body: some View {
        HStack {
            Spacer()
            Text(title)
                .foregroundStyle(Color("DefaultColor"))
//                .foregroundStyle(Color.gray)
//                .foregroundStyle(Color("AccentColor"))
            Spacer()
        }
    }
}

#Preview {
    CenterSection(title: "Schedule")
}
