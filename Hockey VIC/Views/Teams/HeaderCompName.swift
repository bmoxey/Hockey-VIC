//
//  HeaderCompName.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 16/11/2023.
//

import SwiftUI

struct HeaderCompName: View {
    var compName: String
    var body: some View {
        HStack {
            Spacer()
            Text(compName)
                .foregroundStyle(Color.gray)
                .font(.footnote)
            Spacer()
        }.frame(height: 5)
    }
}

#Preview {
    HeaderCompName(compName: "2023 Term 4 Summer")
}
