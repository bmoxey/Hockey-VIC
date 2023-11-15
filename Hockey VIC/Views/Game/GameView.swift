//
//  GameView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 15/11/2023.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject private var sharedData: SharedData
    @Environment(\.presentationMode) var presentationMode
    @State var gameNumber: String
    @State var myTeam: String
    @State var myTeamID: String
    @State var errMsg = ""
    @State var myRound: Round = Round(id: UUID(), roundNo: "", dateTime: "", field: "", venue: "", address: "", opponent: "", homeTeam: "", awayTeam: "", homeGoals: 0, awayGoals: 0, message: "", result: "", played: "", gameID: "")
    @State var myGame: Round = Round(id: UUID(), roundNo: "", dateTime: "", field: "", venue: "", address: "", opponent: "", homeTeam: "", awayTeam: "", homeGoals: 0, awayGoals: 0, message: "", result: "", played: "", gameID: "")
    @State private var haveData = false
    @State private var homePlayers: [Player] = []
    @State private var awayPlayers: [Player] = []
    @State private var otherGames: [Round] = []
    var body: some View {
        NavigationStack {
            if !haveData {
                LoadingView()
                    .task { await myloadData() }
            } else {
                if errMsg != "" {
                    ErrorMessageView(errMsg: errMsg)
                } else {
                    List {
                        DetailGameView(myTeam: myTeam, myRound: myRound)
                        DetailGroundView(myRound: myRound, myTeam: myTeam)
                        if !homePlayers.isEmpty {
                            Section(header: CenterSection(title: "\(myRound.homeTeam) Players")) {
                                ForEach(homePlayers.sorted { $0.surname < $1.surname }) { player in
                                    DetailPlayerView(player: player)
                                }
                            }
                        }
                        if !awayPlayers.isEmpty {
                            Section(header: CenterSection(title: "\(myRound.awayTeam) Players")) {
                                ForEach(awayPlayers.sorted { $0.surname < $1.surname }) { player in
                                    DetailPlayerView(player: player)
                                }
                            }
                        }
                        if !otherGames.isEmpty {
                            Section(header: CenterSection(title: "Other matches between these teams")) {
                                ForEach(otherGames, id: \.id) { item in
                                    DetailScheduleView(myTeam: myTeam, round: item)
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
            if sharedData.activeTabIndex == 0 {
                if sharedData.refreshSchedule {
                    sharedData.refreshSchedule = false
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            if sharedData.activeTabIndex == 2 {
                if sharedData.refreshRound {
                    sharedData.refreshRound = false
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(myRound.roundNo)
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
        (myRound, homePlayers, awayPlayers, otherGames, errMsg) = GetGameData(gameNumber: gameNumber, myTeam: myTeam)
        haveData = true
    }
}

#Preview {
    GameView(gameNumber: "1471439", myTeam: "Hawthorn", myTeamID: "123332")
}
