//
//  HighlightSection.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 17/11/2023.
//

import SwiftUI

struct HighlightSection: View {
    var title: String
    var body: some View {
        HStack {
            Spacer()
            Text(title)
//                .foregroundStyle(Color("DefaultColor"))
//                .foregroundStyle(Color.gray)
                .foregroundStyle(Color("AccentColor"))
//                .font(.subheadline)
            Spacer()
        }
        .frame(height: 5)
    }
}
#Preview {
    HighlightSection(title: "asdad")
}
