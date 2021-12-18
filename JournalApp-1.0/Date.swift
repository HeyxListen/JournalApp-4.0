//
//  Date.swift
//  JournalApp-1.0
//
//  Created by STEPHENCOFFARO on 12/7/21.
//

import Foundation

//struct TimeOfEntry: Codable {
//    var year: Int
//    var monthNumber: Int
//    var monthString: String
//    var monthAbv: String
//    var day: Int
//    var dayOfWeek: String
//    var time: String
//}
//
//func getTimeOfEntry() -> TimeOfEntry {
//    let now = Date()
//    let dateFormatter = DateFormatter()
//    //YEAR INT
//    dateFormatter.dateFormat = "yyyy"
//    let yearString = dateFormatter.string(from: now)
//    let yearInt = Int(yearString) ?? 2222
//    //MONTH NUM INT
//    dateFormatter.dateFormat = "MM"
//    let monthString = dateFormatter.string(from: now)
//    let monthInt = Int(monthString) ?? 0
//    //MONTH STRING
//    dateFormatter.dateFormat = "MMMM"
//    let nameOfMonth = dateFormatter.string(from: now)
//    //MONTH ABV STRING
//    dateFormatter.dateFormat = "LLLL"
//    let first3LettersOfMonth = nameOfMonth.prefix(3).uppercased()
//    //DAY OF WEEK STRING
//    dateFormatter.dateFormat = "EEEE"
//    let dayOfTheWeekString = dateFormatter.string(from: now)
//    //DAY INT
//    dateFormatter.dateFormat = "dd"
//    let dayOfMonthIntStillString = dateFormatter.string(from: now)
//    let dayOfMonthInt = Int(dayOfMonthIntStillString) ?? 0
//    //TIME STRING
//    dateFormatter.dateFormat = "HH:mm"
//    let timeString = dateFormatter.string(from: now)
//  
//    let thisTimeOfEntry = TimeOfEntry(year: yearInt, monthNumber: monthInt, monthString: nameOfMonth, monthAbv: first3LettersOfMonth, day: dayOfMonthInt, dayOfWeek: dayOfTheWeekString,time: timeString)
//    
//    return thisTimeOfEntry
//}
