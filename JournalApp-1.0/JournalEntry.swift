//
//  JournalEntry.swift
//  JournalApp-1.0
//
//  Created by STEPHENCOFFARO on 12/7/21.
//

import Foundation

struct JournalEntry: Codable {
    var loggedTime: TimeOfEntry
    var type: String
    var category: Category
    var moodNumber: Int
    var mood: String
    var subject: String
    var content: String
    
    
    struct Category: Codable {
    var work: Bool
    var school: Bool
    var relationships: Bool
    var finances: Bool
    var health: Bool
    var goals: Bool
    }
    
    struct TimeOfEntry: Codable {
    var year: Int
    var monthNumber: Int
    var monthString: String
    var monthAbv: String
    var day: Int
    var dayInYear: Int
    var dayOfWeek: String
    var time: String
    }
    
    
    static var archiveURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL =
            documentsDirectory.appendingPathComponent("entries")
            .appendingPathExtension("plist")
        return archiveURL
    }
    
    static func saveToFile(entries: [JournalEntry]) {
        let propertyListEncoder = PropertyListEncoder()
        let encodedEntries = try? propertyListEncoder.encode(entries)
        
        try? encodedEntries?.write(to: archiveURL, options: .noFileProtection)
    }
    
    static func loadFromFile() -> [JournalEntry]? {
        let propertyListDecoder = PropertyListDecoder()
        guard let retrievedEntries = try? Data(contentsOf: archiveURL) else {
            return nil
        }
        let decodedEntries = try? propertyListDecoder.decode(Array<JournalEntry>.self, from: retrievedEntries)
        return decodedEntries
    }
    
