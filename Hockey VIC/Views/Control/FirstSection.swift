//
//  FixtureSection.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 19/11/2023.
//

import SwiftUI

struct FirstSection: View {
    var index: Int
    var header: String
    var body: some View {
        if index == 0 {
            CenterSection(title: header)
        }
    }
}

#Preview {
    FirstSection(index: 1, header: "Ladder")
}
