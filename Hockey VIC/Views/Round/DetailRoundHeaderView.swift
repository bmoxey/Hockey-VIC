//
//  DetailRoundHeaderView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 16/11/2023.
//

import SwiftUI

struct DetailRoundHeaderView: View {
    let prev: String
    let current: String
    let next: String
    let onPrevButtonTap: () -> Void
    let onNextButtonTap: () -> Void

    var body: some View {
        
         HStack {
            if prev != "" {
                Button(action: { Task { do { onPrevButtonTap() } } },
                       label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Color("AccentColor"))
                            .font(Font.system(size: 17, weight: .semibold))
                        Text(GetRound(fullString: prev))
                            .foregroundStyle(Color("AccentColor"))
                            .font(.footnote)
                    }
                })
                .buttonStyle(BorderlessButtonStyle())
                .frame(width: 60)
            } else {
                Text("")
                    .frame(width: 60)
            }
            Spacer()
            Text(current)
                .foregroundStyle(Color("DefaultColor"))
            Spacer()
            if next != "" {
                Button(action: {
                    Task {
                        do { onNextButtonTap() }
                    }
                }, label: {
                    HStack {
                        Text(GetRound(fullString: next))
                            .foregroundStyle(Color("AccentColor"))
                            .font(.footnote)
                        Image(systemName: "chevron.right")
                            .foregroundStyle(Color("AccentColor"))
                            .font(Font.system(size: 17, weight: .semibold))
                    }
                })
                .buttonStyle(BorderlessButtonStyle())
                .frame(width: 60)
            } else {
                Text("")
                    .frame(width: 60)
            }
        }
                }
}

