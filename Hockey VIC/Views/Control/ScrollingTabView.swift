//
//  ScrollingTabView.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 24/11/2023.
//

import SwiftUI

struct TopFrameView: Shape {
    func path(in rect: CGRect) -> Path {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 53.22, y: 4.36))
        for (to, controlPoint1, controlPoint2) in [(CGPoint(x: 60.83, y: 13.06), CGPoint(x: 57.76, y: 7.77), CGPoint(x: 60.14, y: 11.68)), (CGPoint(x: 68.43, y: 22.84), CGPoint(x: 63, y: 17.4), CGPoint(x: 65.05, y: 20.96)), (CGPoint(x: 75.16, y: 23.98), CGPoint(x: 70.49, y: 23.98), CGPoint(x: 75.16, y: 23.98))] {
            bezierPath.addCurve(to: to, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        }
        bezierPath.addLine(to: CGPoint(x: 0.84, y: 23.98))
        for (to, controlPoint1, controlPoint2) in [(CGPoint(x: 7.57, y: 22.84), CGPoint(x: 0.84, y: 23.98), CGPoint(x: 5.51, y: 23.98)), (CGPoint(x: 15.17, y: 13.06), CGPoint(x: 10.95, y: 20.96), CGPoint(x: 13, y: 17.4)), (CGPoint(x: 22.78, y: 4.36), CGPoint(x: 15.86, y: 11.68), CGPoint(x: 18.24, y: 7.77)), (CGPoint(x: 36.38, y: -0), CGPoint(x: 27.58, y: 0.77), CGPoint(x: 33.55, y: 0.1)), (CGPoint(x: 38, y: 0), CGPoint(x: 37.39, y: -0.04), CGPoint(x: 38, y: 0)), (CGPoint(x: 53.22, y: 4.36), CGPoint(x: 38, y: 0), CGPoint(x: 46.7, y: -0.53))] {
            bezierPath.addCurve(to: to, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        }
        bezierPath.close()
        return Path(bezierPath.cgPath)
    }
}

struct TabItemDescription {
    var imageName: String
    var title: String
    func iconView(_ foregroundColor: Color) -> some View { Image(systemName: imageName).font(.system(size: 24)).foregroundColor(foregroundColor) }
    func labelView(_ foregroundColor: Color) -> some View { Text(title).font(.system(size: 9, weight: .bold)).foregroundColor(foregroundColor) }
}

enum Defs {
    static let tabItems: [TabItemDescription] = [.init(imageName: "calendar", title: "Fixture"), .init(imageName: "list.number", title: "Ladder"), .init(imageName: "sportscourt", title: "Round"), .init(imageName: "chart.bar.xaxis", title: "Stats"), .init(imageName: "person.fill", title: "Teams")]
    static let accentColor = Color(UIColor(red: 0, green: 0.227, blue: 0.47, alpha: 1.000))
    static let accentColor1 = Color(UIColor(red: 1, green: 0.576, blue: 0, alpha: 1.000))
//    static let backgroundColor = Color(UIColor(red: 0.945, green: 0.969, blue: 0.984, alpha: 1.000))
    static let backgroundColor = Color(UIColor.secondarySystemGroupedBackground)
    static let topFrameSize = CGSize(width: 75, height: 24)
    static let tabbarHeight = CGFloat(49)
    static let bottomSafeArea = CGFloat(40)
    static let iconCircleEdge = CGFloat(40)
    static let labelOffset = CGSize(width: 0, height: 32)
    static let bottomSafeAreaOffset = CGSize(width: 0, height: Defs.bottomSafeArea * 0.5)
    static let topSafeAreaOffset = CGSize(width: 0, height: -Defs.bottomSafeArea * 0.5)
}

struct ScrollingTabView: View {
    @StateObject private var sharedData = SharedData()
    var body: some View {
        ZStack {
            if sharedData.activeTabIndex == 0 {
                VStack {
                    FixtureView()
                        .environmentObject(sharedData)
                    Text("")
                        .frame(height: 49)
                }
            }
            if sharedData.activeTabIndex == 1 {
                VStack {
                    LadderView()
                        .environmentObject(sharedData)
                    Text("")
                        .frame(height: 49)
                }
            }
            if sharedData.activeTabIndex == 2 {
                VStack {
                    RoundView()
                        .environmentObject(sharedData)
                    Text("")
                        .frame(height: 49)
                }
            }
            if sharedData.activeTabIndex == 3 {
                VStack {
                    StatisticsView()
                        .environmentObject(sharedData)
                    Text("")
                        .frame(height: 49)
                }
            }
            if sharedData.activeTabIndex == 4 {
                VStack {
                    SetTeamsView()
                        .environmentObject(sharedData)
                    Text("")
                        .frame(height: 49)
                }
            }
            GeometryReader { proxy in
                VStack {
                    Spacer()
                    HStack(alignment: .bottom, spacing: 0){
                        ForEach(0..<5) { (index) in
                            VStack(spacing: 0) {
                                Spacer()
                                Rectangle()
                                    .foregroundColor( .clear )
                                    .frame(width: Defs.iconCircleEdge, height: Defs.iconCircleEdge)
                                    .overlay(
                                        ZStack {
                                            Defs.tabItems[index].iconView(Defs.accentColor).opacity(sharedData.activeTabIndex == index ? 1.0 : 0.0)
                                            Defs.tabItems[index].iconView(Color(.lightGray)).opacity(sharedData.activeTabIndex != index ? 1.0 : 0.0)
                                        }
                                    )
                                    .background(
                                        ZStack {
                                            Defs.tabItems[index].labelView(.white).opacity(sharedData.activeTabIndex == index ? 1.0 : 0.0)
                                            Defs.tabItems[index].labelView(.clear).opacity(sharedData.activeTabIndex != index ? 1.0 : 0.0)
                                        }.offset(Defs.labelOffset)
                                    )
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(height: sharedData.activeTabIndex == index ? 26 : 5)
                            }
                            .frame(width: proxy.size.width * 0.2)
                            .contentShape( Rectangle() )
                            .onTapGesture {
                                withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.7) ) { sharedData.activeTabIndex = index }
                            }
                        }
                    }
                    .background(
                        Rectangle()
                            .frame(height: Defs.topFrameSize.height + Defs.tabbarHeight + Defs.bottomSafeArea)
                            .overlay(
                                Circle()
                                    .foregroundColor(Defs.accentColor1)
                                    .frame(width: Defs.iconCircleEdge, height: Defs.iconCircleEdge)
                                    .offset(CGSize(width: CGFloat(sharedData.activeTabIndex - 2) * (proxy.size.width * 0.2), height: -29))
                            )
                            .foregroundColor(Defs.accentColor)
                            .offset(Defs.bottomSafeAreaOffset)
                            .mask(
                                VStack(spacing: 0) {
                                    TopFrameView()
                                        .frame(width: Defs.topFrameSize.width, height: Defs.topFrameSize.height)
                                        .offset(CGSize(width: CGFloat(sharedData.activeTabIndex - 2) * (proxy.size.width * 0.2), height: 0))
                                    Rectangle()
                                        .frame(height: Defs.tabbarHeight + Defs.bottomSafeArea)
                                }.offset(Defs.bottomSafeAreaOffset)
                            )
                            .shadow(color: Color.black.opacity(0.3) , radius: 15, x: 0, y: 0)
                    )
                    .frame(height: Defs.topFrameSize.height + Defs.tabbarHeight)
                }
            }.ignoresSafeArea(edges: [.trailing, .leading, .top])
        }.background(Defs.backgroundColor)
    }
}

#Preview {
    ScrollingTabView()
}
