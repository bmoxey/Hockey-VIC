//
//  LoadErrorView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 14/11/2023.
//

import SwiftUI

struct LoadErrorView: View {
    @State var errMsg: String
    var body: some View {
        Text("Load Error")
    }
}

#Preview {
    LoadErrorView(errMsg: "No data to display.")
}