//    static var sampleEntries: [JournalEntry] {
//        return [
//            JournalEntry(loggedTime: TimeOfEntry(year: 2021, monthNumber: 12, monthString: "December", monthAbv: "DEC", day: 17, dayInYear: 251,  dayOfWeek: "Friday", time: "12:10"), type: "Manual", category: Category(work: false, school: true, relationships: false, finances: false, health: false, goals: true), moodNumber: 5, mood: "🤗", subject: "Almost finish with the semester", content: "I am almost finished with this school semester. It has been a bit different not having to sustain a job and to really focus on finals these past couple weeks. I am thankful for the extra time I have been able to take away from work, and to dedicate that time to school and relationships."),
//            JournalEntry(loggedTime: TimeOfEntry(year: 2021, monthNumber: 12, monthString: "December", monthAbv: "DEC", day: 14, dayInYear: 348,  dayOfWeek: "Tuesday", time: "12:10"), type: "Prompt", category: Category(work: false, school: false, relationships: true, finances: false, health: true, goals: false), moodNumber: 4, mood: "😌", subject: "PROMPT: What matters most in my life right now is...", content: "My boyfriend and my cat. Both have been sosupportive to me lately, and I love them very much, I am grateful for the opportunity I have to be with them this holiday season, and I am really looking forward to the conclusion of this semester so that we can have some quality time."),
//            JournalEntry(loggedTime: TimeOfEntry(year: 2021, monthNumber: 12, monthString: "December", monthAbv: "DEC", day: 10, dayInYear: 350,  dayOfWeek: "Friday", time: "18:20"), type: "Manual", category: Category(work: false, school: true, relationships: true, finances: false, health: false, goals: false), moodNumber: 2, mood: "😰", subject: "Celebrating Graduation!", content: "I have several friends that will be graduating by the end of this semester. It is bitter-sweet, because, of course, I will miss them! We are taking the opportunity to find some ways to celebrate, and I look forward to connecting with them.💙"),
//            JournalEntry(loggedTime: TimeOfEntry(year: 2021, monthNumber: 12, monthString: "December", monthAbv: "DEC", day: 8, dayInYear: 0, dayOfWeek: "Wednesday", time: "10:45"), type: "Quote", category: Category(work: true, school: false, relationships: true, finances: true, health: false, goals: true), moodNumber: 5, mood: "🤗", subject: "QUOTE: You are not going nowhere just because you haven't arrived at your final destination yet. - Taylor Swift", content: "I have been a bit stressed about not having a job or internship lined up yet. I have been setting aside time to connect with potential leads, updating my resume, and focusing on my portfolio. This quote helped to remind me that, although I have not accomplished my goals yet, I am still moving forward, and I look forward to continuing that growth and motion. Onward!"),
//            JournalEntry(loggedTime: TimeOfEntry(year: 2021, monthNumber: 12, monthString: "December", monthAbv: "DEC", day: 3, dayInYear: 323, dayOfWeek: "Friday", time: "09:00"), type: "Manual", category: Category(work: false, school: false, relationships: true, finances: false, health: true, goals: true), moodNumber: 4, mood: "😌", subject: "Ran into an old friend", content: "I ran into an old friend, Anne, at the gym today! I had not seen her since the start of the pandemic. It was really good to see her, and to know she is doing well. She let me know that she would be around much more in the future, and I look forward to seeing her around. 😁"),
//            JournalEntry(loggedTime: TimeOfEntry(year: 2021, monthNumber: 12, monthString: "December", monthAbv: "DEC", day: 1, dayInYear: 321, dayOfWeek: "Wednesday", time: "20:29"), type: "Quote", category: Category(work: false, school: true, relationships: false, finances: false, health: false, goals: false), moodNumber: 4, mood: "😌", subject: "QUOTE: I have not failed. I've just found 10,000 ways that won't work. - Thomas Jefferson", content: "I have been struggling to get some of the bugs on my app to work - mostly having issues with constraints. It has been a bit frustrating to try to figure it out, but I made SOME progress today, and I do not feel like a failure after all. I will get back at it tomorrow."),
//            JournalEntry(loggedTime: TimeOfEntry(year: 2021, monthNumber: 11, monthString: "November", monthAbv: "NOV", day: 30, dayInYear: 320, dayOfWeek: "Tuesday", time: "07:01"), type: "Manual", category: Category(work: false, school: false, relationships: true, finances: false, health: true, goals: true), moodNumber: 5, mood: "🤗", subject: "A good start to a bright day!", content: "I woke up feeling GREAT today. ☀️ I was up last night doing some homework, and I told myself that I would wake up early to get some chores done. Now that I am ahead of the curve, I may go to the gym and do some mixed-martial arts. I started a load of laundry and the day is young."),
//            JournalEntry(loggedTime: TimeOfEntry(year: 2021, monthNumber: 11, monthString: "November", monthAbv: "NOV", day: 29, dayInYear: 300, dayOfWeek: "Monday", time: "16:55"), type: "Prompt", category: Category(work: true, school: true, relationships: false, finances: false, health: true, goals: true), moodNumber: 3, mood: "😐", subject: "What personal goals am I neglecting now? What can I change?", content: "😩 I have a lot of work to do to complete my finals. Although I know I can get it done, I will have to dedicate a lot more time to study for my exams and to complete my app project. My hope is that I can dedicate at least 8 hours of study time, 4 times this week. I am optimistic that I can make it happen. "),
//            JournalEntry(loggedTime: TimeOfEntry(year: 2021, monthNumber: 11, monthString: "November", monthAbv: "NOV", day: 25, dayInYear: 305, dayOfWeek: "Wednesday", time: "16:03"), type: "Prompt", category: Category(work: true, school: true, relationships: true, finances: false, health: true, goals: true), moodNumber: 5, mood: "🤗", subject: "PROMT: What can I do to better protect my mental health?", content: "I have had a great Thanksgiving, and this prompt reminded me that it is okay -- and healthy -- to take a break every now and then. I think I can do a much better job being intentional about taking time off and making good use of that time to rest. It is not lazy to rest, rather, it is productive. I can take a break from work, from school, and that is okay!"),
//            JournalEntry(loggedTime: TimeOfEntry(year: 2021, monthNumber: 11, monthString: "November", monthAbv: "NOV", day: 23, dayInYear: 300, dayOfWeek: "Monday", time: "16:55"), type: "Manual", category: Category(work: false, school: true, relationships: false, finances: false, health: true, goals: false), moodNumber: 1, mood: "😭", subject: "I got my COVID Booster yesterday..", content: "I got my COVID vaccine booster yesterday and I am feeling terrible today. I can hardly focus on my schoolwork, I couldn't go on my run, and it is really uncomfortable to sit. I really hope this passes before Thanksgiving."),
//        ]
    
    
    //
    func checkCategories (entry: JournalEntry) -> String {
        var categoryString = ""
        if (entry.category.work == true) {
            categoryString += "work"
        }
        if (entry.category.school == true) {
            categoryString += "school"
        }
        if (entry.category.relationships == true) {
            categoryString += "relationships"
        }
        if (entry.category.finances == true) {
            categoryString += "finances"
        }
        if (entry.category.health == true) {
            categoryString += "health"
        }
        if (entry.category.goals == true) {
            categoryString += "goals"
        }
        return categoryString
    }

    func getTimeOfEntry() -> TimeOfEntry {
        let now = Date()
        let dateFormatter = DateFormatter()
        //YEAR INT
        dateFormatter.dateFormat = "yyyy"
        let yearString = dateFormatter.string(from: now)
        let yearInt = Int(yearString) ?? 2222
        //MONTH NUM INT
        dateFormatter.dateFormat = "MM"
        let monthString = dateFormatter.string(from: now)
        let monthInt = Int(monthString) ?? 0
        //MONTH STRING
        dateFormatter.dateFormat = "MMMM"
        let nameOfMonth = dateFormatter.string(from: now)
        //MONTH ABV STRING
        dateFormatter.dateFormat = "LLLL"
        let first3LettersOfMonth = nameOfMonth.prefix(3).uppercased()
        //DAY OF WEEK STRING
        dateFormatter.dateFormat = "EEEE"
        let dayOfTheWeekString = dateFormatter.string(from: now)
        //DAY INT
        dateFormatter.dateFormat = "dd"
        let dayOfMonthIntStillString = dateFormatter.string(from: now)
        let dayOfMonthInt = Int(dayOfMonthIntStillString) ?? 0
        //DAY IN YEAR
        dateFormatter.dateFormat = "DD"
        let dayOfMonthIntTotalYearString = dateFormatter.string(from: now)
        let dayOfMonthInYearInt = Int(dayOfMonthIntTotalYearString) ?? 0
        //TIME STRING
        dateFormatter.dateFormat = "HH:mm"
        let timeString = dateFormatter.string(from: now)
        
        let thisTimeOfEntry = TimeOfEntry(year: yearInt, monthNumber: monthInt, monthString: nameOfMonth, monthAbv: first3LettersOfMonth, day: dayOfMonthInt, dayInYear: dayOfMonthInYearInt, dayOfWeek: dayOfTheWeekString,time: timeString)
        
        return thisTimeOfEntry
    }
    
}

