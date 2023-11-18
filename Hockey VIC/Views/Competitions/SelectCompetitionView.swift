//
//  SelectCompetitionView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 14/11/2023.
//

import SwiftUI
import SwiftData

struct SelectCompetitionView: View {
    @Environment(\.modelContext) var context
    @Binding var stillLoading: Bool
    @State var haveData = false
    @State var errMsg = ""
    @State private var searching = false
    @State private var comps: [String] = []
    @State private var selectedComps: Set<String> = []
    @State var searchComp: String = ""
    @State var searchDiv: String = ""
    @State private var teamsFound = 0
    @State private var selectedWeek = 1
    var body: some View {
        NavigationStack {
            VStack {
                if !haveData {
                    LoadingView()
                        .task { await loadData() }
                } else {
                    if errMsg != "" {
                        ErrorMessageView(errMsg: errMsg)
                    } else {
                        if searching {
                            DetailSearchView(searchComp: searchComp, searchDiv: searchDiv, teamsFound: teamsFound)
                                .task { await searchData() }
                        } else {
                            DetailCompetitionView(selectedComps: $selectedComps, searching: $searching, comps: comps)
                                .onAppear { stillLoading = true }
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text(searching ? "Searching competitions..." : "Select your competitions")
                        .foregroundStyle(Color("BarForeground"))
                        .fontWeight(.semibold)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Image("AppLogo")
                        .resizable()
                        .frame(width: 93, height: 34)
                }
            }
            .toolbarBackground(Color("BarBackground"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
    
    func loadData() async {
        var myCompName = ""
        var lines: [String] = []
        (lines, errMsg) = GetUrl(url: "https://www.hockeyvictoria.org.au/games/")
        for i in 0 ..< lines.count {
            if lines[i].contains("/reports/games/download/") {
                myCompName = lines[i-4]
                comps.append(myCompName)
                if myCompName.contains("Senior Competition") { selectedComps.insert(myCompName)}
                if myCompName.contains("Midweek Competition") { selectedComps.insert(myCompName)}
                if myCompName.contains("Junior Competition") { selectedComps.insert(myCompName)}
            }
        }
        haveData = true
    }
    
    func searchData() async {
        var myStatus = false
        let newTeam: Teams = Teams(compName: "", compID: "", divName: "", divID: "", divType: "", divLevel: "", teamName: "", teamID: "", clubName: "", isCurrent: false, isUsed: false)
        var lines: [String] = []
        var newlines: [String] = []
        (lines, errMsg) = GetUrl(url: "https://www.hockeyvictoria.org.au/games/")
        for i in 0 ..< lines.count {
            if lines[i].contains("https://www.hockeyvictoria.org.au/reports/games/download/") {
                newTeam.compName = lines[i-4]
                if selectedComps.contains(newTeam.compName) { myStatus = true } else {myStatus = false}
            }
            if myStatus {
                if lines[i].contains("https://www.hockeyvictoria.org.au/games/") {
                    newTeam.compID = String(String(lines[i]).split(separator: "/")[3])
                    newTeam.divID = String(String(lines[i]).split(separator: "=")[2]).trimmingCharacters(in: .punctuationCharacters)
                    newTeam.divName = String(lines[i+1])
                    newTeam.divName = ShortDivName(fullName: newTeam.divName)
                    newTeam.divLevel = GetDivLevel(fullString: newTeam.divName)
                    searchComp = newTeam.compName
                    searchDiv = newTeam.divName
                    (newlines, errMsg) = GetUrl(url: "https://www.hockeyvictoria.org.au/games/\(newTeam.compID)/&r=\(selectedWeek)&d=\(newTeam.divID)")
                    for j in 0 ..< newlines.count {
                        if newlines[j].contains("https://www.hockeyvictoria.org.au/teams") {
                            newTeam.teamName = ShortTeamName(fullName: newlines[j+1])
                            newTeam.clubName = ShortClubName(fullName: newTeam.teamName)
                            newTeam.teamID = String(String(newlines[j]).split(separator: "=")[2]).trimmingCharacters(in: .punctuationCharacters)
                            newTeam.divType = GetDivType(fullName: newTeam.divName)
                            let team = Teams(compName: newTeam.compName, compID: newTeam.compID, divName: newTeam.divName, divID: newTeam.divID, divType: newTeam.divType, divLevel: newTeam.divLevel, teamName: newTeam.teamName, teamID: newTeam.teamID, clubName: newTeam.clubName, isCurrent: false, isUsed: false)
                            context.insert(team)
                            teamsFound += 1
                        }
                    }
                }
            }
        }
        stillLoading = false
    }
}

#Preview {
    SelectCompetitionView(stillLoading: Binding.constant(true))
}
