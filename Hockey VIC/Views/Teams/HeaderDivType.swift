//
//  HeaderDivType.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 16/11/2023.
//

import SwiftUI

struct HeaderDivType: View {
    var divType: String
    var body: some View {
        HStack {
            Spacer()
            Text(divType).font(.largeTitle)
                .foregroundStyle(Color("DefaultColor"))
            Spacer()
        }
    }
}

#Preview {
    HeaderDivType(divType: "Men's 👨🏻")
}
