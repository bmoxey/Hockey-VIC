//
//  MainTabView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 14/11/2023.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var sharedData = SharedData()
    var body: some View {
        TabView(selection: $sharedData.activeTabIndex) {
            ScheduleView()
                .onAppear {
                    sharedData.activeTabIndex = 0
                }
                .environmentObject(sharedData)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Schedule")
                }
                .tag(0)
            LadderView()
                .onAppear {
                    sharedData.activeTabIndex = 1
                }
                .environmentObject(sharedData)
                .tabItem {
                    Image(systemName: "list.number")
                    Text("Ladder")
                }
                .tag(1)
            RoundView()
                .onAppear {
                    sharedData.activeTabIndex = 2
                }
                .environmentObject(sharedData)
                .tabItem {
                    Image(systemName: "sportscourt.circle.fill")
                    Text("Round")
                }
                .tag(2)
            StatisticsView()
                .onAppear {
                    sharedData.activeTabIndex = 3
                }
                .environmentObject(sharedData)
                .tabItem {
                    Image(systemName: "chart.bar.xaxis")
                    Text("Stats")
                }
                .tag(3)
            SetTeamsView()
                .onAppear {
                    sharedData.activeTabIndex = 4
                }
                .environmentObject(sharedData)
                .tabItem {
                    Image(systemName: "person.crop.rectangle.stack.fill")
                    Text("Teams")
                }
                .tag(4)
        }
        .accentColor(Color.white)
    }
}

#Preview {
    MainTabView()
}
