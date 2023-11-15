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
    @State private var errMsg = ""
    @State private var rounds = [Round]()
    @State private var haveData = false
    @Query(filter: #Predicate<Teams> {$0.isCurrent} ) var currentTeam: [Teams]
    var body: some View {
        if !currentTeam.isEmpty {
            NavigationStack {
                VStack {
                    if !haveData {
                        LoadingView()
                            .task { await myloadData() }
                    } else {
                        if errMsg != "" {
                            ErrorMessageView(errMsg: errMsg)
                        } else {
                            List {
                                ForEach(["Upcoming", "Completed"], id: \.self) { played in
                                    let filteredRounds = rounds.filter { $0.played == played }
                                    if !filteredRounds.isEmpty {
                                        Section(header: CenterSection(title: "\(played) games")) {
                                            ForEach(filteredRounds, id: \.id) { item in
                                                if !currentTeam.isEmpty {
                                                    if item.opponent == "BYE" {
                                                        DetailScheduleView(myTeam: currentTeam[0].teamName, round: item)
                                                    } else {
                                                        NavigationLink(destination: GameView(gameNumber: item.gameID, myTeam: currentTeam[0].teamName, myTeamID: currentTeam[0].teamID)) {
                                                            DetailScheduleView(myTeam: currentTeam[0].teamName, round: item)
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
                                haveData = false
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
                .padding(.horizontal, -8)
                .toolbarBackground(Color("BarBackground"), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(Color("BarBackground"), for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
            }
            .onAppear {
                if sharedData.refreshSchedule {
                    haveData = false
                }
            }
        }
    }
    
    func myloadData() async {
        (rounds, errMsg) = GetSchedData(mycompID: currentTeam[0].compID, myTeamID: currentTeam[0].teamID, myTeamName: currentTeam[0].teamName)
        sharedData.refreshSchedule = false
        haveData = true
    }
}

#Preview {
    ScheduleView()
}
