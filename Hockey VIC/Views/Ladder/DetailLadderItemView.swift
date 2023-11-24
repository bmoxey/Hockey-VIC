//
//  DetailLadderItemView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 15/11/2023.
//

import SwiftUI
import Charts

struct Result: Equatable, Identifiable {
    let id = UUID()
    let result: String
    let count: Int
}

struct Goal: Equatable, Identifiable {
    let id = UUID()
    let type: String
    let count: Int
}

struct DetailLadderItemView: View {
    let item: LadderItem
    let maxGames: Int
    let maxGoals: Int
    var body: some View {
        let data: [Result] = [
            Result(result: "Byes", count: item.byes),
            Result(result: "Wins", count: item.wins),
            Result(result: "Draws", count: item.draws),
            Result(result: "Forfeits", count: item.forfeits),
            Result(result: "Losses", count: item.losses)
        ]
        let goals: [Goal] = [
            Goal(type: "Goals for", count: item.scoreFor),
            Goal(type: "Goals against", count: item.scoreAgainst)]
        Section(header: CenterSection(title: "Status")) {
            VStack {
                HStack{
                    Spacer()
                    Text("Ladder Position: ")
                        .font(.title2)
                        .foregroundStyle(Color(.gray))
                    if item.pos == 1 {
                        Text("\(item.pos)st")
                            .font(.title2)
                    }
                    if item.pos == 2 {
                        Text("\(item.pos)nd")
                            .font(.title2)
                    }
                    if item.pos == 3 {
                        Text("\(item.pos)rd")
                            .font(.title2)
                    }
                    if item.pos > 3 {
                        Text("\(item.pos)th")
                            .font(.title2)
                    }
                    Spacer()
                }
                
                Chart(data) { result in
                    BarMark( x: .value("Result", result.result), y: .value("Results", result.count))
                    .foregroundStyle(by: .value("Count", result.result))
                    .annotation(position: .top, alignment: .center) {
                        Text(result.count > 0 ? "\(result.count)" : "")
                            .font(.caption)
                    }
                }
                .chartLegend(.hidden)
                .chartYScale(domain: 0...Double(maxGames) * 1.05)
                .transition(.scale)
                .animation(.spring, value: data)

                Chart(goals) { goal in
                    BarMark(x: .value("Count", goal.count), y: .value("Type", goal.type))
                        .foregroundStyle(goal.type == "Goals for" ? Color.green : Color.red)
                        .annotation(position: .trailing, alignment: .center) {
                            Text(goal.count > 0 ? "\(goal.count)" : "")
                                .font(.caption)
                        }
                }
                .chartLegend(.visible)
                .chartXScale(domain: 0...Double(maxGoals) * 1.05)
                .transition(.scale)
                .animation(.spring, value: goals)
                
                HStack {
                    Spacer()
                    Text("Goal Difference: ")
                        .foregroundStyle(Color(.gray))
                    Text(item.diff < 0 ? "\(item.diff)" : "+\(item.diff)")
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    DetailLadderItemView(item: LadderItem(), maxGames: 18, maxGoals: 100)
}

