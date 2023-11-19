//
//  FixtureSection.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 19/11/2023.
//

import SwiftUI

struct FixtureSection: View {
    var roundNo: String
    var roundDate: Date
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE d MMM"
        return dateFormatter.string(from: roundDate)
    }
    var body: some View {
        let isWithinOneWeek = Date() < roundDate && Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date()) ?? Date() >= roundDate
        VStack {
            if roundNo == "Round 1" { CenterSection(title: "Fixture")}
            HStack {
                Text(roundNo)
                    .foregroundStyle(isWithinOneWeek ? Color("DefaultColor") : Color.gray)
                Spacer()
                Text(formattedDate)
                    .foregroundStyle(isWithinOneWeek ? Color("DefaultColor") : Color.gray)
            }
        }
    }
}

#Preview {
    FixtureSection(roundNo: "Round 1", roundDate: Date())
}
