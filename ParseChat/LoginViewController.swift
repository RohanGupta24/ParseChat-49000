//
//  ViewController.swift
//  ParseChat
//
//  Created by Kyle Ohanian on 1/29/18.
//  Copyright © 2018 Kyle Ohanian. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    

    
    @IBAction func onSignUp(_ sender: Any) {
        let newUser = PFUser()
        
        // set user properties
        
        let usernameA = usernameTextField.text ?? ""
        let passwordA = passwordTextField.text ?? ""
        
        newUser.username = usernameA
        newUser.password = passwordA
        
        // call sign up function on the object
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("User Registered successfully")
                // manually segue to logged in view
                PFUser.logInWithUsername(inBackground: usernameA, password: passwordA) { (user: PFUser?, error: Error?) in
                    if let error = error {
                        print("User log in failed: \(error.localizedDescription)")
                    } else {
                        print("User logged in successfully")
                        self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func onLogin(_ sender: Any) {
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("User log in failed: \(error.localizedDescription)")
            } else {
                print("User logged in successfully")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

