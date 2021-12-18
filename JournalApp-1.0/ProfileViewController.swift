//
//  ProfileViewController.swift
//  JournalApp-1.0
//
//  Created by csuftitan on 12/15/21.
//

import UIKit

class ProfileViewController: UIViewController {
    
    //var profiles: Profile?
    
    var profiles: [Profile] = [] {
        didSet {
            Profile.saveToFile(profiles: profiles)
        }
    }
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var goal1TextField: UITextField!
    @IBOutlet var goal2TextField: UITextField!
    @IBOutlet var goal3TextField: UITextField!
    @IBOutlet var inspirationalQuoteSwitch: UISwitch!
    @IBOutlet var morningReminderSwitch: UISwitch!
    @IBOutlet var eveningReminderSwitch: UISwitch!
    @IBOutlet var updateProfileButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedProfiles = Profile.loadFromFile() {
            profiles = savedProfiles
        }
    }
        
    
//    init?(coder: NSCoder, profiles: Profile?) {
//        self.profiles = profiles
//        super.init(coder: coder)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
    
    @IBAction func updateSettingsButtonPressed(_ sender: UIButton) {
        let name = nameTextField.text ?? ""
        let goal1 = goal1TextField.text ?? ""
        let goal2 = goal2TextField.text ?? ""
        let goal3 = goal3TextField.text ?? ""
        userProfile = Profile(name: name, goal1: goal1, goal2: goal2, goal3: goal3)
    }
}
