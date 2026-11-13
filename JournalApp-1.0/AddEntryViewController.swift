// xcode: set sdk=iOS

//
//  AddEntryViewController.swift
//  JournalApp-1.0
//
//  Created by STEPHENCOFFARO on 12/10/21.
//

import UIKit

class AddEntryViewController: UIViewController, UITabBarControllerDelegate, UITextViewDelegate, UIGestureRecognizerDelegate {
    
    
    
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
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var entryLabel: UILabel!
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

    private let entryScrollView = UIScrollView()
    private let titleHintLabel = UILabel()
    private var titleTextViewHeightConstraint: NSLayoutConstraint!
    private var entryTextViewHeightConstraint: NSLayoutConstraint!
    private var editableTitleBackgroundColor: UIColor?
    private lazy var moodSliderTapGestureRecognizer = UITapGestureRecognizer(
        target: self,
        action: #selector(selectMoodFromSliderTap(_:))
    )
    
    //
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidLoad() {
        //self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        super.viewDidLoad()
        initialUIView()
        configureKeyboardAwareEntryForm()
        configureMoodSlider()
        configureEntryTextViews()
        titleTextView.delegate = self
        entryTextView.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateEntryTextViewHeights()
    }

    private func configureEntryTextViews() {
        editableTitleBackgroundColor = titleTextView.backgroundColor
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        entryLabel.font = .preferredFont(forTextStyle: .headline)
        entryLabel.adjustsFontForContentSizeCategory = true
        titleTextView.font = .preferredFont(forTextStyle: .body)
        titleTextView.adjustsFontForContentSizeCategory = true
        entryTextView.font = .preferredFont(forTextStyle: .body)
        entryTextView.adjustsFontForContentSizeCategory = true

        titleHintLabel.font = .preferredFont(forTextStyle: .subheadline)
        titleHintLabel.adjustsFontForContentSizeCategory = true
        titleHintLabel.textColor = .secondaryLabel
        titleHintLabel.numberOfLines = 0
        titleHintLabel.isHidden = true

        if let titleStackView = titleTextView.superview as? UIStackView {
            titleStackView.insertArrangedSubview(titleHintLabel, at: 1)
        }

        titleTextView.isScrollEnabled = false
        entryTextView.isScrollEnabled = false

        let storyboardHeightConstraints = titleTextView.constraints.filter {
            $0.firstAttribute == .height
        }
        NSLayoutConstraint.deactivate(storyboardHeightConstraints)

        titleTextViewHeightConstraint = titleTextView.heightAnchor.constraint(equalToConstant: 60)
        entryTextViewHeightConstraint = entryTextView.heightAnchor.constraint(equalToConstant: 180)
        NSLayoutConstraint.activate([titleTextViewHeightConstraint, entryTextViewHeightConstraint])

        question3StackView.spacing = 20
        updateEntryTextViewHeights()
    }

    private func updateEntryTextViewHeights() {
        guard
            titleTextViewHeightConstraint != nil,
            entryTextViewHeightConstraint != nil,
            titleTextView.bounds.width > 0,
            entryTextView.bounds.width > 0
        else {
            return
        }

        updateHeight(
            of: titleTextView,
            constraint: titleTextViewHeightConstraint,
            minimumHeight: 60,
            maximumHeight: 180
        )
        updateHeight(
            of: entryTextView,
            constraint: entryTextViewHeightConstraint,
            minimumHeight: 180,
            maximumHeight: 360
        )
    }

    private func updateHeight(
        of textView: UITextView,
        constraint: NSLayoutConstraint,
        minimumHeight: CGFloat,
        maximumHeight: CGFloat
    ) {
        let fittingSize = textView.sizeThatFits(
            CGSize(width: textView.bounds.width, height: .greatestFiniteMagnitude)
        )
        let desiredHeight = max(minimumHeight, ceil(fittingSize.height))
        let newHeight = min(desiredHeight, maximumHeight)
        if abs(constraint.constant - newHeight) > 0.5 {
            constraint.constant = newHeight
        }
        textView.isScrollEnabled = desiredHeight > maximumHeight
    }

