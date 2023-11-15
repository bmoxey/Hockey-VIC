//
//  StatisticsView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 15/11/2023.
//

import SwiftUI
import SwiftData

struct StatisticsView: View {
    @Environment(\.modelContext) var context
    @EnvironmentObject private var sharedData: SharedData
    @Environment(\.colorScheme) var colorScheme
    @State private var errMsg = ""
    @State private var players = [Player]()
    @State private var sortedByName = true
    @State private var haveData = false
    @State private var sortedByNameValue: KeyPath<Player, String> = \Player.surname
    @State private var sortedByValue: KeyPath<Player, Int>? = nil
    @State private var sortAscending = true
    @State private var sortMode = 2
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
                                Section(header: CenterSection(title: "\(currentTeam[0].teamName) Stats")) {
                                    DetailStatsHeaderView(sortMode: $sortMode, sortAscending: $sortAscending, sortedByName: $sortedByName, sortedByNameValue: $sortedByNameValue, sortedByValue: $sortedByValue)
                                    ForEach(players.sorted(by: sortDescriptor)) { player in
                                        NavigationLink(destination: PlayerStatsView(myTeam: currentTeam[0].teamName, myTeamID: currentTeam[0].teamID, myCompID: currentTeam[0].compID,  player: player)) {
                                            DetailStatsView(player: player)
                                        }
                                    }
                                }
                            }
                            .environment(\.defaultMinListRowHeight, 3)
                            .refreshable {
                                sharedData.refreshStats = true
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
                        Image(systemName: "chart.bar.xaxis")
                            .foregroundStyle(Color.white)
                            .font(.title3)
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Image(ShortClubName(fullName: currentTeam[0].teamName))
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
            .onAppear() {
                if sharedData.refreshStats {
                    haveData = false
                }
            }
        }
    }
        
        
    private var sortDescriptor: (Player, Player) -> Bool {
        let ascending = sortAscending
        if let sortedByValue = sortedByValue {
            return { (player1, player2) in
                if ascending {
                    return player1[keyPath: sortedByValue] < player2[keyPath: sortedByValue]
                } else {
                    return player1[keyPath: sortedByValue] > player2[keyPath: sortedByValue]
                }
            }
        } else if sortedByName {
            return { (player1, player2) in
                if ascending {
                    return player1[keyPath: sortedByNameValue] < player2[keyPath: sortedByNameValue]
                } else {
                    return player1[keyPath: sortedByNameValue] > player2[keyPath: sortedByNameValue]
                }
            }
        } else {
            return { _, _ in true }
        }
    
    }
    func myloadData() async {
        (players, errMsg) = GetStatsData(myCompID: currentTeam[0].compID, myTeamID: currentTeam[0].teamID)
        sharedData.refreshStats = false
        haveData = true
    }
}

#Preview {
    StatisticsView()
}
