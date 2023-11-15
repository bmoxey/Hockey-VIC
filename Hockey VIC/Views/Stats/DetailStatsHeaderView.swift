//
//  DetailStatsHeaderView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 15/11/2023.
//

import SwiftUI

struct DetailStatsHeaderView: View {
    @Binding var sortMode: Int
    @Binding var sortAscending: Bool
    @Binding var sortedByName: Bool
    @Binding var sortedByNameValue: KeyPath<Player, String>
    @Binding var sortedByValue: KeyPath<Player, Int>?
    var body: some View {
        HStack {
            Button(action: {
                if sortMode == 1 {
                    sortAscending.toggle()
                } else {
                    sortedByNameValue = \Player.name
                    sortedByName = true
                    sortAscending = true
                    sortedByValue = nil
                    sortMode = 1
                }
            }) {
                Text(sortMode == 1 ? sortAscending ? "First▼" : "First▲" : "First")
                    .font(.footnote)
                    .padding(.all, 0)
                    .foregroundStyle(Color(.gray))
            }
            .buttonStyle(BorderlessButtonStyle())
            Button(action: {
                if sortMode == 2 {
                    sortAscending.toggle()
                } else {
                    sortedByNameValue = \Player.surname
                    sortedByName = true
                    sortAscending = true
                    sortedByValue = nil
                    sortMode = 2
                }
            }) {
                Text(sortMode == 2 ? sortAscending ? "Surname▼" : "Surname▲" : "Surname")
                    .font(.footnote)
                    .padding(.all, 0)
                    .foregroundStyle(Color(.gray))
            }
            .buttonStyle(BorderlessButtonStyle())
            Spacer()
            Button(action: {
                if sortMode == 3 {
                    sortAscending.toggle()
                } else {
                    sortedByValue = \Player.goals
                    sortedByName = false
                    sortAscending = false
                    sortMode = 3
                }
            }) {
                Text(sortMode == 3 ? sortAscending ? "Goals▲" :"Goals▼" : "Goals" )
                    .font(.footnote)
                    .foregroundStyle(Color(.gray))
            }
            .buttonStyle(BorderlessButtonStyle())
            Button(action: {
                if sortMode == 4 {
                    sortAscending.toggle()
                } else {
                    sortedByValue = \Player.numberGames
                    sortedByName = false
                    sortAscending = false
                    sortMode = 4
                }
            }) {
                Text(sortMode == 4 ? sortAscending ? "Games▲" :"Games▼" : "Games" )
                    .font(.footnote)
                    .foregroundStyle(Color(.gray))
            }
            .buttonStyle(BorderlessButtonStyle())
        }.frame(height: 3)
    }
}

#Preview {
    DetailStatsHeaderView(sortMode: .constant(2), sortAscending: .constant(true), sortedByName: .constant(true), sortedByNameValue: .constant(\Player.surname), sortedByValue: .constant(nil))
}
