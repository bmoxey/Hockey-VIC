//
//  TeamView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 20/11/2023.
//

import SwiftUI
import SwiftData

struct TeamView: View {
    @Environment(\.modelContext) var context
    @EnvironmentObject private var sharedData: SharedData
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = ViewModel()
    @Query var teams: [Teams]
    @State var ladder: [LadderItem]
    @State var pos: Int
    @State var item: LadderItem?
    @State var haveDate: Bool = false
    @State var myTeam: Teams = Teams(compName: "", compID: "", divName: "", divID: "", divType: "", divLevel: "", teamName: "", teamID: "", clubName: "", isCurrent: false, isUsed: false)
    var maxGames: Int { ladder.map { $0.played + $0.byes }.max() ?? 0 }
    var maxGoals: Int { ladder.map { max($0.scoreFor, $0.scoreAgainst) }.max() ?? 0 }
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(ladder, id: \.self) { item in
                        Image(ShortClubName(fullName: item.teamName))
                            .resizable()
                            .scaledToFit()
                            .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                            .shadow(radius: 10, y: 10)
                            .scrollTransition { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1 : 0.5)
                                    .scaleEffect(phase.isIdentity ? 1 : 0.5)
                                    .blur(radius: phase.isIdentity ? 0 : 0.5)
                                    .saturation(phase.isIdentity ? 1 : 0.5)
                                    .rotation3DEffect(.degrees(phase.value * 45), axis: (x: 0, y: 0.5, z: 0))
                            }
                            .onTapGesture {
                                self.item = item
                            }
                    }
                }
                .scrollTargetLayout()
            }
            .safeAreaPadding(.horizontal, CGFloat(UIScreen.main.bounds.width/3))
            .scrollTargetBehavior(.viewAligned)
            .scrollClipDisabled()
            .scrollPosition(id: $item, anchor: .center)
            .onAppear {
                DispatchQueue.main.async {
                    scrollToElement(index: pos)
                }
            }
            HStack {
                Spacer()
                if item != ladder.first {
                    Button {
                        withAnimation {
                            guard let item, let index = ladder.firstIndex(of: item),
                                  index > 0 else { return }
                            self.item = ladder[index - 1]
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Color.gray)
                            .font(Font.system(size: 17, weight: .semibold))
                    }
                }
                Spacer()
                ForEach(ladder.indices, id:\.self) {index in
                    Circle()
                        .fill(Color("DefaultColor").opacity(item?.teamName == ladder[index].teamName ? 0.7 : 0.2))
                        .frame(width:10, height:10)
                        .scaleEffect(item?.teamName == ladder[index].teamName ? 1.4 : 1)
                        .animation(.spring(), value: item?.teamName == ladder[index].teamName)
                }
                Spacer()
                if item != ladder.last {
                    Button {
                        withAnimation {
                            guard let item, let index = ladder.firstIndex(of: item),
                                  index < ladder.count - 1 else { return }
                            self.item = ladder[index + 1]
                        }
                    } label: {
                        Image(systemName: "chevron.right")
                            .foregroundStyle(Color.gray)
                            .font(Font.system(size: 17, weight: .semibold))
                    }
                }
                Spacer()
            }
            List {
                if item != nil {
                    DetailLadderItemView(item: item!, maxGames: maxGames, maxGoals: maxGoals)
                    if viewModel.haveData {
                        if viewModel.errMsg != "" {
                            ErrorMessageView(errMsg: viewModel.errMsg)
                        } else {
                            ForEach(viewModel.rounds.indices, id:\.self) {index in
                                let round = viewModel.rounds[index]
                                Section(header: FirstSection(index: index, header: "Fixture")) {
                                    DetailFixtureView(myTeam: myTeam.teamName, round: round)
                                }
                            }
                        }
                    }
                }
            }
            Spacer()
        }
        .onAppear {
            if sharedData.refreshLadder {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
        .onChange(of: item, {
            viewModel.haveData = false
            Task(priority: .background) {
                let teamID = item?.teamID
                if let updatedTeam = teams.first(where: { $0.teamID == teamID }) {
                    myTeam = updatedTeam
                    try await Task.sleep(nanoseconds: 500_000_000)
                    await viewModel.loadFixtureData(currentTeam: updatedTeam)
                }
            }
        })
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("\(item?.teamName ?? "No Team")")
                    .foregroundStyle(Color("BarForeground"))
                    .fontWeight(.semibold)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Image(ShortClubName(fullName: item?.teamName ?? "BYE"))
                    .resizable()
                    .frame(width: 45, height: 45)
            }
            
        }
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Color("BarBackground"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
    
    func scrollToElement(index: Int) {
        guard index < ladder.count else { return }
        DispatchQueue.main.async {
                item = ladder[index]
            }
    }
}
