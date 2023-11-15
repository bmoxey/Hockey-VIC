//
//  LadderView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 15/11/2023.
//

import SwiftUI
import SwiftData

struct LadderView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) var context
    @EnvironmentObject private var sharedData: SharedData
    @State private var errMsg = ""
    @State private var rounds = [Round]()
    @State private var haveData = false
    @State private var linkEnabled = false
    @Query(filter: #Predicate<Teams> {$0.isCurrent} ) var currentTeam: [Teams]
    @State private var ladder = [LadderItem]()
    var body: some View {
        if !currentTeam.isEmpty {
            NavigationStack {
                VStack {
                    if !haveData {
                        LoadingView()
                            .task { await loadData() }
                    } else {
                        if errMsg != "" {
                            ErrorMessageView(errMsg: errMsg)
                        } else {
                            List {
                                Section(header: CenterSection(title: "Ladder")) {
                                    DetailLadderHeaderView()
                                    ForEach(ladder, id: \.id) { item in
                                        if !currentTeam.isEmpty {
                                            VStack {
                                                NavigationLink(destination: LadderItemView(item: item, myTeamID: currentTeam[0].teamID)) {
                                                    DetailLadderView(myTeam: currentTeam[0].teamName, item: item)
                                                }
                                            }
                                            .listRowSeparatorTint( item.pos == 4 ? Color("AccentColor") : Color(UIColor.separator), edges: .all)
                                        }
                                    }
                                }
                            }
                            .refreshable {
                                sharedData.refreshLadder = true
                            }
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Image(systemName: "list.number")
                            .foregroundStyle(Color.white)
                            .font(.title3)
                    }
                    ToolbarItem(placement: .principal) {
                        VStack {
                            Text(currentTeam[0].divName)
                                .foregroundStyle(Color("BarForeground"))
                                .fontWeight(.semibold)
                        }
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
                if sharedData.refreshLadder {
                    haveData = false
                }
            }
        }
    }
    
    func loadData() async {
        var myLadder = LadderItem(id: UUID(), pos: 0, teamName: "", compID: "", teamID: "", played: 0, wins: 0, draws: 0, losses: 0, forfeits: 0, byes: 0, scoreFor: 0, scoreAgainst: 0, diff: 0, points: 0, winRatio: 0)
        var pos = 0
        ladder = []
        var lines: [String] = []
        (lines, errMsg) = GetUrl(url: "https://www.hockeyvictoria.org.au/pointscores/" + currentTeam[0].compID + "/&d=" + currentTeam[0].divID)
        for i in 0 ..< lines.count {
            if lines[i].contains("This ladder is not currently available") {
                errMsg = "This ladder is not currently available"
            }
            if lines[i].contains("hockeyvictoria.org.au/teams/") {
                pos += 1
                myLadder.teamID = String(String(lines[i]).split(separator: "=")[2]).trimmingCharacters(in: .punctuationCharacters)
                myLadder.compID = String(String(lines[i]).split(separator: "/")[3])
                myLadder.teamName = ShortTeamName(fullName: lines[i+1])
                myLadder.played = Int(lines[i+7]) ?? 0
                myLadder.wins = Int(lines[i+10]) ?? 0
                myLadder.draws = Int(lines[i+13]) ?? 0
                myLadder.losses = Int(lines[i+16]) ?? 0
                myLadder.forfeits = Int(lines[i+19]) ?? 0
                myLadder.byes = Int(lines[i+22]) ?? 0
                myLadder.scoreFor = Int(lines[i+25]) ?? 0
                myLadder.scoreAgainst = Int(lines[i+28]) ?? 0
                myLadder.diff = Int(lines[i+31]) ?? 0
                myLadder.points = Int(lines[i+34]) ?? 0
                myLadder.winRatio = Int(lines[i+37]) ?? 0
                myLadder.pos = pos
                myLadder.id = UUID()
                ladder.append(myLadder)
            }
        }
        sharedData.refreshLadder = false
        haveData = true
    }
}

#Preview {
    LadderView()
}
