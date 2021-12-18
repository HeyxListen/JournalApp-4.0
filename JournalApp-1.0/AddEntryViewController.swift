//
//  AddEntryViewController.swift
//  JournalApp-1.0
//
//  Created by STEPHENCOFFARO on 12/10/21.
//

import UIKit

class AddEntryViewController: UIViewController, UITabBarControllerDelegate, UITextViewDelegate {
    
    
    
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var doneButton: UIBarButtonItem!
    //Question1 Outlets
    @IBOutlet var question1StackView: UIStackView!
    @IBOutlet var nameIntroLabel: UILabel!
    @IBOutlet var feelingSlider: UISlider!
    @IBOutlet var question1NextButton: UIButton!
    
    //Question2 Outlets
    @IBOutlet var question2StackView: UIStackView!
    @IBOutlet var manualEntryButton: UIButton!
    @IBOutlet var promptButton: UIButton!
    @IBOutlet var quoteReflectionButton: UIButton!
    @IBOutlet var goalObjectiveButton: UIButton!
    
    //Question2AOutlets - Goal Check In
    @IBOutlet var question2AStackView: UIStackView!
    @IBOutlet var goal1Button: UIButton!
    @IBOutlet var goal1Label: UILabel!
    @IBOutlet var goal2Button: UIButton!
    @IBOutlet var goal2Label: UILabel!
    @IBOutlet var goal3Button: UIButton!
    @IBOutlet var goal3Label: UILabel!
        
    //Question3 Outlets
    @IBOutlet var question3StackView: UIStackView!
    @IBOutlet var titleTextView: UITextView!
    @IBOutlet var entryTextView: UITextView!
    @IBOutlet var question3NextButton: UIButton!
    @IBOutlet var refreshPromptButton: UIButton!
    var entryType: String = ""
    
    //Question4 Outlets
    @IBOutlet var question4StackView: UIStackView!
    @IBOutlet var workButton: UIButton!
    @IBOutlet var schoolButton: UIButton!
    @IBOutlet var relationshipButton: UIButton!
    @IBOutlet var financeButton: UIButton!
    @IBOutlet var healthButton: UIButton!
    @IBOutlet var goalsButton: UIButton!
    @IBOutlet var submitEntryButton: UIButton!
    
    //
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidLoad() {
        //self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        super.viewDidLoad()
        initialUIView()
        entryTextView.delegate = self
    }
    
    func initialUIView() {
        if (userProfile.name == "") {
            nameIntroLabel.text = "Hello!"
        } else {
            nameIntroLabel.text = "Hello, \(userProfile.name)!"
            
            
        }
        
        doneButton.isEnabled = false
        question1StackView.isHidden = false
        feelingSlider.value = 3
        question2StackView.isHidden = true
        question2AStackView.isHidden = true
        question3StackView.isHidden = true
        question3NextButton.isEnabled = false
        question4StackView.isHidden = true
    }
    
    
    @IBAction func question1NextButton(_ sender: Any) {
        question1StackView.isHidden = true
        question2StackView.isHidden = false
        goalObjectiveButton.isEnabled = checkIfGoalsSetInProfile()
    }
    
    func checkIfGoalsSetInProfile() -> Bool{
        if (userProfile.goal1 == "" && userProfile.goal2 == "" && userProfile.goal3 == "") {
            return false
        } else {
            return true
        }
    }
    
    @IBAction func question2NextButton(_ sender: UIButton) {
        
        switch sender {
        case manualEntryButton:
            question2StackView.isHidden = true
            question3StackView.isHidden = false
            refreshPromptButton.isHidden = true
            entryType = "Manual"
            titleTextView.isEditable = true
        case promptButton:
            question2StackView.isHidden = true
            //question2AStackView.isHidden = false
            question3StackView.isHidden = false
            titleTextView.text = "PROMPT: \(prompts.randomElement()!.prompt)"
            refreshPromptButton.setTitle("Refresh Prompt", for: .normal)
            entryType = "Prompt"
            titleTextView.isEditable = false
        case quoteReflectionButton:
            let selectedQuote = quotes.randomElement()!
            question2StackView.isHidden = true
            question3StackView.isHidden = false
            titleTextView.text = "QUOTE REFLECTION: \(selectedQuote.quote) - \(selectedQuote.author)"
            refreshPromptButton.setTitle("Refresh Quote", for: .normal)
            entryType = "Quote"
            titleTextView.isEditable = false
        case goalObjectiveButton:
            question2StackView.isHidden = true
            question2AStackView.isHidden = false
            refreshPromptButton.isHidden = true
            entryType = "Goal"
            titleTextView.isEditable = false
            //Goal #1
            if (userProfile.goal1 == "") {
                goal1Button.isEnabled = false
                goal1Label.text = "Goal #1 has not yet been set. Go to the profile tab to set a goal."
            } else {
            goal1Label.text = "\(userProfile.goal1)"
            }

            //Goal #2
            if (userProfile.goal2 == "") {
                goal2Button.isEnabled = false
                goal2Label.text = "Goal #2 has not yet been set. Go to the profile tab to set a goal."
            } else {
            goal2Label.text = "\(userProfile.goal2)"
            }
            //Goal #3
            if (userProfile.goal3 == "") {
                goal3Button.isEnabled = false
                goal3Label.text = "Goal #3 has not yet been set. Go to the profile tab to set a goal."
            } else {
            goal3Label.text = "\(userProfile.goal3)"
            }
            
        default:
            question2StackView.isHidden = true
            question3StackView.isHidden = false
            refreshPromptButton.isHidden = true
        }
    }
    
