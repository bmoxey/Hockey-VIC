//
//  DetailGroundView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 15/11/2023.
//

import SwiftUI

struct DetailGroundView: View {
    var round: Round
    var myTeam: String
    var body: some View {
        Section(header: CenterSection(title: "Ground Details")) {
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "sportscourt.fill")
                        .resizable()
                        .frame(width: 40, height: 30)
                        .foregroundColor(Color(round.homeTeam == myTeam ? .green : .red))
                    Text(" \(round.field)")
                        .font(.largeTitle)
                    Spacer()
                }
                VStack {
                    Text(round.venue)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                Button {
                    openGoogleMaps(with: "\(round.venue), \(round.address) , Victoria, Australia", label: "\(round.venue)")
                } label: {
                    HStack {
                        Text("Open in Google Maps")
                            .foregroundColor(Color("AccentColor"))
                        Image(systemName: "chevron.right")
                            .font(Font.system(size: 17, weight: .semibold))
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color("AccentColor"))
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
    }
    
    func openGoogleMaps(with address: String, label: String) {
        if let url = URL(string: "comgooglemaps://?q=\(address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)&label=\(label.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                let safariURL = URL(string: "https://www.google.com/maps/search/?api=1&query=\(address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)")
                UIApplication.shared.open(safariURL!, options: [:], completionHandler: nil)
            }
        }
    }
}

#Preview {
    DetailGroundView(round: Round(), myTeam: "MHSOB")
}

