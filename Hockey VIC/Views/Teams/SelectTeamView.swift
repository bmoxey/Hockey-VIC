//
//  SelectTeamView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 14/11/2023.
//

import SwiftUI
import SwiftData

struct SelectTeamView: View {
    @Environment(\.modelContext) var context
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var sharedData: SharedData
    var isNavigationLink: Bool
    @State var myClub: String
    @Query var teams: [Teams]
    var myTeams: [Teams] {
        return teams.filter { team in
            return team.clubName == myClub
        }
    }
    var mySortedTeams: [Teams] {
        return myTeams.sorted { (team1, team2) in
            if team1.divLevel == team2.divLevel {
                return team1.divName < team2.divName
            } else {
                return team1.divLevel < team2.divLevel
            }
        }
    }
    var body: some View {
        NavigationStack {
            List {
                ForEach(Dictionary(grouping: mySortedTeams, by: { $0.divType }).sorted(by: { $0.key < $1.key }), id: \.key) { (divType, teamsGroupedByDivType) in
                    Section(header: HeaderDivType(divType: divType)) {
                        ForEach(Dictionary(grouping: teamsGroupedByDivType, by: { $0.compName }).sorted(by: { $0.key < $1.key }), id: \.key) { (compName, teamsGroupedByCompName) in
                            Section(header: HeaderCompName(compName: compName)) {
                                ForEach(teamsGroupedByCompName, id: \.self) { team in
                                    VStack {
                                        HStack {
                                            Text(team.divName)
                                            Spacer()
                                        }
                                        if team.clubName != team.teamName {
                                            HStack {
                                                Text("competing as \(team.teamName)")
                                                    .font(.footnote)
                                                Spacer()
                                            }
                                        }
                                    }
                                    .onTapGesture {
                                        var count = 0
                                        for index in 0 ..< teams.count {
                                            if teams[index].isCurrent == true {
                                                count = count + 1
                                                teams[index].isCurrent = false
                                            }
                                        }
                                        team.isCurrent = true
                                        team.isUsed = true
                                        if count > 0 {
                                            sharedData.refreshSchedule = true
                                            sharedData.refreshLadder = true
                                            sharedData.refreshRound = true
                                            sharedData.refreshStats = true
                                            sharedData.refreshTeams = true
                                            sharedData.activeTabIndex = 0
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }.environment(\.defaultMinListRowHeight, 3)
        }
        .onAppear {
            if isNavigationLink {
                if sharedData.refreshTeams {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Select your team")
                    .foregroundStyle(Color("BarForeground"))
                    .fontWeight(.semibold)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Image(myClub)
                    .resizable()
                    .frame(width: 45, height: 45)
            }
        }
        .toolbarBackground(Color("BarBackground"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}


#Preview {
    SelectTeamView(isNavigationLink: false, myClub: "MHSOB")
}
