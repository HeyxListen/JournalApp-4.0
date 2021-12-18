//
//  LaunchScreenViewController.swift
//  JournalApp-1.0
//
//  Created by csuftitan on 12/17/21.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    @IBOutlet var window: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        perform(Selector(("showHomeScreen")), with: nil, afterDelay: 3)

        // Do any additional setup after loading the view.
    }
    
    func showNavigationController() {
    performSegue(withIdentifier: "showSplashScreen", sender: self)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        RunLoop.current.run(until: NSDate(timeIntervalSinceNow:1) as Date)

        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
