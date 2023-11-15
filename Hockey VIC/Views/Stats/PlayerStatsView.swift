//
//  PlayerStatsView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 15/11/2023.
//

import SwiftUI
import SwiftData

struct PlayerStatsView: View {
    @EnvironmentObject private var sharedData: SharedData
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) var context
    @Query var teams: [Teams]
    @State var myTeam: String
    @State var myTeamID: String
    @State var myCompID: String
    @State var errMsg = ""
    @State private var haveData = false
    @State var myStats: [PlayerStat] = []
    @State var player: Player
    var body: some View {
        NavigationStack {
            if !haveData {
                LoadingView()
                    .task { await myloadData() }
            } else {
                if errMsg != "" {
                    ErrorMessageView(errMsg: errMsg)
                } else {
                    let uniqueTeamIDs = Array(Set(myStats.map {$0.teamID }))
                    List {
                        let filteredStats = myStats.filter { $0.teamID == myTeamID }
                        if !filteredStats.isEmpty {
                            Section(header: CenterSection(title: filteredStats[0].divName)) {
                                ForEach(filteredStats) {playerStats in
                                    DetailPlayerStatsView(playerStat: playerStats)
                                }
                            }
                        }
                        ForEach(uniqueTeamIDs, id: \.self) {uniqueTeamID in
                            if uniqueTeamID != myTeamID {
                            let filteredStats = myStats.filter { $0.teamID == uniqueTeamID }
                                if !filteredStats.isEmpty {
                                    Section(header: CenterSection(title: filteredStats[0].divName)) {
                                        ForEach(filteredStats) {playerStats in
                                            DetailPlayerStatsView(playerStat: playerStats)
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
        .onAppear {
            if sharedData.refreshStats{
                self.presentationMode.wrappedValue.dismiss()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(player.name)
                        .foregroundStyle(Color("BarForeground"))
                        .fontWeight(.semibold)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Image(ShortClubName(fullName: myTeam))
                    .resizable()
                    .frame(width: 45, height: 45)
            }
        }
        .toolbarBackground(Color("BarBackground"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color("BarBackground"), for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
    
    func myloadData() async {
        (myStats, errMsg) = GetPlayerData(allTeams: teams, ourCompID: myCompID, ourTeam: myTeam, ourTeamID: myTeamID, myURL: player.statsLink)
        haveData = true
    }
    
}


#Preview {
    PlayerStatsView(myTeam: "MHSOB", myTeamID: "12345",  myCompID: "aaaa", player: Player(name: "Brett Moxey", numberGames: 0, goals: 5, greenCards: 1, yellowCards: 2, redCards: 0, goalie: 0, surname: "Moxey", captain: true, fillin: false, us: true, statsLink: ""))
}

