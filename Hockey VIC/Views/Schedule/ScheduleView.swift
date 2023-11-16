//
//  ScheduleView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 15/11/2023.
//

import SwiftUI
import SwiftData

struct ScheduleView: View {
    @Environment(\.modelContext) var context
    @EnvironmentObject private var sharedData: SharedData
    @StateObject private var viewModel = ScheduleViewModel()
    @Query(filter: #Predicate<Teams> {$0.isCurrent} ) var currentTeam: [Teams]
    var body: some View {
        NavigationStack {
            VStack {
                if !viewModel.haveData {
                    LoadingView()
                } else {
                    if viewModel.errMsg != "" {
                        ErrorMessageView(errMsg: viewModel.errMsg)
                    } else {
                        List {
                            ForEach(["Upcoming", "Completed"], id: \.self) { played in
                                let filteredRounds = viewModel.rounds.filter { $0.played == played }
                                if !filteredRounds.isEmpty {
                                    Section(header: CenterSection(title: "\(played) games")) {
                                        ForEach(filteredRounds, id: \.id) { round in
                                            if !currentTeam.isEmpty {
                                                if round.opponent == "BYE" {
                                                    DetailScheduleView(myTeam: currentTeam[0].teamName, round: round)
                                                } else {
                                                    NavigationLink(destination: GameView(gameNumber: round.gameID, myTeam: currentTeam[0].teamName, myTeamID: currentTeam[0].teamID)) {
                                                        DetailScheduleView(myTeam: currentTeam[0].teamName, round: round)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    .onAppear {
                                        if played == "Completed" {
                                            if let lastCompletedRound = filteredRounds.last?.roundNo {
                                                sharedData.currentRound = lastCompletedRound
                                            } else {
                                                sharedData.currentRound = "Round 1"
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .refreshable {
                            await viewModel.loadData(currentTeam: currentTeam[0])
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(currentTeam[0].divName)
                        .foregroundStyle(Color("BarForeground"))
                        .fontWeight(.semibold)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "calendar")
                        .foregroundStyle(Color.white)
                        .font(.title3)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Image(currentTeam[0].clubName)
                        .resizable()
                        .frame(width: 45, height: 45)
                }
            }
            .toolbarBackground(Color("BarBackground"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color("BarBackground"), for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
        }
        .onAppear {
            Task {
                await viewModel.loadData(currentTeam: currentTeam[0])
                sharedData.refreshSchedule = false
            }
        }
    }
}

class ScheduleViewModel: ObservableObject {
    @Published var rounds = [Round]()
    @Published var haveData = false
    @Published var errMsg = ""
    @MainActor func loadData(currentTeam: Teams) async {
        haveData = false
        (rounds, errMsg) = GetSchedData(mycompID: currentTeam.compID, myTeamID: currentTeam.teamID, myTeamName: currentTeam.teamName)
        haveData = true
    }
}

#Preview {
    ScheduleView()
}
