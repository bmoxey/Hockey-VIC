//
//  GeneralFunctions.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 14/11/2023.
//

import Foundation
import SwiftUI

func GetUrl(url: String) -> ([String], String) {
    guard let myUrl = URL(string: url)
    else {
        return ([], url)
    }
    do {
        guard let html = fetchData(from: myUrl)
        else {
            return ([], url)
        }
        let delimiters: Set<Character> = ["<", ">"]
        return (html.split(whereSeparator: { delimiters.contains($0) }).map(String.init), "")
    }
}

func fetchData(from url: URL) -> String? {
    var result: String?
    let semaphore = DispatchSemaphore(value: 0)
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        defer { semaphore.signal() }
        if let error = error {
            print("Error: \(error)")
            return
        }
        if let data = data, let htmlString = String(data: data, encoding: .utf8) {
            result = htmlString
        }
    }.resume()
    semaphore.wait()
    return result
}

func ShortTeamName(fullName: String) -> String {
    let newString = fullName.replacingOccurrences(of: " Hockey", with: "")
        .replacingOccurrences(of: " Club", with: "")
        .replacingOccurrences(of: " Association", with: "")
        .replacingOccurrences(of: " Sports INC", with: "")
        .replacingOccurrences(of: " Section", with: "")
        .replacingOccurrences(of: " United", with: " Utd")
        .replacingOccurrences(of: "Hockey ", with: "")
        .replacingOccurrences(of: "University", with: "Uni")
        .replacingOccurrences(of: "Eastern Christian Organisation (ECHO)", with: "ECHO")
        .replacingOccurrences(of: "Melbourne High School Old Boys", with: "MHSOB")
        .replacingOccurrences(of: "Greater ", with: "")
        .replacingOccurrences(of: "St Bede's", with: "St. Bede's")
        .replacingOccurrences(of: "Khalsas", with: "Khalsa")
    return newString
}

func ShortClubName(fullName: String) -> String {
    let newString = fullName.replacingOccurrences(of: " 1", with: "")
        .replacingOccurrences(of: " 2", with: "")
        .replacingOccurrences(of: " 3", with: "")
        .replacingOccurrences(of: " 4", with: "")
        .replacingOccurrences(of: "Southern A", with: "Southern Utd")
        .replacingOccurrences(of: "Southern B", with: "Southern Utd")
        .replacingOccurrences(of: "Southern C", with: "Southern Utd")
        .replacingOccurrences(of: " Black", with: "")
        .replacingOccurrences(of: " BLACK", with: "")
        .replacingOccurrences(of: " Blues", with: "")
        .replacingOccurrences(of: " Blue", with: "")
        .replacingOccurrences(of: " Navy", with: "")
        .replacingOccurrences(of: " Gold", with: "")
        .replacingOccurrences(of: " Yellow", with: "")
        .replacingOccurrences(of: " Red", with: "")
        .replacingOccurrences(of: " RED", with: "")
        .replacingOccurrences(of: " Silver", with: "")
        .replacingOccurrences(of: " Green", with: "")
        .replacingOccurrences(of: " Grey", with: "")
        .replacingOccurrences(of: " Jade", with: "")
        .replacingOccurrences(of: " Maroon", with: "")
        .replacingOccurrences(of: " Tangerine", with: "")
        .replacingOccurrences(of: " Lions", with: "")
        .replacingOccurrences(of: " Panthers", with: "")
        .replacingOccurrences(of: " Pumas", with: "")
        .replacingOccurrences(of: " Tigers", with: "")
        .replacingOccurrences(of: " White", with: "")
        .replacingOccurrences(of: " Cougars", with: "")
        .replacingOccurrences(of: " Cheetahs", with: "")
        .replacingOccurrences(of: " Leopards", with: "")
        .replacingOccurrences(of: " Sharks", with: "")
        .replacingOccurrences(of: " Knights", with: "")
        .replacingOccurrences(of: " Saffrons", with: "")
        .replacingOccurrences(of: " Cannons", with: "")
        .replacingOccurrences(of: " Ospreys", with: "")
        .replacingOccurrences(of: " Falcons", with: "")
        .replacingOccurrences(of: " Kestrels", with: "")
        .replacingOccurrences(of: " Modules", with: " Uni")
        .replacingOccurrences(of: " Monarchs", with: " Uni")
        .replacingOccurrences(of: " Vultures", with: "")
        .replacingOccurrences(of: " Unicorns", with: "")
        .replacingOccurrences(of: " Eagles", with: "")
        .replacingOccurrences(of: " LIGHTNING", with: "")
        .replacingOccurrences(of: " THUNDER", with: "")
        .replacingOccurrences(of: " U8", with: "")
        .replacingOccurrences(of: " U10", with: "")
        .replacingOccurrences(of: " U12", with: "")
        .replacingOccurrences(of: " U14", with: "")
        .replacingOccurrences(of: " U16", with: "")
        .replacingOccurrences(of: " - ", with: "")
        .replacingOccurrences(of: " -", with: "")
        .replacingOccurrences(of: "  HC", with: "")
        .replacingOccurrences(of: " HC", with: "")
        .replacingOccurrences(of: "Boxmakers", with: "Monash Uni")
        .replacingOccurrences(of: "Chumps", with: "KBH Brumbies")
        .replacingOccurrences(of: "Collions-X", with: "Collegians-X")
        .replacingOccurrences(of: "ECC", with: "Dandenong Warriors")
        .replacingOccurrences(of: "GDWHC", with: "Dandenong Warriors")
        .replacingOccurrences(of: "HHC", with: "Hawthorn")
        .replacingOccurrences(of: "OEMHC", with: "Old East Malvern")
        .replacingOccurrences(of: "OTGHC", with: "Old Trinity Grammarians'")
        .replacingOccurrences(of: "Old Xav's", with: "Old Xaverians")
        .replacingOccurrences(of: "Old Xavs", with: "Old Xaverians")
        .replacingOccurrences(of: "PHStK", with: "Powerhouse & St Kilda")
        .replacingOccurrences(of: "The Third Team", with: "Toorak East Malvern")
        .replacingOccurrences(of: "SUHC Social", with: "Southern Utd")
        .replacingOccurrences(of: "Sharks", with: "Cardinia Storm")
        .replacingOccurrences(of: "TEM", with: "Toorak East Malvern")
        .replacingOccurrences(of: "Toorak East MalvernHC", with: "Toorak East Malvern")
        .replacingOccurrences(of: "Southern", with: "Southern Utd")
        .replacingOccurrences(of: "Southern Utd Utd", with: "Southern Utd")
        .replacingOccurrences(of: "/", with: "-")
    return newString
}

