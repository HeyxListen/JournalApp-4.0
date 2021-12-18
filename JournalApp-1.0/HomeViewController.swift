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
        allTimeAvgEmotion.text = getEmoji(emojiValue: (checkAverageEmotionOfAllEntries(entries: entries)))
        //This Month Totals
        thisMonthTotal.text = String(checkIfEntryInCurrentMonth(entries: entries))
        thisMonthAvgEmotion.text = getEmoji(emojiValue: (checkAverageEmotionInCurrentMonth(entries: entries)))
        //7-Day Average Totals
        sevenDayAverageTotal.text = String(checkEntriesIn7DayAvg(entries: entries))
        sevenDayAvgEmotion.text = getEmoji(emojiValue: (checkAverageEmotionIn7Day(entries: entries)))
        
    }
    //
    //FUNCTIONS AND METHODS FOR CALCULATING TOTALS FOR HOME PAGE BELOW HERE
    
    //UPDATE FLOWER IMAGE & LABEL
    func updateFlower() {
        let entriesThisMonth = checkIfEntryInCurrentMonth(entries: entries)
        
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
        let numberOfEntries = checkIfEntryInCurrentMonth(entries: entries)
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
    
    //ALL TIME
    func checkAverageEmotionOfAllEntries(entries: [JournalEntry]) -> Int {
        var totalEntries: Int = 0
        var sumOfEntryEmotionsInTotal: Int = 0
        var averageEmotionScore: Int = 0
        for entry in entries {
            totalEntries += 1
            sumOfEntryEmotionsInTotal += entry.moodNumber
            }
        if (totalEntries != 0) {
            averageEmotionScore = Int((sumOfEntryEmotionsInTotal/totalEntries))
        } else {
            averageEmotionScore = 1
        }
        
        return averageEmotionScore
    }
    
    //CURRENT MONTH
    func checkIfEntryInCurrentMonth(entries: [JournalEntry]) -> Int {
        var numberOfEntriesInMonth: Int = 0
        let now = Date()
        let dateFormatter = DateFormatter()
        //YEAR INT
        dateFormatter.dateFormat = "yyyy"
        let yearString = dateFormatter.string(from: now)
        let thisYearInt = Int(yearString) ?? 2222
        //MONTH NUM INT
        dateFormatter.dateFormat = "MM"
        let monthString = dateFormatter.string(from: now)
        let thisMonthInt = Int(monthString) ?? 0
        
        for entry in entries {
            if (entry.loggedTime.monthNumber ==  thisMonthInt) && (entry.loggedTime.year ==  thisYearInt) {
                numberOfEntriesInMonth += 1
            }
        }
        return numberOfEntriesInMonth
    }
    
    func checkAverageEmotionInCurrentMonth(entries: [JournalEntry]) -> Int {
        var numberOfEntriesInMonth: Int = 0
        var sumOfEntryEmotionsInMonth: Int = 0
        var averageEmotionScore: Int
        let now = Date()
        let dateFormatter = DateFormatter()
        //YEAR INT
        dateFormatter.dateFormat = "yyyy"
        let yearString = dateFormatter.string(from: now)
        let thisYearInt = Int(yearString) ?? 2222
        //MONTH NUM INT
        dateFormatter.dateFormat = "MM"
        let monthString = dateFormatter.string(from: now)
        let thisMonthInt = Int(monthString) ?? 0
        
        for entry in entries {
            if (entry.loggedTime.monthNumber ==  thisMonthInt) && (entry.loggedTime.year ==  thisYearInt) {
                numberOfEntriesInMonth += 1
                sumOfEntryEmotionsInMonth += entry.moodNumber
            }
        }
        if (numberOfEntriesInMonth != 0) {
            averageEmotionScore = Int((sumOfEntryEmotionsInMonth/numberOfEntriesInMonth))
        } else {
            averageEmotionScore = 1
        }
        return averageEmotionScore
    }
    
    //7-DAY AVERAGE
    func checkEntriesIn7DayAvg(entries: [JournalEntry]) -> Int {
        var numberOfEntriesIn7Days: Int = 0
        let now = Date()
        let dateFormatter = DateFormatter()
        //DATE OF YEAR INT
        dateFormatter.dateFormat = "DD"
        let dayString = dateFormatter.string(from: now)
        let thisDayInt = Int(dayString) ?? 0
            
        for entry in entries {
            if (entry.loggedTime.dayInYear >= (thisDayInt - 7)) {
                numberOfEntriesIn7Days += 1
            } else { }
        }
        return numberOfEntriesIn7Days
    }
    
    func checkAverageEmotionIn7Day(entries: [JournalEntry]) -> Int {
        var numberOfEntriesIn7Days: Int = 0
        var sumOfEntryEmotionsIn7Day: Int = 0
        var averageEmotionScore: Int
        let now = Date()
        let dateFormatter = DateFormatter()
        //DATE OF YEAR INT
        dateFormatter.dateFormat = "DD"
        let dayString = dateFormatter.string(from: now)
        let thisDayInt = Int(dayString) ?? 0

        for entry in entries {
            if (entry.loggedTime.dayInYear >= (thisDayInt - 7)) {
                numberOfEntriesIn7Days += 1
                sumOfEntryEmotionsIn7Day += entry.moodNumber
            }
        }
        
        if (numberOfEntriesIn7Days != 0) {
        averageEmotionScore = Int((sumOfEntryEmotionsIn7Day/numberOfEntriesIn7Days))
        } else {
            averageEmotionScore = 1
        }
        return averageEmotionScore
    }

    
    //END OF FUNCTIONS FOR HOME PAGE
    //
}
