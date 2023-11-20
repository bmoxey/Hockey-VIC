//
//  HighlightSection.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 17/11/2023.
//

import SwiftUI

struct HighlightSection: View {
    var leftTitle: String
    var rightTitle: String
    var body: some View {
        HStack {
            Text(leftTitle)
//                .foregroundStyle(Color("AccentColor"))
            Spacer()
            Text(rightTitle)
//                .foregroundStyle(Color("AccentColor"))

        }
        .frame(height: 5)
    }
}
#Preview {
    HighlightSection(leftTitle: "asdad", rightTitle: "ASD")
}
