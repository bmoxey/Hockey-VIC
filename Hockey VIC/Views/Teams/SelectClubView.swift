//
//  SelectClubView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 14/11/2023.
//

import SwiftUI
import SwiftData

struct SelectClubView: View {
    @EnvironmentObject private var sharedData: SharedData
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) var context
    @Query(sort: \Teams.clubName) var teams: [Teams]
    @State var isNavigationLink: Bool
    @State var isResetRefresh: Bool
    @State private var showingConfirmation = false
    var body: some View {
        NavigationStack {
            let uniqueClubs = Array(Set(teams.map { $0.clubName }))
            List {
                ForEach(uniqueClubs.sorted(), id: \.self) { club in
                    NavigationLink(destination: SelectTeamView(isNavigationLink: isNavigationLink, myClub: club)) {
                        HStack {
                            Image(club)
                                .resizable()
                                .frame(width: 45, height: 45)
                            Text(club)
                            Spacer()
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Image("AppLogo")
                        .resizable()
                        .frame(width: 93, height: 34)
                }
                ToolbarItem(placement: .principal) {
                    Text("Select your club")
                        .foregroundStyle(Color("BarForeground"))
                        .fontWeight(.semibold)
                }
                if !isNavigationLink {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            showingConfirmation = true
                        }) {
                            HStack {
                                Image(systemName: "chevron.backward")
                                    .font(Font.system(size: 17, weight: .semibold))
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(Color.white)
                                Text("Rebuild")
                                    .foregroundStyle(Color.white)
                            }
                        }
                        .confirmationDialog("Are you sure?", isPresented: $showingConfirmation)
                        {
                            Button("Rebuild club/team lists from website?", role: .destructive) {
                                do {
                                    try context.delete(model: Teams.self)
                                    try context.save()
                                    try context.delete(model: Teams.self)
                                    try context.save()
                                } catch {
                                    print("failed to delete")
                                }
                            }
                        } message: {
                            Text("This will delete all currently selected teams ")
                        }
                    }
                }
            }
            .toolbarBackground(Color("BarBackground"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .onAppear {
            if isNavigationLink {
                if isResetRefresh {
                    sharedData.refreshTeams = false
                    self.isResetRefresh = false
                } else {
                    if sharedData.refreshTeams {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .accentColor(.white)
    }
}

#Preview {
    SelectClubView(isNavigationLink: false, isResetRefresh: false)
}
