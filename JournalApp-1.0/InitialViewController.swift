//
//  ViewController.swift
//  JournalApp-1.0
//
//  Created by csuftitan on 12/1/21.
//

import UIKit

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
    }


}

