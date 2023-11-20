//
//  LadderView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 15/11/2023.
//

import SwiftUI
import SwiftData

struct LadderView: View {
    @Environment(\.modelContext) var context
    @EnvironmentObject private var sharedData: SharedData
    @StateObject private var viewModel = ViewModel()
    @Query(filter: #Predicate<Teams> {$0.isCurrent} ) var currentTeam: [Teams]
    var body: some View {
        NavigationStack {
            VStack {
                if !viewModel.haveData {
                    LoadingView()
                } else {
                    if viewModel.errMsg != "" {
                        ErrorMessageView(errMsg: viewModel.errMsg)
                    } else {
                        List {
                            Section(header: CenterSection(title: "Ladder")) {
                                DetailLadderHeaderView()
                                ForEach(viewModel.ladder, id: \.id) { item in
                                    VStack {
                                        NavigationLink(destination: LadderItemView(item: item, myTeamID: currentTeam[0].teamID)) {
                                            DetailLadderView(myTeam: currentTeam[0].teamName, item: item)
                                        }
                                    }
                                    .listRowSeparatorTint( item.pos == 4 ? Color("AccentColor") : Color(UIColor.separator), edges: .all)
                                }
                            }
                        }
                        .navigationTitle("Ladder")
                        .environment(\.defaultMinListRowHeight, 5)
                        .padding(.horizontal, -8)
                        .refreshable {
                            await viewModel.loadLadderData(currentTeam: currentTeam[0])
                        }
                        
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text(currentTeam.isEmpty ? "No Div" : currentTeam[0].divName)
                            .foregroundStyle(Color("BarForeground"))
                            .fontWeight(.semibold)
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "list.number")
                        .foregroundStyle(Color.white)
                        .font(.title3)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Image(currentTeam.isEmpty ? "BYE" : currentTeam[0].clubName)
                        .resizable()
                        .frame(width: 45, height: 45)
                }
            }
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color("BarBackground"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color("BarBackground"), for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
        }
        .onAppear() {
            Task {
                await viewModel.loadLadderData(currentTeam: currentTeam[0])
                sharedData.refreshLadder = false
            }
        }
    }
}

#Preview {
    LadderView()
}