    private func setTitlePresentation(title: String, hint: String?, editable: Bool) {
        titleLabel.text = title
        titleHintLabel.text = hint
        titleHintLabel.isHidden = hint == nil
        titleTextView.isEditable = editable
        titleTextView.backgroundColor = editable
            ? (editableTitleBackgroundColor ?? .secondarySystemBackground)
            : .secondarySystemBackground
        titleTextView.textColor = editable ? .label : .secondaryLabel
        updateEntryTextViewHeights()
    }

    private func configureMoodSlider() {
        guard let slider = feelingSlider else { return }

        slider.minimumValue = 1
        slider.maximumValue = 5
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(moodSliderValueChanged(_:)), for: .valueChanged)

        moodSliderTapGestureRecognizer.cancelsTouchesInView = false
        moodSliderTapGestureRecognizer.delegate = self
        // The storyboard gives the slider and emoji row a shared container.
        // Listening on that container makes both the track and emoji row tappable.
        slider.superview?.addGestureRecognizer(moodSliderTapGestureRecognizer)
    }

    @objc private func moodSliderValueChanged(_ slider: UISlider) {
        slider.value = min(max(round(slider.value), slider.minimumValue), slider.maximumValue)
    }

    @objc private func selectMoodFromSliderTap(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let slider = feelingSlider else { return }

        let trackRect = slider.trackRect(forBounds: slider.bounds)
        let minimumThumb = slider.thumbRect(
            forBounds: slider.bounds,
            trackRect: trackRect,
            value: slider.minimumValue
        )
        let maximumThumb = slider.thumbRect(
            forBounds: slider.bounds,
            trackRect: trackRect,
            value: slider.maximumValue
        )
        let usableWidth = maximumThumb.midX - minimumThumb.midX
        guard usableWidth > 0 else { return }

        let tappedX = gestureRecognizer.location(in: slider).x
        let fraction = min(max((tappedX - minimumThumb.midX) / usableWidth, 0), 1)
        let value = slider.minimumValue + Float(fraction) * (slider.maximumValue - slider.minimumValue)
        slider.setValue(round(value), animated: true)
    }

    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        gestureRecognizer === moodSliderTapGestureRecognizer ||
        otherGestureRecognizer === moodSliderTapGestureRecognizer
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
        entryScrollView.isHidden = true
        question3NextButton.isEnabled = false
        question4StackView.isHidden = true
    }

    /// Moves the storyboard's entry form into a scroll view whose bottom follows
    /// the keyboard, so the active text view and Next button remain reachable.
    private func configureKeyboardAwareEntryForm() {
        let oldConstraints = view.constraints.filter {
            ($0.firstItem as? UIView) === question3StackView ||
            ($0.secondItem as? UIView) === question3StackView
        }
        NSLayoutConstraint.deactivate(oldConstraints)
        question3StackView.removeFromSuperview()

        entryScrollView.translatesAutoresizingMaskIntoConstraints = false
        entryScrollView.isHidden = true
        entryScrollView.keyboardDismissMode = .interactive
        entryScrollView.alwaysBounceVertical = true
        view.addSubview(entryScrollView)
        entryScrollView.addSubview(question3StackView)

        NSLayoutConstraint.activate([
            entryScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            entryScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            entryScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            entryScrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),

            question3StackView.leadingAnchor.constraint(equalTo: entryScrollView.contentLayoutGuide.leadingAnchor, constant: 15),
            question3StackView.trailingAnchor.constraint(equalTo: entryScrollView.contentLayoutGuide.trailingAnchor, constant: -15),
            question3StackView.topAnchor.constraint(equalTo: entryScrollView.contentLayoutGuide.topAnchor, constant: 10),
            question3StackView.bottomAnchor.constraint(equalTo: entryScrollView.contentLayoutGuide.bottomAnchor, constant: -10),
            question3StackView.widthAnchor.constraint(equalTo: entryScrollView.frameLayoutGuide.widthAnchor, constant: -30)
        ])
    }
    
    
    @IBAction func question1NextButton(_ sender: Any) {
        question1StackView.isHidden = true
        question2StackView.isHidden = false
        goalObjectiveButton.isEnabled = checkIfGoalsSetInProfile()
    }
    
    func checkIfGoalsSetInProfile() -> Bool{
        userProfile.goals.contains { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }
    
    @IBAction func question2NextButton(_ sender: UIButton) {
        
        switch sender {
        case manualEntryButton:
            question2StackView.isHidden = true
            question3StackView.isHidden = false
            entryScrollView.isHidden = false
            refreshPromptButton.isHidden = true
            entryType = "Manual"
            titleTextView.text = ""
            entryTextView.text = ""
            setTitlePresentation(title: "Title", hint: nil, editable: true)
        case promptButton:
            question2StackView.isHidden = true
            //question2AStackView.isHidden = false
            question3StackView.isHidden = false
            entryScrollView.isHidden = false
            titleTextView.text = prompts.randomElement()!.prompt
            entryTextView.text = ""
            refreshPromptButton.setTitle("Refresh Prompt", for: .normal)
            entryType = "Prompt"
            setTitlePresentation(
                title: "Prompt",
                hint: "Provided for you. Write your response in the Entry box below.",
                editable: false
            )
        case quoteReflectionButton:
            let selectedQuote = quotes.randomElement()!
            question2StackView.isHidden = true
            question3StackView.isHidden = false
            entryScrollView.isHidden = false
            titleTextView.text = "\(selectedQuote.quote) — \(selectedQuote.author)"
            entryTextView.text = ""
            refreshPromptButton.setTitle("Refresh Quote", for: .normal)
            entryType = "Quote"
            setTitlePresentation(
                title: "Quote Reflection",
                hint: nil,
                editable: false
            )
        case goalObjectiveButton:
            question2StackView.isHidden = true
            question2AStackView.isHidden = false
            refreshPromptButton.isHidden = true
            entryType = "Goal"
            setTitlePresentation(
                title: "Goal",
                hint: "This is your selected goal. Write your check-in in the Entry box below.",
                editable: false
            )
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
            entryScrollView.isHidden = false
            refreshPromptButton.isHidden = true
            setTitlePresentation(title: "Title", hint: nil, editable: true)
        }
        updateEntryTextViewHeights()
        checkIfEntryIsPopulated()
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
        entryScrollView.isHidden = false
        setTitlePresentation(
            title: "Goal",
            hint: "This is your selected goal. Write your check-in in the Entry box below.",
            editable: false
        )
        checkIfEntryIsPopulated()
    }
    
    
    @IBAction func newPrompt(_ sender: Any) {
        if (entryType == "Prompt") {
            titleTextView.text = prompts.randomElement()!.prompt
            entryTextView.text = ""
        } else {
            let selectQuote = quotes.randomElement()!
            titleTextView.text = "\(selectQuote.quote) — \(selectQuote.author)"
            entryTextView.text = ""
        }
        updateEntryTextViewHeights()
        checkIfEntryIsPopulated()
    }
    
    @IBAction func question3NextButton(_ sender: Any) {
        titleTextView.resignFirstResponder()
        entryTextView.resignFirstResponder()
        entryScrollView.isHidden = true
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
    
    private func checkIfEntryIsPopulated() {
        let hasTitle = !(titleTextView.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let hasEntry = !(entryTextView.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        question3NextButton.isEnabled = hasTitle && hasEntry
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateEntryTextViewHeights()
        checkIfEntryIsPopulated()
    }
       
}
