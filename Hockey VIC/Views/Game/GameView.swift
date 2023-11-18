//
//  GameView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 15/11/2023.
//

import SwiftUI

struct GameView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var sharedData: SharedData
    @StateObject private var viewModel = ViewModel()
    @State var gameID: String
    @State var myTeam: String
    var body: some View {
        VStack {
            if !viewModel.haveData {
                LoadingView()
            } else {
                if viewModel.errMsg != "" {
                    ErrorMessageView(errMsg: viewModel.errMsg)
                } else {
                    List {
                        DetailGameView(round: viewModel.round, myTeam: myTeam)
                        DetailGroundView(round: viewModel.round, myTeam: myTeam)
                        if !viewModel.homePlayers.isEmpty {
                            Section(header: CenterSection(title: "\(viewModel.round.homeTeam) Players")) {
                                ForEach(viewModel.homePlayers.sorted { $0.surname < $1.surname }) { player in
                                    DetailPlayerView(player: player)
                                }
                            }
                        }
                        if !viewModel.awayPlayers.isEmpty {
                            Section(header: CenterSection(title: "\(viewModel.round.awayTeam) Players")) {
                                ForEach(viewModel.awayPlayers.sorted { $0.surname < $1.surname }) { player in
                                    DetailPlayerView(player: player)
                                }
                            }
                        }
                        if !viewModel.rounds.isEmpty {
                            Section(header: CenterSection(title: "Other matches between teams")) {
                                ForEach(viewModel.rounds, id: \.id) { round in
                                    DetailScheduleView(myTeam: myTeam, round: round)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, -8)
                    .refreshable {
                        await viewModel.loadGameData(gameID: gameID, myTeam: myTeam)
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
            Task {
                await viewModel.loadGameData(gameID: gameID, myTeam: myTeam)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(viewModel.round.roundNo)
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
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Color("BarBackground"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

#Preview {
    GameView(gameID: "1471439", myTeam: "Hawthorn")
}
