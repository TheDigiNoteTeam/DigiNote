//
//  SettingsViewController.swift
//  diginote
//
//  Created by Sayed Jahed Hussini on 12/3/21.
//

import UIKit

class SettingsViewController: UIViewController {

    let onColor = UIColor(red: 1/255.0, green: 4/255.0, blue: 73/255.0, alpha: 1)
    let offColor = UIColor.white
    
    @IBOutlet weak var themeIconView: UIView!
    @IBOutlet weak var themeIconImageView: UIImageView!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var themeSwitch: UISwitch!
    
    @IBAction func themeSwitchClicked(_ sender: Any) {
        let mySwitch = sender as? UISwitch
        
        let defaults = UserDefaults.standard
        UserDefaults.standard.set(mySwitch?.isOn, forKey: "darkThemeSwitchState")
        
        if #available(iOS 13.0, *){
            let appDelegate = UIApplication.shared.windows.first
            if self.themeSwitch.isOn {
                appDelegate?.overrideUserInterfaceStyle = .dark
                defaults.set(true, forKey: "darkModeEnabled")
                return
            }
            appDelegate?.overrideUserInterfaceStyle = .light
            defaults.set(false, forKey: "darkModeEnabled")
            return
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        themeSwitch.isOn = UserDefaults.standard.bool(forKey: "darkThemeSwitchState")

    }
    
  

    
}
