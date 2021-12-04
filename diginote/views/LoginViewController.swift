//
//  LoginViewController.swift
//  diginote
//
//  Created by Sayed Jahed Hussini on 11/29/21.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore 

class LoginViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBAction func onSignIn(_ sender: Any) {
        let userEmail = emailField.text!
        let userPassword = passwordField.text!
        
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            
            if error != nil {
                print("Couldn't sign up: \(error?.localizedDescription)")
            } else {
                self!.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        let userEmail = emailField.text!
        let userPassword = passwordField.text!
        
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { authResult, error in
            if error != nil {
                print("Couldn't sign up: \(error?.localizedDescription)")
            } else {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let darkModeEnabled = UserDefaults.standard.bool(forKey: "darkModeEnabled")
        
        if #available(iOS 13.0, *){
            if darkModeEnabled {
                UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
            }else {
                UIApplication.shared.windows.first?.overrideUserInterfaceStyle  = .light
            }
        }
        
       
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
