//
//  Test.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 17/11/2023.
//

import SwiftUI


struct CountdownView: View {
    @ObservedObject var countdownViewModel: CountdownViewModel

    var body: some View {
        VStack {
            Text("Time until event:")
            Text(countdownViewModel.timeString)
                .font(.largeTitle)
                .padding()
        }
        .onAppear {
            countdownViewModel.startTimer()
        }
        .onDisappear {
            countdownViewModel.stopTimer()
        }
    }
}

class CountdownViewModel: ObservableObject {
    @Published var timeString: String = ""
    private var timer: Timer?

    init(eventDate: Date) {
        updateCountdown(eventDate)
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
            self?.updateCountdown(Date())
        }
        RunLoop.current.add(timer!, forMode: .common)
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func updateCountdown(_ currentDate: Date) {
        let eventDate = Date()
        let timeDifference = Calendar.current.dateComponents([.hour, .minute, .second], from: currentDate, to: eventDate)

        DispatchQueue.main.async { [weak self] in
            self?.timeString = String(format: "%02dh %02dm %02ds", timeDifference.hour ?? 0, timeDifference.minute ?? 0, timeDifference.second ?? 0)
        }
    }
}

struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView(countdownViewModel: CountdownViewModel(eventDate: Date()))
    }
}

