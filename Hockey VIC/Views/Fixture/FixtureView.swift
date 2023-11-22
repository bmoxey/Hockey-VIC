//
//  FixtureView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 19/11/2023.
//

import SwiftUI
import SwiftData

struct FixtureView: View {
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
                            ForEach(viewModel.rounds.indices, id:\.self) {index in
                                let round = viewModel.rounds[index]
                                let isWithinOneWeek = Date() < round.myDate && Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date()) ?? Date() >= round.myDate
                                Section(header: FirstSection(index: index, header: "Fixture")) {
                                    if !currentTeam.isEmpty {
                                        if round.opponent == "BYE" || round.opponent == "No Game"{
                                            DetailFixtureView(myTeam: currentTeam[0].teamName, round: round)
                                                .listRowBackground(isWithinOneWeek ? Color("RowHighlight") : Color(UIColor.secondarySystemGroupedBackground))
                                        } else {
                                            NavigationLink(destination: GameView(gameID: round.gameID, myTeam: currentTeam[0].teamName)) {
                                                DetailFixtureView(myTeam: currentTeam[0].teamName, round: round)
                                            }
                                            .listRowBackground(isWithinOneWeek ? Color("RowHighlight") : Color(UIColor.secondarySystemGroupedBackground))
                                        }
                                    }
                                }
                            }
                        }
                        .navigationTitle("Fixture")
                        .padding(.horizontal, -8)
                        .refreshable {
                            await viewModel.loadFixtureData(currentTeam: currentTeam[0])
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(currentTeam.isEmpty ? "No Div" : currentTeam[0].divName)
                        .foregroundStyle(Color("BarForeground"))
                        .fontWeight(.semibold)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "calendar")
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
        .onAppear {
            Task {
                if !currentTeam.isEmpty {
                    await viewModel.loadFixtureData(currentTeam: currentTeam[0])
                    if let currentRound = viewModel.rounds.last(where: { $0.myDate < Date() }) {
                        sharedData.currentRound = currentRound.roundNo
                    }
                }
                sharedData.refreshFixture = false
            }
        }
    }
}

#Preview {
    FixtureView()
}
