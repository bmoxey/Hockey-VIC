//
//  ContentView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 14/11/2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var context
    @StateObject var networkMonitor = NetworkMonitor()
    @State var stillLoading : Bool = false
    @Query var teams: [Teams]
    @Query(filter: #Predicate<Teams> {$0.isCurrent} ) var currentTeam: [Teams]

    var body: some View {
        VStack {
            if !networkMonitor.isConnected {
                NoNetworkView()
            } else {
                if teams.isEmpty || stillLoading {
                    SelectCompetitionView(stillLoading: $stillLoading)
                } else {
                    if currentTeam.isEmpty {
                        SelectClubView(isNavigationLink: false, isResetRefresh: false)
                    } else {
                        MainTabView()
                    }
                }
            }
        }
        .onAppear { networkMonitor.start() }
        .onDisappear { networkMonitor.stop() }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Teams.self, inMemory: true)
}