    @IBAction func goalChosen(_ sender: UIButton) {
        switch sender {
        case goal1Button:
            titleTextView.text = "Goal #1: \(userProfile.goal1)"
        case goal2Button:
            titleTextView.text = "Goal #2: \(userProfile.goal2)"
        case goal3Button:
            titleTextView.text = "Goal #3: \(userProfile.goal3)"
        default:
            question2StackView.isHidden = true
            question3StackView.isHidden = false
            refreshPromptButton.isHidden = true
        }
        question2AStackView.isHidden = true
        question3StackView.isHidden = false
    }
    
    
    @IBAction func newPrompt(_ sender: Any) {
        if (entryType == "Prompt") {
            titleTextView.text = "PROMPT: \(prompts.randomElement()!.prompt)"
            entryTextView.text = ""
        } else {
            let selectQuote = quotes.randomElement()!
            titleTextView.text = "QUOTE REFLECTION: \(selectQuote.quote) - \(selectQuote.author)"
            entryTextView.text = ""
        }
        checkIfEntryIsPopulated()
    }
    
    @IBAction func question3NextButton(_ sender: Any) {
        question3StackView.isHidden = true
        question4StackView.isHidden = false
        submitEntryButton.isEnabled = false
    }
    
    @IBAction func selectCategoryButton(_ sender: UIButton) {
        
        if sender.isSelected == false {
        sender.isSelected = true
        } else {
            sender.isSelected = false
        }
        checkEnableSubmitEntryButton()
            }
    
    func checkEnableSubmitEntryButton() {
        if (workButton.isSelected == true || schoolButton.isSelected == true || relationshipButton.isSelected == true || financeButton.isSelected == true || healthButton.isSelected == true || goalsButton.isSelected == true)
        {
        doneButton.isEnabled = true
            submitEntryButton.isEnabled = true
        }
        else {
            doneButton.isEnabled = false
            submitEntryButton.isEnabled = false
        }
    }
  
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "saveUnwind" else { return }
        
        let title = titleTextView.text ?? ""
        let entry = entryTextView.text ?? ""
        let moodInt = Int(round(feelingSlider.value))
        let mood = getEmoji(emojiValue: moodInt)
        let loggedTime = getTime()
        let entryType = entryType
        let category = JournalEntry.Category(work: checkButtonState(workButton), school: checkButtonState(schoolButton), relationships: checkButtonState(relationshipButton), finances: checkButtonState(financeButton), health: checkButtonState(healthButton), goals: checkButtonState(goalsButton))
        
        journalEntry = JournalEntry(loggedTime: JournalEntry.TimeOfEntry(year: loggedTime.year, monthNumber: loggedTime.monthNumber, monthString: loggedTime.monthString, monthAbv: loggedTime.monthAbv, day: loggedTime.day, dayInYear: loggedTime.dayInYear, dayOfWeek: loggedTime.dayOfWeek, time: loggedTime.time), type: entryType, category: category, moodNumber: moodInt, mood: mood, subject: title, content: entry)
    }
    
    var journalEntry: JournalEntry?
    
    //custom initializer
    
    init?(coder: NSCoder, journalEntry: JournalEntry?) {
        self.journalEntry = journalEntry
        super.init(coder: coder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func getTodaysDate() -> String {
        let currentDate = Date()
        
        let formatter = DateFormatter()
        formatter.timeStyle = .long
        formatter.dateStyle = .long
        
        let dateString = formatter.string(from: currentDate)
        return dateString
    }
            
        func checkButtonState(_ sender: UIButton) -> Bool {
            if(sender.isSelected) {
                return true
            } else {
                return false
            }
        }
    
    func checkIfEntryIsPopulated() {
        
    let titleText = titleTextView.text ?? ""
    let entryText = entryTextView.text ?? ""
       
    question3NextButton.isEnabled = !titleText.isEmpty && !entryText.isEmpty
    }
    
    func textViewDidChange(_ entryTextView: UITextView) {
        checkIfEntryIsPopulated()
    }
       
}

