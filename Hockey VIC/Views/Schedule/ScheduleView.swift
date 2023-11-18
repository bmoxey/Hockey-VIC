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
    @StateObject private var viewModel = ViewModel()
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
                            Section(header: CenterSection(title: "Schedule")) {
                                ForEach(viewModel.rounds.indices, id:\.self) {index in
                                    if !currentTeam.isEmpty {
                                        let round = viewModel.rounds[index]
                                        if index > 0 {
                                            NoGameView(myTeam: currentTeam[0].teamName, prev: viewModel.rounds[index - 1], current: round)
                                        }
                                        if round.opponent == "BYE" {
                                            ByeGameView(myTeam: currentTeam[0].teamName, round: round)
                                        } else {
                                            NavigationLink(destination: GameView(gameID: round.gameID, myTeam: currentTeam[0].teamName)) {
                                                DetailScheduleView(myTeam: currentTeam[0].teamName, round: round)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, -8)
                        .refreshable {
                            await viewModel.loadSchedData(currentTeam: currentTeam[0])
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(currentTeam.isEmpty ? "No Div" : currentTeam[0].divName)
                        .foregroundStyle(Color("BarForeground"))
                        .fontWeight(.semibold)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "calendar")
                        .foregroundStyle(Color.white)
                        .font(.title3)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Image(currentTeam.isEmpty ? "BYE" : currentTeam[0].clubName)
                        .resizable()
                        .frame(width: 45, height: 45)
                }
            }
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color("BarBackground"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color("BarBackground"), for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
        }
        .onAppear {
            Task {
                if !currentTeam.isEmpty {
                    await viewModel.loadSchedData(currentTeam: currentTeam[0])
                    if let currentRound = viewModel.rounds.last(where: { $0.myDate < Date() }) {
                        sharedData.currentRound = currentRound.roundNo
                    }
                }
                sharedData.refreshSchedule = false
            }
        }
    }
}

#Preview {
    ScheduleView()
}
