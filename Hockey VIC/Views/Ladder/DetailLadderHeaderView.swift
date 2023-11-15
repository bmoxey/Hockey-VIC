//
//  DetailLadderHeaderView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 15/11/2023.
//

import SwiftUI

struct DetailLadderHeaderView: View {
    var body: some View {
        HStack {
            Text("Pos")
                .font(.footnote)
                .foregroundStyle(Color(.gray))
                .frame(width: 35, alignment: .leading)
            Text("Team")
                .font(.footnote)
                .foregroundStyle(Color(.gray))
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            Text("GD")
                .font(.footnote)
                .foregroundStyle(Color(.gray))
                .frame(width: 35, alignment: .trailing)
            Text("Pts")
                .font(.footnote)
                .foregroundStyle(Color(.gray))
                .frame(width: 35, alignment: .trailing)
            Text("WR")
                .font(.footnote)
                .foregroundStyle(Color(.gray))
                .frame(width: 35, alignment: .trailing)
            Text("")
                .font(.footnote)
                .frame(width: 12)
        }
        .frame(height: 3)
    }
}

#Preview {
    DetailLadderHeaderView()
}
