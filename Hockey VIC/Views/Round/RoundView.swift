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
                                Section(header: DetailRoundHeaderView(prev: prev, current: current, next: next, onPrevButtonTap: {
                                    loadData(roundName: prev)
                                }, onNextButtonTap: {
                                    loadData(roundName: next)
                                })) {}
                                ForEach(rounds.sorted(by: { $0.myDate < $1.myDate }), id: \.id) { round in
                                    Section(header: HighlightSection(leftTitle: "\(formattedDate(from: round.myDate))", rightTitle: "\(formattedTime(from: round.myDate)) @ \(round.field)")) {
                                        NavigationLink(destination: GameView(gameID: round.gameID, myTeam: currentTeam[0].teamName)) {
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
//                            .listStyle(GroupedListStyle())
//                            .navigationTitle("Sorted Rounds").environment(\.defaultMinListRowHeight, 5)
                            .navigationTitle("Round")
                            .refreshable {
                                Task {
                                    haveData = false
                                }
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
                .toolbarColorScheme(.dark, for: .navigationBar)
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
    
    private func formattedTime(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: date)
    }
    
    private func formattedDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE d MMM"
        return dateFormatter.string(from: date)
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
