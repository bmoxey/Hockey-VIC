//
//  DetailLadderItemView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 15/11/2023.
//

import SwiftUI
import Charts

struct Result: Identifiable {
    let id = UUID()
    let result: String
    let count: Int
}

struct DetailLadderItemView: View {
    let item: LadderItem
    var body: some View {
        let data: [Result] = [
            Result(result: "Byes", count: item.byes),
            Result(result: "Wins", count: item.wins),
            Result(result: "Draws", count: item.draws),
            Result(result: "Forfeits", count: item.forfeits),
            Result(result: "Losses", count: item.losses)
        ]
        Section(header: CenterSection(title: "Results")) {
            VStack {
                HStack{
                    Spacer()
                    Text("Ladder Position: ")
                        .font(.largeTitle)
                        .foregroundStyle(Color(.gray))
                    if item.pos == 1 {
                        Text("\(item.pos)st")
                            .font(.largeTitle)
                    }
                    if item.pos == 2 {
                        Text("\(item.pos)nd")
                            .font(.largeTitle)
                    }
                    if item.pos == 3 {
                        Text("\(item.pos)rd")
                            .font(.largeTitle)
                    }
                    if item.pos > 3 {
                        Text("\(item.pos)th")
                            .font(.largeTitle)
                    }
                    Spacer()
                }
                Chart(data) { result in
                    BarMark(
                        x: .value("Results", result.count)
                    )
                    .foregroundStyle(by: .value("Count", result.result))
                    .annotation(position: .overlay, alignment: .center) {
                        Text("\(result.count)")
                            .font(.caption)
                    }
                }
                .chartLegend(.visible)
                .frame(width: 350, height: 70)
                .chartXAxis(.hidden)
//                HStack {
//                    ForEach(0 ..< item.wins, id: \.self) { _ in
//                        Image(systemName: "checkmark.square.fill")
//                            .foregroundColor(.green)
//                            .frame(width: 12, height: 12)
//                    }
//                    ForEach(0 ..< item.draws, id: \.self) { _ in
//                        Image(systemName: "minus.square.fill")
//                            .foregroundColor(.orange)
//                            .frame(width: 12, height: 12)
//                    }
//                    ForEach(0 ..< item.byes, id: \.self) { _ in
//                        Image(systemName: "hand.raised.square.fill")
//                            .foregroundColor(.cyan)
//                            .frame(width: 12, height: 12)
//                    }
//                    ForEach(0 ..< item.losses, id: \.self) { _ in
//                        Image(systemName: "xmark.square.fill")
//                            .foregroundColor(.red)
//                            .frame(width: 12, height: 12)
//                    }
//                    ForEach(0 ..< item.forfeits, id: \.self) { _ in
//                        Image(systemName: "exclamationmark.square.fill")
//                            .foregroundColor(.pink)
//                            .frame(width: 12, height: 12)
//                    }
//                }
//                .frame(maxWidth: .infinity, alignment: .center)
//                Text("Wins: \(item.wins) Draws: \(item.draws) Losses: \(item.losses)")
//                    .frame(maxWidth: .infinity, alignment: .center)
//                Text("Forfeits: \(item.forfeits) Byes: \(item.byes)")
//                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        Section(header: CenterSection(title: "Goals")) {
            VStack {
                Text(String(repeating: "●", count: item.scoreFor))
                    .font(.system(size: 20))
                    .foregroundStyle(Color.green)
                    .padding(.vertical, 0)
                    .padding(.horizontal, -8)
                Text(String(repeating: "●", count: item.scoreAgainst))
                    .font(.system(size:20))
                    .foregroundStyle(Color.red)
                    .padding(.vertical, 0)
                    .padding(.horizontal, -8)
                Text("For: \(item.scoreFor) Against: \(item.scoreAgainst) Diff: \(item.diff)")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}

#Preview {
    DetailLadderItemView(item: LadderItem())
}

