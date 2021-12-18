//
//  ViewEditEntriesTableViewController.swift
//  JournalApp-1.0
//
//  Created by STEPHENCOFFARO on 12/14/21.
//

import UIKit

class ViewEditEntriesTableViewController: UITableViewController {
    //Time & Type of Entry -- Static/non-editable
    @IBOutlet var timeEntryLoggedTextField: UITextField!
    @IBOutlet var typeOfEntryTextField: UITextField!
    //Categories
    @IBOutlet var workButton: UIButton!
    @IBOutlet var schoolButton: UIButton!
    @IBOutlet var relationshipButton: UIButton!
    @IBOutlet var financesButton: UIButton!
    @IBOutlet var healthButton: UIButton!
    @IBOutlet var goalsButton: UIButton!
    //MoodSegementedControl
    @IBOutlet var moodSegmentedControl: UISegmentedControl!
    //Title & Entry Text Views (multi-line)
    @IBOutlet var titleTextView: UITextView!
    @IBOutlet var entryTextView: UITextView!
    
    var journalEntry: JournalEntry?
    
    init?(coder: NSCoder, journalEntry: JournalEntry?) {
        self.journalEntry = journalEntry
        super.init(coder: coder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let journalEntry = journalEntry {
            timeEntryLoggedTextField.text = "\(journalEntry.loggedTime.monthString) \(journalEntry.loggedTime.day), \(journalEntry.loggedTime.year) -  \(journalEntry.loggedTime.time)"
            timeEntryLoggedTextField.isUserInteractionEnabled = false
            typeOfEntryTextField.text = journalEntry.type
            typeOfEntryTextField.isUserInteractionEnabled = false
            workButton.isSelected = journalEntry.category.work
            schoolButton.isSelected = journalEntry.category.school
            relationshipButton.isSelected = journalEntry.category.relationships
            financesButton.isSelected = journalEntry.category.finances
            healthButton.isSelected = journalEntry.category.health
            goalsButton.isSelected = journalEntry.category.goals
            moodSegmentedControl.selectedSegmentIndex = (journalEntry.moodNumber - 1)
            titleTextView.text = journalEntry.subject
            entryTextView.text = journalEntry.content }
    }
        
    @IBAction func selectCategoryButton(_ sender: UIButton) {
        
        if sender.isSelected == false {
        sender.isSelected = true
        } else {
            sender.isSelected = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "saveUnwind" else { return }
        
        let loggedTime = journalEntry?.loggedTime
        let type = journalEntry?.type
        let category = JournalEntry.Category(work: checkButtonState(workButton), school: checkButtonState(schoolButton), relationships: checkButtonState(relationshipButton), finances: checkButtonState(financesButton), health: checkButtonState(healthButton), goals: checkButtonState(goalsButton))
        let mood = getEmoji(emojiValue: moodSegmentedControl.selectedSegmentIndex + 1)
        let moodNumber = moodSegmentedControl.selectedSegmentIndex + 1
        let subject = titleTextView.text ?? ""
        let content = entryTextView.text ?? ""
        
        
        journalEntry = JournalEntry(loggedTime: loggedTime!, type: type!, category: category, moodNumber: moodNumber, mood: mood, subject: subject, content: content)
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
    
    func checkButtonState(_ sender: UIButton) -> Bool {
        if(sender.isSelected) {
            return true
        } else {
            return false
        }
    }
    
}
