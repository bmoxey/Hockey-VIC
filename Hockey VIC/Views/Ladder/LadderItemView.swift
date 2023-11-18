//
//  LadderItemView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 15/11/2023.
//

import SwiftUI
import SwiftData

struct LadderItemView: View {
    @EnvironmentObject private var sharedData: SharedData
    @Environment(\.presentationMode) var presentationMode
    @State var item: LadderItem
    @State var myTeamID: String
    @State private var haveData: Bool = false
    @State private var errMsg = ""
    @State private var rounds = [Round]()
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
                        DetailLadderItemView(item: item)
                        Section(header: CenterSection(title: "Games")) {
                            ForEach(rounds, id: \.id) { round in
                                DetailScheduleView(myTeam: item.teamName, round: round)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            if sharedData.refreshLadder {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(item.teamName)
                    .foregroundStyle(Color("BarForeground"))
                    .fontWeight(.semibold)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Image(ShortClubName(fullName: item.teamName))
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
        
    func myloadData() async {
        (rounds, errMsg) = GetSchedData(mycompID: item.compID, myTeamID: item.teamID, myTeamName: item.teamName)
        haveData = true
    }
}

#Preview {
    LadderItemView(item: LadderItem(), myTeamID: "12312")
}