func GetDivType(fullName: String) -> String {
    var newString = "Other 👽"
    if fullName.contains("Under") {newString = "mixed 👦🏻👧🏻" }
    if fullName.contains("U8") { newString = "mixed 👦🏻👧🏻"}
    if fullName.contains("U10") { newString = "mixed 👦🏻👧🏻"}
    if fullName.contains("U12") { newString = "mixed 👦🏻👧🏻"}
    if fullName.contains("U14") { newString = "mixed 👦🏻👧🏻"}
    if fullName.contains("U16") { newString = "mixed 👦🏻👧🏻"}
    if fullName.contains("U18") { newString = "mixed 👦🏻👧🏻"}
    if fullName.contains("Mixed") { newString = "mixed 👦🏻👧🏻" }
    if fullName.contains("Men") { newString = "Mens 👨🏻" }
    if fullName.contains("Women") { newString = "Womens 👩🏻" }
    if fullName.contains("Boy") { newString = "boys 👦🏻" }
    if fullName.contains("Girl") { newString = "girls 👧🏻" }
    if fullName.contains("+") && fullName.contains("Men") { newString = "vets Mens 👴🏻" }
    if fullName.contains("+") && fullName.contains("Women") { newString = "vets Womens 👵🏻" }
    return newString
}


func GetDivLevel(fullString: String) -> String {
    var newString: String = "Z"
    if fullString.contains("Premier League") {newString = "A"}
    if fullString.contains("Shield") {newString = "B"}
    if fullString.contains("Vic League") {newString = "C"}
    if fullString.contains("Pennant") {newString = "D"}
    if fullString.contains("Metro") {newString = "E"}
    if fullString.contains("District") {newString = "F"}
    if fullString.contains("U8") {newString = "A\(newString)"}
    if fullString.contains("U10") {newString = "B\(newString)"}
    if fullString.contains("U12") {newString = "C\(newString)"}
    if fullString.contains("U14") {newString = "D\(newString)"}
    if fullString.contains("U16") {newString = "E\(newString)"}
    if fullString.contains("U18") {newString = "F\(newString)"}
    return newString
}

func ShortDivName(fullName: String) -> String {
    var newString = fullName.replacingOccurrences(of: "GAME Clothing ", with: "")
    if let firstFourDigits = Int(newString.prefix(4)), firstFourDigits > 1000 { newString.removeFirst(4) }
    if let lastFourDigits = Int(newString.suffix(4)), lastFourDigits > 1000 { newString.removeLast(4) }
    newString = newString.trimmingCharacters(in: .whitespaces)
        .trimmingCharacters(in: .punctuationCharacters)
        .trimmingCharacters(in: .whitespaces)
    return newString
}

