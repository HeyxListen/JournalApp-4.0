//
//  HomeViewController.swift
//  JournalApp-1.0
//
//  Created by STEPHENCOFFARO on 12/3/21.
//

import UIKit

class HomeViewController: UIViewController, UITabBarControllerDelegate {
        
    @IBOutlet var dayOfWeekTextLabel: UILabel!
    @IBOutlet var dateTextLabel: UILabel!
    @IBOutlet var quoteTextLabel: UILabel!
    @IBOutlet var authorTextLabel: UILabel!
    //
    @IBOutlet var allTimeTotal: UILabel!
    @IBOutlet var thisMonthTotal: UILabel!
    @IBOutlet var sevenDayAverageTotal: UILabel!
    @IBOutlet var allTimeAvgEmotion: UILabel!
    @IBOutlet var thisMonthAvgEmotion: UILabel!
    @IBOutlet var sevenDayAvgEmotion: UILabel!
    @IBOutlet var dynamicFlowerImage: UIImageView!
    @IBOutlet var dynamicGrowthLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSavedEntries()
        updateHomePageUI()
        
//        let encoder = JSONDecoder()
//
//        if let data = try? encoder.decode(Decod, from: <#T##Data#>)(jasonProfile) {
//            UserDefaults.standard.set(data, forKey: "UserData")
//        }
        
        let displayQuote = quotes.randomElement()!
        quoteTextLabel.text = "\"\(displayQuote.quote)\""
        authorTextLabel.text = "-\(displayQuote.author)"
        
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateHomePageUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
    }

 
    
    func updateHomePageUI() {
        let todaysDate = getTime()
        dayOfWeekTextLabel.text = "\(todaysDate.dayOfWeek),"
        dateTextLabel.text = "\(todaysDate.monthString) \(todaysDate.day), \(todaysDate.year)"
        //Update Flower
        updateFlower()
        dynamicGrowthLabel.text = updateGrowthLabel(entries: entries)
        //Total Entries
        allTimeTotal.text = "\(entries.count)"
        allTimeAvgEmotion.text = averageMoodDisplay(for: entries)
        //This Month Totals
        let entriesThisMonth = entriesInCurrentMonth(entries)
        thisMonthTotal.text = String(entriesThisMonth.count)
        thisMonthAvgEmotion.text = averageMoodDisplay(for: entriesThisMonth)
        //7-Day Average Totals
        let entriesInLastSevenDays = entriesInLastSevenCalendarDays(entries)
        sevenDayAverageTotal.text = String(entriesInLastSevenDays.count)
        sevenDayAvgEmotion.text = averageMoodDisplay(for: entriesInLastSevenDays)
        
    }
    //
    //FUNCTIONS AND METHODS FOR CALCULATING TOTALS FOR HOME PAGE BELOW HERE
    
    //UPDATE FLOWER IMAGE & LABEL
    func updateFlower() {
        let entriesThisMonth = entriesInCurrentMonth(entries).count
        
        switch entriesThisMonth {
        case 0...1:
            dynamicFlowerImage.image = UIImage(named: "Sunflower dead")
        case 2...6:
            dynamicFlowerImage.image = UIImage(named: "Sunflower growing")
        case 7...12:
            dynamicFlowerImage.image = UIImage(named: "Sunflower Transparent")
        case 13...999:
            dynamicFlowerImage.image = UIImage(named: "Sunflower glowing")
        default:
            dynamicFlowerImage.image = UIImage(named: "Sunflower ")
        }
       //dynamicFlowerImage.image!
    }
    
    func updateGrowthLabel(entries: [JournalEntry]) -> String {
        let numberOfEntries = entriesInCurrentMonth(entries).count
        var labelString: String = ""
        
        switch numberOfEntries {
        case 0..<2:
            labelString = "Your flower could use some help. Add some more entries this month to encourage growth."
        case 2..<7:
            labelString = "You are off to a great start. Keep at it and your flower will flourish."
        case 7..<13:
            labelString = "Your flower has wonderfully bloomed. Keep it up!"
        default:
            labelString = "Your flower is in superb health and is shining a radiant light"
        }
        return labelString
    }
    
    private func averageMoodDisplay(for entries: [JournalEntry]) -> String {
        guard !entries.isEmpty else { return "—" }

        let moodTotal = entries.reduce(0) { $0 + $1.moodNumber }
        let roundedAverage = Int((Double(moodTotal) / Double(entries.count)).rounded())
        return getEmoji(emojiValue: roundedAverage)
    }

    private func entriesInCurrentMonth(_ entries: [JournalEntry]) -> [JournalEntry] {
        let current = Calendar.current.dateComponents([.year, .month], from: Date())
        guard let currentYear = current.year, let currentMonth = current.month else { return [] }

        return entries.filter {
            $0.loggedTime.year == currentYear && $0.loggedTime.monthNumber == currentMonth
        }
    }

    private func entriesInLastSevenCalendarDays(_ entries: [JournalEntry]) -> [JournalEntry] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        guard
            let startDate = calendar.date(byAdding: .day, value: -6, to: today),
            let endDate = calendar.date(byAdding: .day, value: 1, to: today)
        else {
            return []
        }

        return entries.filter { entry in
            guard let entryDate = calendarDate(for: entry) else { return false }
            return entryDate >= startDate && entryDate < endDate
        }
    }

    private func calendarDate(for entry: JournalEntry) -> Date? {
        Calendar.current.date(from: DateComponents(
            year: entry.loggedTime.year,
            month: entry.loggedTime.monthNumber,
            day: entry.loggedTime.day
        ))
    }

    
    //END OF FUNCTIONS FOR HOME PAGE
    //
}
