//
//  DetailCompetitionView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 14/11/2023.
//

import SwiftUI

struct DetailCompetitionView: View {
    @Binding var selectedComps: Set<String>
    @Binding var searching: Bool
    @State private var selectedWeek = 1
    @State var comps: [String]
    var body: some View {
        List(comps, id: \.self) { comp in
            HStack {
                if self.selectedComps.contains(comp) {
                    Image(systemName: "checkmark")
                        .foregroundStyle(Color(.green))
                        .frame(width: 20)
                } else {
                    Image(systemName: "hand.raised")
                        .foregroundStyle(Color(.red))
                        .frame(width: 20)
                }
                Text(comp)
            }
            .padding(.leading, -8)
            .onTapGesture {
                if self.selectedComps.contains(comp) {
                    self.selectedComps.remove(comp)
                } else {
                    self.selectedComps.insert(comp)
                }
            }
        }
        Picker("Select week to search for teams", selection: $selectedWeek) {
            ForEach(1..<19, id: \.self) { number in
                Text("\(number)")
            }
        }
        .foregroundStyle(Color(.systemBlue))
        .pickerStyle(.navigationLink)
        .padding(.horizontal, 32)
        .padding(.bottom)
        Button(action: {
            searching = true
        }, label: {
            Text("Search competitions")
                .frame(width: 280, height: 50)
                .background(Color(.systemBlue).gradient)
                .foregroundStyle(Color.white)
                .font(.system(size: 20, weight: .bold))
                .cornerRadius(10.0)
        })
    }
}

#Preview {
    DetailCompetitionView(selectedComps: .constant(["2023 Senior Competition","2023 Midweek Competitions"]), searching: .constant(false), comps: ["2023 Term 4 Summer","2023 Term 4 Indoor","2023 Senior Competition","2023 Midweek Competitions","2023 Regional Hockey League RHL"])
}