func GetStart(inputDate: String?) -> (String, String) {
    var message: String
    var played: String
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "E dd MMM yyyy HH:mm"
    
    guard let inputDate = inputDate,
          let startDate = dateFormatter.date(from: inputDate) else {
        message = "Invalid date"
        played = "Completed"
        return (message, played)
    }
    let today = Date.now
    
    let diffComponents = Calendar.current.dateComponents([.day, .hour, .minute], from: today, to: startDate)
    let days = diffComponents.day
    let hrs = diffComponents.hour
    if days! > 0 || (days! == 0 && hrs! > 0){
        message = "Starts in \(days!) days and \(hrs!) hours"
        played = "Upcoming"
    } else {
        message = ""
        played = "Completed"
    }
    return (message, played)
}

func GetScores(scores: String, seperator: String) -> (Int, Int) {
    var homeScore = 0
    var awayScore = 0
    if scores.contains(seperator) {
        let myScores = scores.components(separatedBy: seperator)
        homeScore = Int(myScores[0].trimmingCharacters(in: .whitespaces)) ?? 0
        awayScore = Int(myScores[1].trimmingCharacters(in: .whitespaces)) ?? 0
    }
    return (homeScore, awayScore)
}

func GetHomeTeam(result: String, homeGoals: Int, awayGoals: Int, myTeam: String, opponent: String, rounds: [Round], venue: String) -> (String, String) {
    var homeTeam = myTeam
    var awayTeam = ""
    if result == "Win" {
        if homeGoals > awayGoals {
            homeTeam = myTeam
            awayTeam = opponent
        } else {
            homeTeam = opponent
            awayTeam = myTeam
        }
    }
    if result == "Loss" {
        if homeGoals > awayGoals {
            homeTeam = opponent
            awayTeam = myTeam
        } else {
            homeTeam = myTeam
            awayTeam = opponent
        }
    }
    if result == "Draw" {
        let venueFrequency = rounds.reduce(into: [:]) { counts, round in
            counts[round.venue, default: 0] += 1
        }
        if let mostCommonVenue = venueFrequency.max(by: { $0.value < $1.value })?.key {
            if venue == mostCommonVenue {
                homeTeam = myTeam
                awayTeam = opponent
            } else {
                homeTeam = opponent
                awayTeam = myTeam
            }
        } else {
            homeTeam = opponent
            awayTeam = myTeam
        }
    }
    return (homeTeam, awayTeam)
}

func BarBackground(result: String) -> Color {
    switch result {
    case "Win":
        return Color.green
    case "+FF":
        return Color.mint
    case "+FL":
        return Color.mint
    case "Loss":
        return Color.red
    case "-FF":
        return Color.pink
    case "-FL":
        return Color.pink
    case "Draw":
        return Color.gray
    case "BYE":
        return Color.blue
    case "No Data":
        return Color.purple
    default:
        return Color.cyan
    }
}

func GetResult(myTeam: String, homeTeam: String, awayTeam: String, homeGoals: Int, awayGoals: Int) -> String {
    var result = ""
    if homeGoals == awayGoals { result = "Draw" }
    if homeTeam == myTeam && homeGoals > awayGoals {  result = "Win"}
    if homeTeam == myTeam && homeGoals < awayGoals {  result = "Loss"}
    if awayTeam == myTeam && homeGoals > awayGoals {  result = "Loss"}
    if awayTeam == myTeam && homeGoals < awayGoals {  result = "Win"}
    return result
}

func FixName(fullname: String) -> (String, String, Bool) {
    var myCap = false
    var myName = fullname
    if myName.contains(" (Captain)") {
        myCap = true
        myName = myName.replacingOccurrences(of: " (Captain)", with: "")
    }
    let mybits = myName.split(separator: ",")
    var surname = ""
    if mybits.count > 0 {
        surname = mybits[0].trimmingCharacters(in: .whitespaces).capitalized
        if surname.contains("'") {
            let mybits1 = surname.split(separator: "'")
            surname = mybits1[0].capitalized + "'" + mybits1[1].capitalized
        }
        let name = surname
        let surname = name.count >= 3 && name.lowercased().hasPrefix("mc") ? String(name.prefix(2)) + name[name.index(name.startIndex, offsetBy: 2)].uppercased() + String(name.suffix(from: name.index(after: name.index(name.startIndex, offsetBy: 2)))) : name
        myName = mybits[1].trimmingCharacters(in: .whitespaces).capitalized + " " + surname
    }
    return(myName, surname, myCap)
}

func GetRound(fullString: String) -> String {
    let newString = fullString.replacingOccurrences(of: "Round ", with: "R")
        .replacingOccurrences(of: "Finals", with: "F")
        .replacingOccurrences(of: "Semi ", with: "S")
        .replacingOccurrences(of: "Preliminary ", with: "P")
        .replacingOccurrences(of: "Grand ", with: "G")
    return newString
}
