//
//  Hockey_VICApp.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 14/11/2023.
//

import SwiftUI
import SwiftData

@main
struct Hockey_VICApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Teams.self])
    }
}
