//
//  RoundView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 15/11/2023.
//

import SwiftUI
import SwiftData

struct RoundView: View {
    @EnvironmentObject private var sharedData: SharedData
    @State private var errMsg = ""
    @State private var rounds = [Round]()
    @State private var byeTeams: [String] = []
    @State private var haveData = false
    @State private var prev = ""
    @State private var current = ""
    @State private var next = ""
    @Query(filter: #Predicate<Teams> {$0.isCurrent} ) var currentTeam: [Teams]
    var body: some View {
        if !currentTeam.isEmpty {
            NavigationStack {
                VStack {
                    if !haveData {
                        LoadingView()
                            .task { await myloadData(roundName: sharedData.currentRound) }
                    } else {
                        if errMsg != "" {
                            ErrorMessageView(errMsg: errMsg)
                        } else {
                            List {
                                Section(header: DetailRoundHeaderView(prev: prev, current: current, next: next,
                                    onPrevButtonTap: { loadData(roundName: prev) }, onNextButtonTap: { loadData(roundName: next) })) {
                                    ForEach(rounds, id: \.id) { round in
                                        NavigationLink(destination: GameView(gameNumber: round.gameID, myTeam: currentTeam[0].teamName, myTeamID: currentTeam[0].teamID)) {
                                            DetailRoundView(myTeam: currentTeam[0].teamName, myRound: round)
                                        }
                                    }
                                }
                                ForEach(byeTeams, id: \.self) {name in
                                    Section(header: Text("Teams with a bye")){
                                        HStack {
                                            Image(ShortClubName(fullName: name))
                                                .resizable()
                                                .frame(width: 45, height: 45)
                                            Text(name)
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
                        Image(systemName: "sportscourt.circle.fill")
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
            .onAppear() {
                if sharedData.refreshRound {
                    haveData = false
                }
            }
        }
    }
   
    func loadData(roundName: String) {
        Task {
            do {
                await myloadData(roundName: roundName)
            }
        }
    }
    
    func myloadData(roundName: String) async {
        (prev, current, next, rounds, byeTeams, errMsg) = GetRoundData(mycompID: currentTeam[0].compID, myDivID: currentTeam[0].divID, myTeamName: currentTeam[0].teamName, currentRound: roundName)
        sharedData.refreshRound = false
        haveData = true
    }
}

#Preview {
    RoundView()
}