struct TimeOfEntry: Codable {
    var year: Int
    var monthNumber: Int
    var monthString: String
    var monthAbv: String
    var day: Int
    var dayInYear: Int
    var dayOfWeek: String
    var time: String
}

func getTime() -> TimeOfEntry {
    let now = Date()
    let dateFormatter = DateFormatter()
    //YEAR INT
    dateFormatter.dateFormat = "yyyy"
    let yearString = dateFormatter.string(from: now)
    let yearInt = Int(yearString) ?? 2222
    //MONTH NUM INT
    dateFormatter.dateFormat = "MM"
    let monthString = dateFormatter.string(from: now)
    let monthInt = Int(monthString) ?? 0
    //MONTH STRING
    dateFormatter.dateFormat = "MMMM"
    let nameOfMonth = dateFormatter.string(from: now)
    //MONTH ABV STRING
    dateFormatter.dateFormat = "LLLL"
    let first3LettersOfMonth = nameOfMonth.prefix(3).uppercased()
    //DAY OF WEEK STRING
    dateFormatter.dateFormat = "EEEE"
    let dayOfTheWeekString = dateFormatter.string(from: now)
    //DAY INT
    dateFormatter.dateFormat = "dd"
    let dayOfMonthIntStillString = dateFormatter.string(from: now)
    let dayOfMonthInt = Int(dayOfMonthIntStillString) ?? 0
    //DAY IN YEAR
    dateFormatter.dateFormat = "DD"
    let dayInYearString = dateFormatter.string(from: now)
    let dayInYearInt = Int(dayInYearString) ?? 0
    //TIME STRING
    dateFormatter.dateFormat = "HH:mm"
    let timeString = dateFormatter.string(from: now)
    
    let thisTimeOfEntry = TimeOfEntry(year: yearInt, monthNumber: monthInt, monthString: nameOfMonth, monthAbv: first3LettersOfMonth, day: dayOfMonthInt, dayInYear: dayInYearInt, dayOfWeek: dayOfTheWeekString, time: timeString)
    
    return thisTimeOfEntry
}

func checkCategory (entry: JournalEntry) -> String {
    var categoryString = ""
    var workString = ""
    var schoolString = ""
    var relationshipString = ""
    var financesString = ""
    var healthString = ""
    var goalsString = ""
    
    if (entry.category.work == true) {
        workString = "work"
    }
    if (entry.category.school == true) {
        schoolString = "school"
    }
    if (entry.category.relationships == true) {
        relationshipString = "relationships"
    }
    if (entry.category.finances == true) {
        financesString = "finances"
    }
    if (entry.category.health == true) {
        healthString = "health"
    }
    if (entry.category.goals == true) {
        goalsString = "goals"
    }
    categoryString = workString+schoolString+relationshipString+financesString+healthString+goalsString
    return categoryString
}

func getEmoji(emojiValue: Int) -> String {
    switch emojiValue {
    case 1:
        return "😭"
    case 2:
        return"😰"
    case 3:
        return"😐"
    case 4:
        return"😌"
    case 5:
        return"🤗"
    default:
        return "☠️"
    }
}

var entries: [JournalEntry] = [] {
    didSet {
        JournalEntry.saveToFile(entries: entries)
    }
}

func loadSavedEntries() {
    if let savedEntries = JournalEntry.loadFromFile() {
        entries = savedEntries
    }
//    else {
//        entries = JournalEntry.sampleEntries
//    }
    
    
}
